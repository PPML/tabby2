aboutUI <- function() {
  fluidRow(
    column(12, h1("About TabbyII")),
    column(6, includeMarkdown("inst/md/about.md")),
    column(6, wellPanel(
      tags$h4("Select a Location"),
      tags$p(
        "After specifying a location, TabbyII will load historical data and model parameters calibrated to that location."
      ), 
      selectInput(inputId = "state",
                  label = "Select a Location",
                  choices = c('United States', state.name),
                  selected = 'United States')
    ))
  )
}



standardInterventionsUI <- function() {
  fluidRow(
    column(12,
           tags$h1("Standard Interventions")
    ),
    column(6, 
           includeMarkdown("inst/md/standard-interventions.md")
    ),
    column(6, wellPanel(
      tags$h4("Standard Intervention Scenarios"),
      HTML("<hr style='height:3px; visibility:hidden; margin:0;' />"),
      checkboxInput("input1", "TLTBI for New Immigrants"),
      checkboxInput("input2", "Improved TLTBI in the United States"),
      checkboxInput("input3", "Better Case Detection"),
      checkboxInput("input4", "Better TB Treatment"),
      checkboxInput("input5", "All Improvements")
    ))
  )
}


customInterventionsUI <- function() {
  # fluidRow(
    # column(12, h1("Targeted LTBI Testing and Treatment")),
    # column(6, includeMarkdown("inst/md/custom-interventions.md")),
    # column(12, 
           # define intervention ----
           tabsetPanel(
             tabPanel("Intervention 1",
                      tags$br(),
                      intervention_content(1)),
             tabPanel("Intervention 2", 
                      tags$br(),
                      intervention_content(2)),
             tabPanel("Intervention 3", 
                      tags$br(),
                      intervention_content(3))
           )
    # )
  # )
}

scenariosUI <- function() {
  fluidRow(
    column(
      12,
      tags$h1("Build Custom Model Scenarios"),
      tabsetPanel(
        tabPanel("Targeted Testing and Treatment Interventions", {
          customInterventionsUI()
          }),
        tabPanel("Program Changes", {
          programChanges()
          }),
        tabPanel("Custom Scenarios", {
          tabsetPanel(
            customScenarioPanel(1),
            customScenarioPanel(2),
            customScenarioPanel(3)
          )
        })
      )
    )
  )
}

programChanges <- function() {
  tabsetPanel(
    tabPanel("Program Change 1", {
      programChangePanel(1)
    }),
    tabPanel("Program Change 2", {
      programChangePanel(2)
    }),
    tabPanel("Program Change 3", {
      programChangePanel(3)
    })
  )
}

programChangePanel <- function(n) {
  id <- paste0("programChange", n)
  return(
    wellPanel(
      fluidRow(
        column(6, 
               tags$h4("Define a Program Change"),
        textInput(inputId = paste0(id, "Name"),
                  label = "Program Change Name",
                  placeholder = paste0("Program Change ", n))
        )),
      fluidRow(
      column(6, {
        tagList(
        tags$h4("LTBI Treatment Cascade:"),
        column(6, {
          selectInput(inputId = paste0("programChanges", n, "RiskGroup"), 
                      label = "Risk Group for Adjusted Coverage Rate", 
                      choices = risk_groups)
        }),
        column(6, {
        numericInput(inputId = paste0(id, "CoverageRate"),
                    label = "Screening Coverage Rate as a Multiple of the Current Rate for the Selected Risk Group",
                    value = 1, min = 1, max = 5)
        }),
        numericInput(inputId = paste0(id, "IGRACoverage"),
                     label = "Fraction of Individuals Receiving IGRA (%)",
                     value = 0, min = 0, max = 100),
        numericInput(inputId = paste0(id, "AcceptingTreatmentFraction"),
                     label = "Fraction of Individuals Testing Positive who Accept Treatment (%)",
                     value = 1, min = 0, max = 100),
        numericInput(inputId = paste0(id, "CompletionRate"),
                     label = "Fraction of Individuals Initiating Treatment Who Complete Treatment (%)",
                     value = 1, min = 0, max = 100)
        )
      }),
      column(6, {
        tagList(
      tags$h4("TB Treatment Cascade:"),
      numericInput(inputId = paste0(id, "AverageTimeToTreatment"),
                   label = "Average Time to Treatment of an Incident Case as a Multiple of the Current Rate (0-100% of current value).",
                   value = 1, min = 0, max = 100),
      numericInput(inputId = paste0(id, "DefaultRate"),
                   label = "Fraction Discontinuing/Defaulting from Treatment (%)",
                   value = 0, min = 0, max = 100)
        )
      })
                  
    )
    )
  )
  
}

customScenarioPanel <- function(n) {
  scenarion <- paste0("scenario", n)
  return(
    tabPanel(
      title = paste0("Custom Scenario ", n),
      wellPanel(
        tags$h4("Define a Custom Scenario"),
        textInput(
          label = "Scenario Name",
          inputId = paste0(scenarion, "Name"),
          placeholder = paste0("Custom Scenario ", n)),
        uiOutput(paste0('custom', n, 'ScenarioRadios')),
        radioButtons(
          inputId = paste0(scenarion, "Prebuilt"),
          label = "Select a Pre-Built Scenario",
          choices = c(
            "No Change",
            "TLTBI for New Immigrants",
            "Improved TLTBI in the United States",
            "Better Case Detection",
            "Better TB Treatment",
            "All Improvements")),
        radioButtons(
          label = "Select a TLTBI Regimen Change",
          inputId = paste0(scenarion, "Regimen"),
          choices = c(
            "No Change",
            "Decreased Treatment Default Rates",
            # "Shorter Regimen",
            "Better Sensitivity/Specificity",
            "Updated 12-Week 3HP Regimen",
            "IGRA instead of TST"
            ))
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


downloadsAndSettingsUI <- function() {
  fluidRow(
    column(
      4,
      wellPanel(
        h1("Downloads"),
        br(),
"By downloading the user interface settings and the model outcomes
at the same time, projections from TabbyII can be saved with the 
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


readmoreUI <- function() {
  fluidRow(
    column(8, includeMarkdown("inst/md/readmore.md"))
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
