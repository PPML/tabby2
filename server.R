#
#                        Shiny App Server for Tabby2 ----
#                    ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ 
# 
#   This R script, in conjunction with ui.R, runs the application Tabby2. In
#   particular, this server script handles the processing of user input, running
#   MITUS based on that input, and returning the output as data and plots.
#
#   This server includes the following components: 
# 
#   Reactive Values 
#    ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅
# 
#   Custom Scenarios
#    ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ 
#       Render the user input for the specification of custom scenarios
#       incorporating the names of the targeted testing and treatment scenarios
#       and the program changes the user has previously specified.
# 
#   Output Server
#    ̅ ̅ ̅ ̅ ̅ ̅̅ ̅ ̅ ̅ ̅ ̅̅ ̅ ̅  
#       Produce output given the user input. For the time being, this runs 
#       the codebase of Tabby (1) as a module to serve the content from the 
#       original application as a demonstration. This section of code will be
#       updated to run MITUS for each of the custom scenarios the user specifies
#       and to produce corresponding outputs, including downloads and plots.
#   
#   Custom Scenarios Choice in Output
#    ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅̅ ̅ ̅ ̅ ̅ 
#       Provide choices for which custom scenarios are plotted in the outcome
#       figures. This chunk of code appends the names of the user-defined custom
#       scenarios to the scenarios available in a checkbox group for toggling on
#       or off in the plots.
# 
#   Plots for Comparison to Recent Data
#    ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅̅ ̅̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅̅ ̅ ̅ ̅ ̅ 
#       Fetch plots depicting a comparison of model performance to the data
#       available. First a reactive element computes the path to the RDS file
#       containing the plot corresponding to the user's choice in which
#       comparison to visualize, then the RDS file is read and the plot object
#       is rendered as output with renderPlot.
#       
#   Debug Print Server
#    ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅
#       To help with debugging the reactive values used in this application, a 
#       debugging option can be turned on inside the application which adds 
#       another sidebarPanel to the application in which the contents of the 
#       values object is rendered as text. To use this feature, assign
#       debug <- TRUE before running the application via runApp().


library(shiny)
library(shinydashboard)
library(shinyjs)
library(MITUS)
devtools::load_all("utilities")
source("tabby1/tabby1dependencies.R")
devtools::load_all("tabby1/tabby1utilities")
source("tabby1/tabby1global.R")

risk_group_rate_ratios <- load_risk_group_data()

