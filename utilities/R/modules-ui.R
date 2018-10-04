aboutUI <- function() {
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
                  choices = c('United States', state.name),
                  selected = 'United States')
    ))
  )
}



standardInterventionsUI <- function() {
  fluidRow(
    column(12,
           tags$h1("Prebuilt Scenarios")
    ),
    column(6, 
           includeMarkdown("inst/md/standard-interventions.md")
    )
  )
}


customInterventionsUI <- function() {
  tagList(
    br(),
           p(
             "Use the custom Targeted Testing and Treatment to create scenarios that simulate
             additional screening of specific risk groups over a period of specified years. Targeted groups
             can be specified by their risk, age, and nativity status. Custom risk groups can be defined by specifying
             rate ratios of LTBI prevalence, progression, and mortality."
           ),
  tabsetPanel(
    id = 'currentlySelectedTTT',
    tabPanel(
      title = "Intervention 1",
      value = 1,
      tags$br(),
      intervention_content(1)
    ),
    tabPanel(
      title = "Intervention 2",
      value = 2,
      tags$br(),
      intervention_content(2)
    ),
    tabPanel(
      title = "Intervention 3",
      value = 3,
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
      tabsetPanel(
        tabPanel("Targeted Testing and Treatment Interventions", {
          customInterventionsUI()
          }),
        tabPanel("Program Changes", {
          programChanges()
          }),
        tabPanel("Custom Scenarios", {
          tagList(
            br(),
            p("Custom Scenarios allow users to simulate combinations of Targeted Testing 
and Treatment interventions and Program Changes."),
          tabsetPanel(
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
    p("Program Changes allow users to change model parameters related to the 
LTBI treatment and active TB treatment care cascades."),
  tabsetPanel(id = "currentlySelectedProgramChange",
    tabPanel(title = "Program Change 1", value = 1, {
      programChangePanel(1)
    }),
    tabPanel(title = "Program Change 2", value = 2, {
      programChangePanel(2)
    }),
    tabPanel(title = "Program Change 3", value = 3, {
      programChangePanel(3)
    })
  )
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
        numericInput(inputId = paste0(id, "CoverageRate"),
                    label = "Screening Coverage Rate as a Multiple of the Current Rate",
                    value = 1, min = 1, max = 5),
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
        uiOutput(paste0('custom', n, 'TTTRadios')),
        uiOutput(paste0('custom', n, 'ProgramChangeRadios'))
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

debugPrintouts <- function() {
  uiOutput('debugPrintouts')
}

comparisonDataChoices <- c(
  total_population = "Population: Total, US, and Non-US Born",
  `total-deaths-by-age` = "Total TB Deaths by Age Group",
  percent_of_cases_in_non_usb = "Percent of TB Cases in Non-US-Born 2000-2014",
  `percent-of-non-usb-cases-in-recent-immigrants` = "Percent of Non-US Born Cases Arrived in Past 2 Years",
  mortality_by_age = "Mortality by Age",
  mortality = "Mortality: Total, US, and Non-US Born",
  `ltbi-prev-by-age-usb` = "LTBI in US Born Population by Age",
  `ltbi-prev-by-age-non-usb` = "LTBI in Non-US Born Population by Age",
  diagnosed_cases_2000 = "Total TB Cases Identified, 2000-2014",
  diagnosed_cases_1953 = "Total TB Cases Identified, 1953-2014",
  age_distribution_all_ages = "Total Population by Age Group 2014",
  age_distribution = "Population by Age for Non-US Born and US Born",
  treatment_outcomes = "Treatment Outcomes"
)
  
  
  

comparison_to_recent_data <- function() {
  tagList(fluidRow(
    column(12, h2("Comparison to Recent Data")),
    column(
      width = 4,
      class = "tab-content",
      radioButtons(inputId = "comparisonDataChoice",
                   label = "Select an option below to compare the model's performance to observed data.", 
                   choices = as.character(comparisonDataChoices))
    ),
    column(
      width = 8,
      class = "tab-content",
      plotOutput('calib_total_population', height = '500px')
    )
  ))
}
