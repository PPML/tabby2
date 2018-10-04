library(shiny)
library(shinydashboard)
devtools::load_all("utilities")
source("tabby1/tabby1dependencies.R")
devtools::load_all("tabby1/tabby1utilities")
source("tabby1/tabby1global.R")


shinyServer(function(input, output, session) {
  
  # Reactive Values ----
  values <- reactiveValues()
  # template for targeted testing & treatment
  ttt_template <- list(
    name = NULL,
    risk_group = NULL,
    nativity_group = NULL,
    age_group = NULL,
    number_targeted = NULL,
    fraction_screened_annually = NULL,
    start_year = NULL,
    stop_year = NULL,
    rate_ratio_progression = NULL,
    rate_ratio_mortality = NULL,
    rate_ratio_prevalence = NULL
  )
  # template for the program changes
  programChanges_template <- list(
    name = NULL,
    ltbi_screening_coverage_multiplier = NULL,
    fraction_receiving_igra = NULL,
    fraction_accepting_ltbi_treatment = NULL,
    fraction_completing_ltbi_treatment = NULL,
    average_time_to_treatment_active = NULL,
    fraction_defaulting_from_treatment_active = NULL
  )
  values[['scenarios']] <-
    list(
      ttt = list(ttt_template,
                 ttt_template,
                 ttt_template),
      program_changes = list(programChanges_template,
                             programChanges_template,
                             programChanges_template),
      scenarios = list(list(),
                       list(),
                       list())
    )
  observe({
    ttt_to_update <- ifelse(
      is.null(input$currentlySelectedTTT),
      1,
      as.integer(input$currentlySelectedTTT)
    )

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
    tttProgression <- paste0(tttn, "progression-rate-slider")
    tttPrevalence <- paste0(tttn, "prevalence-rate-slider")
    tttMortality <- paste0(tttn, "mortality-rate-slider")
    
    
    values[['scenarios']][['ttt']][[ttt_to_update]] <-
      list(
        name = input[[tttName]],
        risk_group = input[[tttRisk]],
        nativity_group = input[[tttNativity]],
        age_group = input[[tttAge]],
        number_targeted = input[[tttNumberTargeted]],
        fraction_screened_annually = input[[tttFractionScreened]],
        start_year = input[[tttStartYear]],
        stop_year = input[[tttStopYear]],
        rate_ratio_progression = input[[tttProgression]],
        rate_ratio_mortality = input[[tttMortality]],
        rate_ratio_prevalence = input[[tttPrevalence]]
      )
    
    program_change_to_update <-
      if (is.null(input$currentlySelectedProgramChange)) 1
    else as.integer(input$currentlySelectedProgramChange)
    
    pcn <- paste0("programChange", program_change_to_update)
    programChangeName = paste0(pcn, 'Name')
    programChangeLtbi_screening_coverage_multiplier = paste0(pcn, "CoverageRate")
    programChangeFraction_receiving_igra = paste0(pcn, "IGRACoverage")
    programChangeFraction_accepting_ltbi_treatment = paste0(pcn, "AcceptingTreatmentFraction")
    programChangeFraction_completing_ltbi_treatment = paste0(pcn, "CompletionRate")
    programChangeAverage_time_to_treatment_active = paste0(pcn, "AverageTimeToTreatment")
    programChangeFraction_defaulting_from_treatment_active = paste0(pcn, "DefaultRate")
    
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
  
  # Scenarios Server ----
  
  # __TTT Number Targeted
  # These are to display in the summary statistics for the TTT interventions.
  output$ttt1numberTargeted <- renderText({input$ttt1numberTargeted})
  output$ttt2numberTargeted <- renderText({input$ttt2numberTargeted})
  output$ttt3numberTargeted <- renderText({input$ttt3numberTargeted})
  
  
  # __TTT Intervention Scenarios as Choices in Custom Scenarios ----
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
  
  # Output Server ----
  # __Tabby1 Server ----
  callModule(module = tabby1Server, id = "tabby1", ns = NS("tabby1")) 
  
  output$downloadParameters <- downloadHandler(
    filename = function() { "input_parameters.yaml" },
    content = function(file) { cat(yaml::as.yaml(reactiveValuesToList(input)), file = file) })
  
  # __Options for Outcomes from Custom Scenarios ----
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
  
  # __ Plots for Comparison to Recent Data
  
  comparison_to_recent_data_plot_path <- reactive({
    file <- names(comparisonDataChoices)[[which(comparisonDataChoices == input$comparisonDataChoice)]]
    return(paste0('calibration_plots/US/', file, ".rds"))
  })
  output$calib_total_population <- renderPlot({
    readRDS(system.file(comparison_to_recent_data_plot_path(), package = 'utilities'))
  })
  
  # Debug Printout Server ----
  if (exists('debug', envir = .GlobalEnv) && isTRUE(debug)) {
    output$debugPrintouts <- renderUI({ 
      HTML(paste0(capture.output(Hmisc::list.tree(reactiveValuesToList(values), maxlen = 80)), collapse = "<br>"))
    })
  }
  
  
})
