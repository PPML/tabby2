aboutUI <- function(available_geographies) {
  fluidRow(
    column(12, h1("About Tabby2")),
    column(6, includeMarkdown("inst/md/about.md"), 
           br(), 
           tags$h4(
             "If you are new to Tabby2 or have any questions about the tool, please review our user manual."
           ),
           br(),
           shiny::actionButton(
             inputId = 'toManual',
             label = 'Review User Manual',
             class = 'btn-primary',
             style = 'color: white;'
           )),
    column(6, wellPanel(
      tags$h4("Select a Location"),
      tags$p(
        "After specifying a location, Tabby2 will load historical data and model parameters calibrated to that location."
      ), 
      selectInput(inputId = "state",
                  label = "Select a Location",
                  choices = unname(available_geographies),
                  selected = 'US'),
      shiny::actionButton(
        inputId = 'toPredefinedScenarios',
        label = 'Next Page',
        class = 'btn btn-primary',
        style = 'color: white;'
      )
    ))
  )
}

updateAboutUI <- function(input, output, session, available_geographies) {

  output$aboutUI <- renderUI({
  fluidRow(
    column(12, h1("About Tabby2")),
    column(6, includeMarkdown("inst/md/about.md")),
    column(6, wellPanel(
      tags$h4("Select a Location"),
      tags$p(
        "After specifying a location, Tabby2 will load historical data and model parameters calibrated to that location."
      ), 
      selectInput(inputId = "state",
                  label = "Select a Location",
                  choices = unname(available_geographies),
                  selected = 'US'),
      shiny::actionButton(
        inputId = 'toPredefinedScenarios',
        label = 'Next Page',
        class = 'btn btn-primary',
        style = 'color: white;'
      )
    ))
  )
	})
}

standardInterventionsUI <- function() {
  fluidRow(
    column(12,
           tags$h1("Predefined Scenarios")
    ),
    column(8, 
           includeMarkdown("inst/md/standard-interventions.md"),
           shiny::actionButton(
             inputId = 'toAbout',
             label = 'Back'
           ),
           shiny::actionButton(
             inputId = 'toBuildScenarios',
             label = 'Build Custom Scenarios',
             class = 'btn-primary',
             style = 'color: white;'
           ),
           shiny::actionButton(
             inputId = 'toEstimates',
             label = 'View Modelled Outcomes',
             class = 'btn-primary',
             style = 'color: white;'
           )
    )
  )
}

customInterventionsUI <- function() {
  tagList(
		br(),
		# h4("Inactive - Not Linked to Outcomes"),
    # br(),
           p(
             "Use the Targeted Testing and Treatment input to create scenarios that simulate
             additional screening of specific risk groups over a period of specified years. Targeted groups
             can be specified by their risk, age, and nativity status. Custom risk groups can be defined by specifying
             rate ratios of LTBI prevalence, progression, and mortality."
           ),
  tabsetPanel(
    id = 'currentlySelectedTTT',
    tabPanel(
      title = "Intervention 1",
      value = '1',
      tags$br(),
      intervention_content(1)
    ),
    tabPanel(
      title = "Intervention 2",
      value = '2',
      tags$br(),
      intervention_content(2)
    ),
    tabPanel(
      title = "Intervention 3",
      value = '3',
      tags$br(),
      intervention_content(3)
    )
  )
  )
}