shinyServer(function(input, output, session) {

	# --------------------------------------------------------------------------
  # Globally Available Helper Function & Reactive
  # Geography Short Code
  # Get the abbreviated version of the geography name -- i.e. United States ->
  # US, Massachusetts -> MA
	# --------------------------------------------------------------------------

	# Geography Short Code
  geo_short_code <- reactive({
    l <- state.abb
    names(l) <- state.name
    l <- c(`United States` = "US", l)
    l[[input$state]]
  })

  # Output the Selected Geography
  output$location_selected <- renderUI({
    tags$a(paste0("Location: ", input$state))
  })

  output$geo_short_code <- renderText({ geo_short_code() })

	# ---------------------------------------------------------------------------
	#  Reactive Values 
	#   ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅
	#    The reactive values store the user's input for targeted testing and
	#    treatment scenarios and program changes.
	# 
	#    To allow the user to have multiple targeted testing and treatment
	#    scenarios as well as multiple program changes, we add to the scenario
	#    specification input a choice for which scenario (of 1 through 3) the
	#    user is defining. Their input is then filled into the corresponding
	#    reactive values.
	# 
	#    This approach is preferred to having separate input for each of the
	#    scenarios and program changes because it saves space as compared to
	#    rendering separate input for each of the 3 available scenarios to fill
	#    in.
	# --------------------------------------------------------------------------
	
	#  Setup `values` to contain our reactiveValues. 
  values <- reactiveValues()

	#  The ttt_template list is going to be used three times later in filling 
	#  in constructing placeholders inside the reactive `values` object 
	# 
	#  These list elements correspond to the values the user can set in the TTT
	#  panel of the application.
	ttt_template <- list(
    name = NULL,
    risk_group = NULL,
    nativity_group = NULL,
    age_group = NULL,
    number_targeted = NULL,
    fraction_screened_annually = NULL,
    start_year = NULL,
    stop_year = NULL,
    rate_ratio_progression = 1,
    rate_ratio_mortality = 1,
    rate_ratio_prevalence = 1
  )

	# The programChanges_template is used later to fill in placeholders inside
	# the reactive `values` object.
	# 
	#  These list elements correspond to the values the user can set in the
	#  program changes panel of the application.
  programChanges_template <- list(
    name = NULL,
    ltbi_screening_coverage_multiplier = NULL,
    fraction_receiving_igra = NULL,
    fraction_accepting_ltbi_treatment = NULL,
    fraction_completing_ltbi_treatment = NULL,
    average_time_to_treatment_active = NULL,
    fraction_defaulting_from_treatment_active = NULL
  )

	# Use the ttt_template and programChanges_template to construct placeholders
	# for the scenarios inside the reactive `values` object.
	# 
	# Each of the 3 definable TTT and Program Changes will be given their own 
	# place within `values`, i.e. 1, 2, & 3 inside 
	# values[['scenarios']][['ttt']]` and similar for program changes.
  values[['scenarios']] <-
    list(
      ttt = list(ttt_template,
                 ttt_template,
                 ttt_template),
      program_changes = list(programChanges_template,
                             programChanges_template,
                             programChanges_template))
  
	# Watch for Updates to Custom Scenarios
  # 
	# Now we run `observe` module that fills in `values[['scenarios']][['ttt']]`
	# and `values[['scenarios']][['program_changes']]` accordingly. 
	# 
	# This is done by watching for changes in the currentlySelectedTTT and 
	# currentlySelectedProgramChanges. 
  observe({
		# ttt_to_update is a safe version of currentlySelectedTTT
    ttt_to_update <- ifelse(
      is.null(input$currentlySelectedTTT),
      1,
      as.integer(input$currentlySelectedTTT)
    )

		# Use ttt_to_update to get the specifications for the TTT scenario that is 
		# currently being defined.
    n <- ttt_to_update
    tttn <- paste0("ttt", n)
    tttName <- paste0(tttn, "name")
    tttRisk <- paste0(tttn, "risk")
    tttAge <- paste0(tttn, "agegroups")
    tttNativity <- paste0(tttn, "nativity")
    tttNumberTargeted <- paste0(tttn, "numberTargeted")
    tttFractionScreened <- paste0(tttn, "fumberScreened")
    tttStartYear <- paste0(tttn, "startyear")
    tttStopYear <- paste0(tttn, "stopyear")
    tttProgression <- paste0(tttn, "progression-rate")
    tttPrevalence <- paste0(tttn, "prevalence-rate")
    tttMortality <- paste0(tttn, "mortality-rate")
    
    # Fill the user-input into the `values` object.
    values[['scenarios']][['ttt']][[ttt_to_update]][['name']] = input[[tttName]]
    values[['scenarios']][['ttt']][[ttt_to_update]][['risk_group']] = input[[tttRisk]]
    values[['scenarios']][['ttt']][[ttt_to_update]][['nativity_group']] = input[[tttNativity]]
    values[['scenarios']][['ttt']][[ttt_to_update]][['age_group']] = input[[tttAge]]
    values[['scenarios']][['ttt']][[ttt_to_update]][['number_targeted']] = input[[tttNumberTargeted]]
    values[['scenarios']][['ttt']][[ttt_to_update]][['fraction_screened_annually']] = input[[tttFractionScreened]]
    values[['scenarios']][['ttt']][[ttt_to_update]][['start_year']] = input[[tttStartYear]]
    values[['scenarios']][['ttt']][[ttt_to_update]][['stop_year']] = input[[tttStopYear]]
    
    # program_changes_to_update is the safe version of 
		# input$currentlySelectedProgramChange
    program_change_to_update <-
      if (is.null(input$currentlySelectedProgramChange)) 1
    else as.integer(input$currentlySelectedProgramChange)
    
		# Use program_change_to_update to get the specification for the Program
		# Change scenario that is currently being defined.
    pcn <- paste0("programChange", program_change_to_update)
    programChangeName = paste0(pcn, 'Name')
    programChangeLtbi_screening_coverage_multiplier = paste0(pcn, "CoverageRate")
    programChangeFraction_receiving_igra = paste0(pcn, "IGRACoverage")
    programChangeFraction_accepting_ltbi_treatment = paste0(pcn, "AcceptingTreatmentFraction")
    programChangeFraction_completing_ltbi_treatment = paste0(pcn, "CompletionRate")
    programChangeAverage_time_to_treatment_active = paste0(pcn, "AverageTimeToTreatment")
    programChangeFraction_defaulting_from_treatment_active = paste0(pcn, "DefaultRate")
    
    # Fill the user-input into the `values` object.
    values[['scenarios']][['program_changes']][[program_change_to_update]] <-
      list(
        name = input[[programChangeName]],
        ltbi_screening_coverage_multiplier = input[[programChangeLtbi_screening_coverage_multiplier]],
        fraction_receiving_igra = input[[programChangeFraction_receiving_igra]],
        fraction_accepting_ltbi_treatment = input[[programChangeFraction_accepting_ltbi_treatment]],
        fraction_completing_ltbi_treatment = input[[programChangeFraction_completing_ltbi_treatment]],
        average_time_to_treatment_active = input[[programChangeAverage_time_to_treatment_active]],
        fraction_defaulting_from_treatment_active = input[[programChangeFraction_defaulting_from_treatment_active]]
      )
  })
  
  
	# In the following reactives and observeEvent code-blocks we store and render
	# the risk groups' relative rates of LTBI prevalence, mortality, and 
	# latent to active progression. 

	# ttt_to_update is a safe version of currentlySelectedTTT
  ttt_to_update <- reactive({ ifelse(
    is.null(input$currentlySelectedTTT),
    1,
    as.integer(input$currentlySelectedTTT)
  )
  })
  
	# Use ttt_to_update to get the names of the risk-groups' relative-rate fields
  tttn <- reactive({ paste0("ttt", ttt_to_update()) })
  tttRisk <- reactive({ paste0(tttn(), "risk") })
  tttProgression <- reactive({ paste0(tttn(), "progression-rate") })
  tttPrevalence <- reactive({ paste0(tttn(), "prevalence-rate") })
  tttMortality <- reactive({ paste0(tttn(), "mortality-rate") })
  
  observeEvent(input[[tttRisk()]], {
    
    if (input[[tttRisk()]] == 'All Individuals') {
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_progression']]  <- 1
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_prevalence']]  <- 1
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_mortality']]  <- 1
      
    } else if (input[[tttRisk()]] != 'Define a Custom Risk Group') {
      rate_ratio_row <- which(risk_group_rate_ratios$population == as.character(input[[tttRisk()]]))
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_progression']]  <- risk_group_rate_ratios[[rate_ratio_row, 2]]
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_prevalence']]  <-  risk_group_rate_ratios[[rate_ratio_row, 3]]
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_mortality']]  <- risk_group_rate_ratios[[rate_ratio_row, 4]]
      
    } else { # Custom Risk Group
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_progression']]  <- input[[tttProgression()]]
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_prevalence']]  <- input[[tttPrevalence()]]
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_mortality']]  <- input[[tttMortality()]]
      
    }
    
    output$ttt1risk_group_rate_ratios <-  renderUI({ isolate({
      wellPanel(
        tags$h4("Risk Group Rate Ratios"),
        fluidRow(
          column(
            6,
            numericInput(
              inputId = isolate({ tttProgression() }),
              label = "Rate Ratio of LTBI Progression",
              min = 1,
              max = 40,
              value = isolate({ values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_progression']]}), 
              width = '200px'
            )
          ),
          column(
            6,
            numericInput(
              inputId = tttPrevalence(),
              label = "Rate Ratio of LTBI Prevalence",
              min = 1,
              max = 40,
              value = values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_prevalence']],
              width = '200px'
            )
          ),
          column(
            6,
            numericInput(
              inputId = tttMortality(),
              label = "Rate Ratio of Mortality",
              min = 1,
              max = 40,
              value = values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_mortality']],
              width = '200px'
            )
          )
        )
      )
    })  })
    
    output$ttt2risk_group_rate_ratios <-  renderUI({ isolate({
      wellPanel(
        tags$h4("Risk Group Rate Ratios"),
        fluidRow(
          column(
            6,
            numericInput(
              inputId = isolate({ tttProgression() }),
              label = "Rate Ratio of LTBI Progression",
              min = 1,
              max = 40,
              value = isolate({ values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_progression']]}), 
              width = '200px'
            )
          ),
          column(
            6,
            numericInput(
              inputId = tttPrevalence(),
              label = "Rate Ratio of LTBI Prevalence",
              min = 1,
              max = 40,
              value = values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_prevalence']],
              width = '200px'
            )
          ),
          column(
            6,
            numericInput(
              inputId = tttMortality(),
              label = "Rate Ratio of Mortality",
              min = 1,
              max = 40,
              value = values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_mortality']],
              width = '200px'
            )
          )
        )
      )
    })  })
    
    output$ttt3risk_group_rate_ratios <-  renderUI({ isolate({
      wellPanel(
        tags$h4("Risk Group Rate Ratios"),
        fluidRow(
          column(
            6,
            numericInput(
              inputId = isolate({ tttProgression() }),
              label = "Rate Ratio of LTBI Progression",
              min = 1,
              max = 40,
              value = isolate({ values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_progression']]}), 
              width = '200px'
            )
          ),
          column(
            6,
            numericInput(
              inputId = tttPrevalence(),
              label = "Rate Ratio of LTBI Prevalence",
              min = 1,
              max = 40,
              value = values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_prevalence']],
              width = '200px'
            )
          ),
          column(
            6,
            numericInput(
              inputId = tttMortality(),
              label = "Rate Ratio of Mortality",
              min = 1,
              max = 40,
              value = values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_mortality']],
              width = '200px'
            )
          )
        )
      )
    })  })
    
    
  })
  

    observeEvent(
      input[[tttProgression()]], {
        disable(tttProgression())
        if (input[[tttRisk()]] == 'Define a Custom Risk Group') {
          enable(tttProgression())
        }
      })

    observeEvent(
      input[[tttPrevalence()]], {
        disable(tttPrevalence())
        if (input[[tttRisk()]] == 'All Individuals') {
          disable(tttPrevalence())
        } else if (input[[tttRisk()]] != 'Define a Custom Risk Group') {
          disable(tttPrevalence())
        } else { # Custom Risk Group
          enable(tttPrevalence())
        }
      })

    observeEvent(
      input[[tttMortality()]], {
        disable(tttMortality())
        if (input[[tttRisk()]] == 'All Individuals') {
          disable(tttMortality())
        } else if (input[[tttRisk()]] != 'Define a Custom Risk Group') {
          disable(tttMortality())
        } else { # Custom Risk Group
          enable(tttMortality())
        }
      })

    # ⠀⠀TTT Number Targeted
    # These are to display in the summary statistics for the TTT interventions.
    output$ttt1numberTargeted <- renderText({input$ttt1numberTargeted})
    output$ttt2numberTargeted <- renderText({input$ttt2numberTargeted})
    output$ttt3numberTargeted <- renderText({input$ttt3numberTargeted})
    
  # Custom Scenarios ----
  
  # These are the options for TTT Interventions (by Name) available as 
  # choices in the Custom Scenarios.
  renderTTTRadioChoice <- function(n) {
    renderUI({
      radioButtons(
        inputId = paste0('scenario', n, "TLTBI"),
        label = "Select a Targeted LTBI Treatment Intervention",
        choices = c(
          "No Intervention",
          if (input$ttt1name != '') input$ttt1name else NULL,
          if (input$ttt2name != '') input$ttt2name else NULL,
          if (input$ttt3name != '') input$ttt3name else NULL))
    })
  }
  output$custom1TTTRadios <- renderTTTRadioChoice(1)
  output$custom2TTTRadios <- renderTTTRadioChoice(2)
  output$custom3TTTRadios <- renderTTTRadioChoice(3)
  
  # These are the options for Program Changes (by Name) available as 
  # choices in the Custom Scenarios.
  renderProgramChangesChoice <- function(n) {
    renderUI({
      radioButtons(
        inputId = paste0('scenario', n, "ProgramChange"),
        label = "Select a Program Change",
        choices = c(
          "No Change", 
          if (input$programChange1Name != '') input$programChange1Name else NULL,
          if (input$programChange2Name != '') input$programChange2Name else NULL,
          if (input$programChange3Name != '') input$programChange3Name else NULL))
    })
  }
  
  output$custom1ProgramChangeRadios <- renderProgramChangesChoice(1)
  output$custom2ProgramChangeRadios <- renderProgramChangesChoice(2)
  output$custom3ProgramChangeRadios <- renderProgramChangesChoice(3)
  
  # Next/Back Page Buttons ----
  observeEvent(input$toPredefinedScenarios, updateTabItems(session = session, inputId = 'sidebar', selected = "predefined"))
  observeEvent(input$toAbout, updateTabItems(session = session, inputId = 'sidebar', selected = "about"))
  observeEvent(input$toEstimates, updateTabItems(session = session, inputId = 'sidebar', selected = "estimates"))
  observeEvent(input$toBuildScenarios, updateTabItems(session = session, inputId = 'sidebar', selected = "customscenarios"))
  
  
  # MITUS Interaction Server ----
  output$mitus_df <- renderDataTable(get_data_and_run_model())
  
  # Output Server ----
  # ⠀Tabby1 Server ----
  callModule(module = tabby1Server, id = "tabby1", ns = NS("tabby1"), geo_short_code = geo_short_code) 
  
  output$downloadParameters <- downloadHandler(
    filename = function() { "input_parameters.yaml" },
    content = function(file) { cat(yaml::as.yaml(reactiveValuesToList(input)), file = file) })
  
  # Custom Scenarios Choice in Output ----
  # These are the Model Scenarios available in the Outcomes - Estimates page
  output$estimatesInterventions <- renderUI({
    checkboxGroup2(
        id = paste0('tabby1-', estimates$IDs$controls$interventions),
        heading = estimates$interventions$heading,
        labels = c(
          estimates$interventions$labels,
          if (input$scenario1Name != '') input$scenario1Name else NULL,
          if (input$scenario2Name != '') input$scenario2Name else NULL,
          if (input$scenario3Name != '') input$scenario3Name else NULL
        ),
        values = estimates$interventions$values
      )
  })
  
  # These are the Model Scenarios available in the Outcomes - Trends page
  output$trendsInterventions <- renderUI({
      checkboxGroup2(
      id = paste0('tabby1-', trends$IDs$controls$interventions),
      heading = trends$interventions$heading,
      labels = c(
        estimates$interventions$labels,
        if (input$scenario1Name != '') input$scenario1Name else NULL,
        if (input$scenario2Name != '') input$scenario2Name else NULL,
        if (input$scenario3Name != '') input$scenario3Name else NULL
      ),
      values = trends$interventions$values
    )
  })
  
  # These are the Model Scenarios available in the Outcomes - Ages page
  output$agesInterventions <- renderUI({
      checkboxGroup2(
      id = paste0('tabby1-', agegroups$IDs$controls$interventions),
      heading = agegroups$interventions$heading,
      labels = c(
        estimates$interventions$labels,
        if (input$scenario1Name != '') input$scenario1Name else NULL,
        if (input$scenario2Name != '') input$scenario2Name else NULL,
        if (input$scenario3Name != '') input$scenario3Name else NULL
      ),
      values = agegroups$interventions$values
    )
  })
  
  # Plots for Comparison to Recent Data ----
  
  # comparisonDataChoices is a vector mapping the filenames (without .rds) or
  # short-versions of the calibration data targets to their proper names as they
  # appear in the titles of the calibration plots.
  comparisonDataChoices <- c(
    total_population = "Population: Total, US, and Non-US Born",
    `total-deaths-by-age` = "Total TB Deaths by Age Group",
    percent_of_cases_in_non_usb = "Percent of TB Cases in Non-US-Born 2000-2014",
    `percent-of-non-usb-cases-in-recent-immigrants` = "Percent of Non-US Born Cases Arrived in Past 2 Years",
    mortality_by_age = "Mortality by Age",
    mortality = "Mortality: Total, US, and Non-US Born",
    `ltbi-prev-by-age-usb` = "LTBI in US Born Population by Age",
    `ltbi-prev-by-age-non-usb` = "LTBI in Non-US Born Population by Age",
    diagnosed_cases_2006 = "Total TB Cases Identified, 2006-2016",
    age_distribution_all_ages = "Total Population by Age Group 2014",
    age_distribution = "Population by Age for Non-US Born and US Born",
    treatment_outcomes = "Treatment Outcomes",
    `age-distribution-of-cases` = "TB Cases By Age (2000-16)"
  )
  
  # Reverse comparisonDataChoices so that we can look up short codes from the 
  # users choice, given as the proper name (with spaces and title casing). 
  # This is used in the comparison_to_recent_data_plot_path reactive below.
  comparisonDataChoices_rev <- names(comparisonDataChoices)
  names(comparisonDataChoices_rev) <- unlist(comparisonDataChoices)
  
  # Render the options for calibration data targets  (Comparison to Recent Data)
  # depending on the geo_short_code (geography selected by the user). This is
  # dynamic because the states and US differ in which data targets are available
  # / calibrated to.
  output$comparison_to_recent_data_buttons <- renderUI({
    req(input[['state']])
    radioButtons(
      inputId = "comparisonDataChoice",
      label = "Select an option below to compare the model's performance to observed data.",
      choices = as.character(comparisonDataChoices[
        gsub(".rds",
             "",
             list.files(
               paste0("utilities/inst/calibration_plots/", geo_short_code(), "/")
             ))])
    )
  })
  
  # Get the path to the comparison plot chosen by the user
  comparison_to_recent_data_plot_path <- reactive({
    req(input[['comparisonDataChoice']], input[['state']])
    file <- comparisonDataChoices_rev[input$comparisonDataChoice]
    return(paste0('calibration_plots/', geo_short_code(), '/', file, ".rds"))
  })
  
  # Render the calibration data target from its RDS file
  output$calib_data_target_plot <- renderPlot({
    readRDS(system.file(comparison_to_recent_data_plot_path(), package = 'utilities'))
  })
  
  # Debug Printout Server ----
  if (exists('debug', envir = .GlobalEnv) && isTRUE(debug)) {
    output$debugPrintouts <- renderUI({ 
      tagList(
        HTML(paste0(capture.output(Hmisc::list.tree(reactiveValuesToList(values), maxlen = 80)), collapse = "<br>")),
        dataTableOutput('mitus_df')
      )
    })
  }
})