scenariosUI <- function() {
  fluidRow(
    column(
      12,
      tags$h1("Build Custom Model Scenarios"),
			br(),
      tabsetPanel(id = 'CustomScenariosBuilder',
        tabPanel(title = "Targeted Testing and Treatment Interventions", value = 'ttt', {
          customInterventionsUI()
          }),
        tabPanel(title = "Care Cascade Changes", value = 'programchanges', {
          programChanges()
          }),
        tabPanel(title = "Combination Scenarios", value = 'combinationscenarios', {
          tagList(
						br(),
						# h4("Inactive - Not Linked to Outcomes"),
            # br(),
            p("Combination Scenarios allow users to simulate combinations of Targeted Testing 
and Treatment interventions and Care Cascade Changes."),
          tabsetPanel(id = 'combinationScenarios',
            customScenarioPanel(1),
            customScenarioPanel(2),
            customScenarioPanel(3)
          )
          )
        })
      )
    )
  )
}

programChanges <- function() {
  tagList(
    br(),
    p("Care Cascade Changes allow users to change model parameters related to the 
LTBI and TB testing and treatment care cascades. Any change to the parameters below will be modeled as an intervention, 
not an adjustment to the basecase scenario."),
  tabsetPanel(id = "currentlySelectedProgramChange",
    tabPanel(title = "Care Cascade Change 1", value = '1', {
			uiOutput('programChange1')
    }),
    tabPanel(title = "Care Cascade Change 2", value = '2', {
			uiOutput('programChange2')
    }),
    tabPanel(title = "Care Cascade Change 3", value = '3', {
			uiOutput('programChange3')
    })
  )
  )
}

programChangePanel <- function(n, prg_chng) {
  id <- paste0("programChange", n)
  return(
	tagList(
    wellPanel(
      fluidRow(
				column(6, 

			 tags$h4("Define a Care Cascade Change Scenario"),
        textInput(inputId = paste0(id, "Name"),
                  label = "Care Cascade Change Name",
                  placeholder = paste0("Care Cascade Change ", n))
                # Change ", n))
			) #end of column
			), #end of fluid row
      fluidRow(
      column(4, {
        tagList(
        tags$h4("LTBI Treatment Cascade:"),
				numericInput(label = 'Start Year', inputId = paste0(id, "StartYear"),
				             value = 2022, min = 2022, max = 2050),
        numericInput(inputId = paste0(id, "CoverageRate"),
                    label = "Screening Coverage Rate as a Multiple of the Current Rate",
                    value = round(prg_chng['scrn_cov'], 2), min = 1, max = 5),
        numericInput(inputId = paste0(id, "IGRACoverage"),
                     label = "Percentage of Individuals Tested Receiving IGRA (%)",
                     value = round(prg_chng['IGRA_frc']*100, 2), min = 0, max = 100),
        numericInput(inputId = paste0(id, "AcceptingTreatmentFraction"),
                     label = "Percentage of Individuals Testing Positive who Accept Treatment (%)",
                     value = round(prg_chng['ltbi_init_frc']*100, 2), min = 0, max = 100),
        # numericInput(inputId = paste0(id, "CompletionRate"),
        #              label = "Percentage of Individuals Initiating Treatment Who Complete Treatment (%)",
        #              value = round(prg_chng['ltbi_comp_frc']*100, 2), min = 0, max = 100)
        )
      }),
      column(4, {
        tagList(
          tags$h4("LTBI Regimens (Fractions must sum to 1.)"),
          # tags$h5("The sum of the following three values must equal 100%."),

                   tagList(
                    tags$h5("Isoniazid and Rifapentine (3HP)"),
                    fluidRow(
                      column(6,
                      
                   numericInput(inputId = paste0(id, "Fraction3HP"),
                                label = "Percentage of Individuals Receiving this Treatment ",
                                value = round(prg_chng['frc_3hp']*100, 2), min = 0, max = 100) ), 
                   column(6,
                          
                   numericInput(inputId = paste0(id, "Completion3HP"),
                                label = "Percentage of Individuals Who Complete this Treatment",
                                value = round(prg_chng['comp_3hp']*100, 2), min = 0, max = 100)
                    )), #close fluid row
                   tags$h5("Rifampin (4R)"),
                   fluidRow(
                     column(6,
                            
                            numericInput(inputId = paste0(id, "Fraction4R"),
                                         label = "Percentage of Individuals Receiving this Treatment ",
                                         value = round(prg_chng['frc_4r']*100, 2), min = 0, max = 100)), 
                     column(6,
                            
                            numericInput(inputId = paste0(id, "Completion4R"),
                                         label = "Percentage of Individuals Who Complete this Treatment",
                                         value = round(prg_chng['comp_4r']*100, 2), min = 0, max = 100)
                     )), #close fluid row

                     tags$h5("Isoniazid and Rifampin (3HR)"),
                     fluidRow(
                       column(6,
                              
                              numericInput(inputId = paste0(id, "Fraction3HR"),
                                           label = "Percentage of Individuals Receiving this Treatment ",
                                           value = round(prg_chng['frc_3hr']*100, 2), min = 0, max = 100)), 
                       column(6,
                              
                              numericInput(inputId = paste0(id, "Completion3HR"),
                                           label = "Percentage of Individuals Who Complete this Treatment",
                                           value = round(prg_chng['comp_3hr']*100, 2), min = 0, max = 100)
                       )) #close fluid row
            ) )

        # )
      }),
		  column(4, {
			  tagList(
          tags$h4("TB Treatment Cascade:"),
          numericInput(inputId = paste0(id, "AverageTimeToTreatment"),
                       label = "Duration of Infectiousness (0-100% of current value)",
                       value = round(prg_chng['tb_tim2tx_frc'], 2), min = 0, max = 100),
          numericInput(inputId = paste0(id, "DefaultRate"),
                       label = "Percentage Discontinuing/Defaulting from Treatment (%)",
                       value = round(prg_chng['tb_txdef_frc']*100, 2), min = 0, max = 100),
    			tags$br(),
    			actionButton(paste0(id, 'RunSimulations'), label = 'Run Model!', class = 'btn-primary', style = 'color: white;'),
    			actionButton(paste0(id, 'RestoreDefaults'), label = 'Restore Defaults'),
    			disabled(actionButton(paste0(id, 'ChangeSettings'), label = 'Change Settings'))
        )
      }) #end of column 
      ) #end of fluid row 
    ), #end of well panel
		column(12,
			actionButton(
				inputId = paste0('toPredefinedScenarios', 3+n),
				label = 'Back to Predefined Scenarios'
				),
			if (n < 3) { 
				actionButton(
					inputId = paste0('toPC', n+1),
					label = 'Define Another Care Cascade Change Scenario',
					class = 'btn-primary',
					style = 'color: white;'
				)
			} else NULL,
			actionButton(
				inputId = paste0('toCombinationScenarios', n),
				label = 'Build Combination Scenarios',
				class = 'btn-primary',
				style = 'color: white;'
			),
			actionButton(
				inputId = paste0('toEstimates', 3+n),
				label = 'View Modelled Outcomes',
				class = 'btn-primary',
				style = 'color: white;'
			) #end of action button
		) #end column
  ) #end taglist
	) #end return
  
}

customScenarioPanel <- function(n) {
  combinationn <- paste0("combination", n)
  return(
    tabPanel(
      title = paste0("Combination Scenario ", n),
			value = as.character(n),
      wellPanel(
        tags$h4("Define a Combination Scenario"),
        textInput(
          label = "Scenario Name",
          inputId = paste0(combinationn, "Name"),
          placeholder = paste0("Combination Scenario ", n)),
        uiOutput(paste0('combination', n, 'TTTRadios')),
        uiOutput(paste0('combination', n, 'ProgramChangeRadios')),

        actionButton(paste0('combination', n, 'RunSimulations'), label = 'Run Model!', class = 'btn-primary', style = 'color: white;'),
        disabled(actionButton(paste0('combination', n, 'ChangeSettings'), label = 'Change Settings'))
      ),

			column(12,
				actionButton(
					inputId = paste0('toPredefinedScenarios', 6+n),
					label = 'Back to Predefined Scenarios'
					),
				if (n < 3) { 
					actionButton(
						inputId = paste0('toCS', n+1),
						label = 'Define Another Custom Scenario',
						class = 'btn-primary',
						style = 'color: white;'
					)
				} else NULL,
				actionButton(
					inputId = paste0('toEstimates', 6+n),
					label = 'View Modelled Outcomes',
					class = 'btn-primary',
					style = 'color: white;'
				)
			)
    )
  )
}

outcomesUI <- function() {
  sidebarLayout(
    sidebarPanel(
      wellPanel(
        h4("Select Y Axis Data"),
        selectInput(inputId="plot_outcome", choices = c("Incident M. tb Infections", "LTBI Prevalence", "Active TB Incidence", "TB-Related Deaths"), label = "Select Outcome"),
        selectInput(inputId="plot_nativity", choices = c("All", "U.S. Born", "Non-U.S. Born"), label = "Select Nativity Group"),
        selectInput(inputId="plot_age", choices = c("All Ages", "0 to 24", "25 to 64", "65+"), label = "Select Age Group")
      ),
      wellPanel(
        h4("Select X Axis Data"),
        selectInput(inputId="plot_x_axis", choices = c("Year", "Age"), label = "Choose X-axis Variable")
      ),
      wellPanel(
        h4("Select Scenarios"),
        checkboxGroupInput(
          inputId = "selected_scenarios",
          label = "",
          choices = c("Scenario 1", "Scenario 2", "Scenario 3")
        )
      )
    ),
    mainPanel(
      plotOutput('outcome_plot')
    )
  )
}
#' Render the Cost Introduction page Page in Tabby2
#' 
#' This function renders the markdown file in md/aboutcosts.md.
#' 
aboutcostsUI <- function() {
  fluidRow(
    column(8,
           
             includeMarkdown(system.file("md/aboutcosts.md", package='utilities')),
           fluidRow(
             #column(8,""),
             column(8,
             tags$h4("Start an economic analysis:"),
             actionButton(
               inputId = 'toInputCosts3',
               label = 'Input Costs',
               class = 'btn-primary',
               style = 'color: white;'
           )))))
}


inputCostsUI <- function() {
  tagList(
    tags$h1("Input Unit Costs"),
    br(),
    p("For each scenario Tabby2 quantifies health services costs related to treatment of LTBI 
      and TB disease. These are calculated from incremental differences in health service provision
      estimated by the underlying transmission dynamic model cumulated over an analytic horizon 
      and unit costs estimated for each of these services. Please enter unit costs for health services below 
      in United States Dollars and choose the time horizon of interest.
      Currently displayed are average national costs in 2020 USD."),
      uiOutput('inputcosts')
    )
}

##page inputting costs 
inputCostsPanel <- function(cost_inputs) {
  id <-"inputcosts"
  return(
  tagList(
    #LTBI testing costs
    wellPanel(
      fluidRow(
        column(12,
               tags$h3("Enter the average cost for each clinical service (in US dollars)."),
               br()
        ),
        column(4, {
          tagList(
            # tags$h5("Enter intervention associated costs."),
            tags$h4("LTBI Testing Costs:"),
            numericInput(inputId = "LTBIIdCost",
                         label = "Cost of identifiying an individual for LTBI testing",
                         value = cost_inputs[[1]], min = 50, max = 500),
            numericInput(inputId ="TSTCost",
                         label = "Cost of a Mantoux tuberculin skin test (TST)",
                         value = cost_inputs[[2]], min = 0, max = 15),
            numericInput(inputId ="IGRACost",
                         label = "Cost of an IGRA",
                         value = cost_inputs[[3]], min = 0, max = 120),
            numericInput(inputId ="NoTBCost",
                         label = "Cost of ruling out TB disease before LTBI treatment",
                         value = cost_inputs[[4]], min = 0, max = 100)
          )
        }),
        #LTBI treatment costs
        column(4, {
          tagList(
            tags$h4("LTBI Treatment Costs:"),
            numericInput(inputId = "Cost3HP",
                         label = "Cost of treatment with 3HP",
                         value = cost_inputs[[5]], min = 0, max = 1000),
            
            numericInput(inputId = "Cost4R",
                         label = "Cost of treatment with 4R",
                         value = cost_inputs[[6]], min = 400, max = 600),
            
            numericInput(inputId = "Cost3HR",
                         label = "Cost of treatment with 3HR",
                         value = cost_inputs[[7]], min = 0, max = 600)
          ) #end of tag list
        }),#end of column
        #active TB costs
        column(4, {
          tagList(
            tags$h4("Active TB Identification and Treatment Costs:"),
            numericInput(inputId = "TBIdCost",
                         label = "Cost of identifiying an individual for TB testing",
                         value = cost_inputs[[8]], min = 0, max = 500),
            numericInput(inputId ="TBTreatCost",
                         label = "Cost of TB disease treatment",
                         value = cost_inputs[[10]], min = 0, max = 120)
          ) #end of tag list
        }), #end of column
        br(),
      # ),  #end of fluid row 1
        column(12, {
        tagList(
          # tags$h5("Enter intervention associated costs."),
          tags$h4("Other Input:"),
          # numericInput(inputId = "DiscountRate",
          #              label = "Discount rate (%) used for cost-effectiveness analysis",
          #              value = cost_inputs[[11]], min = 1, max = 100, step=1),
          # fluidRow(
            column(
              6,
              numericInput(
                inputId = "CostEndYr",
                label = 'End year for economic analysis',
                min = 2022,
                max = 2050,
                value = cost_inputs[[12]],
                step = 1
              )
            )
          # ) #end of fluid row
        )
      })
      )  #end of fluid row 1
      
    ), #end of well panel 1
    actionButton('CalculateCosts', label = 'Calculate Costs', class = 'btn-primary', style = 'color: white;'),
    actionButton('RestoreDefaultsC', label = 'Restore Defaults'),
    disabled(actionButton('ChangeSettingsC', label = 'Change Settings')),
    actionButton(
      inputId = 'toCostOutputs',
      label = 'View Costs',
      class = 'btn-primary',
      style = 'color: white;'
    )
  ) #end of tagList
  )#end of return 
}
#page for costs and outcomes 
costsOutcomesUI <- function(id){
  ns <- NS(id)
  tagList(fluidRow(
    column(
      width = 2,
      class = "tab-content",
      costsOutcomesControlPanel(ns)
    ),
    column(
      width = 10,
      class = "tab-content",
      costsOutcomesVisualizationPanel(ns)
    )
    # fluidRow(
    #   column(6,
    # actionButton(
    #   inputId = 'toCostComparison',
    #   label = 'View Cost Comparison',
    #   class = 'btn-primary',
    #   style = 'color: white;'
    # )),
    # column(6,
    # actionButton(
    #   inputId = 'toInputCosts',
    #   label = 'Change Unit Costs',
    #   class = 'btn-primary',
    #   style = 'color: white;'
    # ))
    # ) #end internal fluid row
  ))
}
##page for displaying cost comparison
costComparisonUI <- function(id){
  ns <- NS(id)
  tagList(fluidRow(
    column(
      width = 2,
      class = "tab-content",
      costComparisonControlPanel(ns)
    ),
    column(
      width = 10,
      class = "tab-content",
      costComparisonVisualizationPanel(ns)
    )
  ))
}

downloadsAndSettingsUI <- function() {
  fluidRow(
    column(
      4,
      wellPanel(
        h1("Downloads"),
        br(),
"By downloading the user interface settings and the model outcomes
at the same time, projections from Tabby2 can be saved with the 
configuration that yielded those outcomes for reproducible results.",
        br(),
        br(),
        downloadButton('downloadParameters', 'Interface Settings'),
        br(),
        br(),
        downloadButton('downloadTables', "Projection Tables")
      )
    )
  )
}

#' Render the Further Documentation Page in Tabby2
#' 
#' This function renders the markdown file in md/readmore.md.
#' 
readmoreUI <- function() {
  fluidRow(
    column(8, 
           includeMarkdown(system.file("md/readmore.md", package='utilities')))
  )
}

#' Render the Changelog page of Tabby2
#' 
#' This function uses the sessionInfo to retrieve the 
#' current version number of the utilities package, 
#' which is taken to be the version number of Tabby2, 
#' and displays it to the user. 
#' 
#' Below this, the changelog markdown file is rendered & displayed.

changelogUI <- function() {

  # define the sessionInfo so we can get the package version number
  s <- sessionInfo()

  # print an 8-column markdown changelog
  # Changelog
  # This is Tabby2 version x.x.x (get this using sessionInfo)
   
  fluidRow(
    column(8, 
    tags$h1("Changelog"),
    tags$br(),
    tags$strong(paste0("This is Tabby2 version ", 
      # use sessionInfo to get utilities package version number
      s[['otherPkgs']][['utilities']][['Version']],
      ".")),
    tags$br(),
    tags$br(),
    includeMarkdown(system.file("md/changelog.md", package='utilities')))
  )
}

tabby1Estimates <- function(id) {
  ns <- NS(id)
  tagList(fluidRow(
    column(
      width = 4,
      class = "tab-content",
      estimatesControlPanel(ns)
    ),
    column(
      width = 8,
      class = "tab-content",
      estimatesVisualizationPanel(ns)
    )
  ))
}

tabby1TimeTrends <- function(id) {
  ns <- NS(id)
  tagList(fluidRow(
    column(width = 4,
           class = "tab-content",
           trendsControlPanel(ns)),
    column(
      width = 8,
      class = "tab-content",
      trendsVisualizationPanel(ns)
    )
  ))
}

tabby1AgeGroups <- function(id) {
  ns <- NS(id)
  tagList(fluidRow(
    column(
      width = 4,
      class = "tab-content",
      agegroupsControlPanel(ns)
    ),
    column(
      width = 8,
      class = "tab-content",
      agegroupsVisualizationPanel(ns)
    )
  ))
}

addOutputs <- function(id) {
  ns <- NS(id)
  tagList(fluidRow(
    column(
      width = 4,
      class = "tab-content",
      addoutputsControlPanel(ns)
    ), 
    column(
      width = 8,
      class = "tab-content",
      addoutputsVisualizationPanel(ns)
    )
  ))
}

debugPrintouts <- function() {
  uiOutput('debugPrintouts')
}

comparison_to_recent_data <- function() {
  tagList(fluidRow(
    column(
      width = 4,
      class = "tab-content",
      h2("Comparison to Recent Data"),
      uiOutput('comparison_to_recent_data_buttons')
    ),
    column(
      width = 8,
      class = "tab-content",
      plotOutput('calib_data_target_plot', height = '500px')
    )
  ))
}
