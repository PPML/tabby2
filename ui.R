library(shiny)

# Relevant Documentation Articles:

# Some Layout Examples with Navbar TabPanels
# https://shiny.rstudio.com/articles/layout-guide.html

# User Interface Section of Shiny Documentation Articles
# https://shiny.rstudio.com/articles/#user-interface

# HTML templates look like they're going to be very 
# important in designing custom 508 compliant componenets.
# https://shiny.rstudio.com/articles/templates.html

# shinyWidgets has some good examples of building custom 
# components. This might be helpful for "prettifying" 
# the application later and as examples for how we might
# build custom components to satisfy 508 compliance.
# https://dreamrs.github.io/shinyWidgets/index.html


shinyUI(
  # navbar ----
  navbarPage(
    "Tabby2",
    # about ----
    tabPanel("About", {
      fluidRow(
        column(8, includeMarkdown("inst/md/about.md")),
        column(4, wellPanel(
          # __ select your state ----
          tags$h4("Select Your State"),
          tags$p(
            "Specify your state to load the corresponding data into Tabby2 and to adjust model parameters accordingly."
          ), 
          selectInput(inputId = "state",
                      label = "",
                      choices = c("California"))
        ))
      )
    }),
    # standard interventions ----
    tabPanel("Standard Interventions", {
      fluidRow(
        column(8, 
          includeMarkdown("inst/md/standard-interventions.md")
        ),
        column(4, wellPanel(
          tags$h4("Standard Intervention Scenarios"),
          HTML("<hr style='height:3px; visibility:hidden; margin:0;' />"),
          checkboxInput("input1", "TLTBI for New Immigrants"),
          checkboxInput("input2", "Improved TLTBI in the United States"),
          checkboxInput("input3", "Better Case Detection"),
          checkboxInput("input4", "Better TB Treatment"),
          checkboxInput("input5", "All Improvements"),
          tags$br(),
          tags$h4("Additional Scenarios"),
          HTML("<hr style='height:3px; visibility:hidden; margin:0;' />"),
          checkboxInput("input6", "No Transmission Within the United States after 2016"),
          checkboxInput("input7", "No LTBI Among Immigrants after 2016")
        ))
      )
    }),
    # custom interventions ----
    tabPanel("Custom Interventions", {
      fluidRow(
        column(6, includeMarkdown("inst/md/custom-interventions.md"),
               tags$br()),
        # define intervention ----
        column(6, tabsetPanel(
          tabPanel("Intervention 1",
            tags$br(),
            fluidRow(
              column(
                6,
                wellPanel(
                  tags$h4("Define Intervention"),
                  textInput(inputId = "custom1-name", label = "Name Custom Intervention:"),
                  radioButtons(
                    inputId = "custom1risk",
                    label = "Select Targeted Risk Groups",
                    choices = c(
                      "All Individuals",
                      "HIV Positive",
                      "Diabetics",
                      "Custom Risk Group"
                    )
                  ),
                  radioButtons(
                    inputId = "custom1agegroups",
                    label = "Select Targeted Age Groups",
                    choices = c("All Ages", "0 to 24", "25 to 64", "65+")
                  ),
                  radioButtons(
                    inputId = "custom1nativity",
                    label = "Select Targeted Nativity Groups",
                    choices = c("All Ages", "U.S. Born", "Non-U.S. Born")
                  ),
                  sliderInput(
                    inputId = "custom1numberscreened",
                    label = "Select Number of Individuals Screened",
                    min = 0,
                    max = 10000,
                    value = 0,
                    step = 10
                  )
                )
              ),
              # __ define custom risk group ----
              column(
                6,
                wellPanel(
                  tags$h4("Targeted Population Summary Statistics"),
                  tags$p("Incidence: 5.1%\n"),
                  tags$p("LTBI Prevalence: 12.5%")
                ),
                conditionalPanel(
                  condition = "input.custom1risk == 'Custom Risk Group'",
                  wellPanel(
                    # style = "overflow-y:scroll; max-height: 350px",
                    tags$h4("Define Custom Risk Group"),
                    sliderInput(
                      inputId = "custom1-mortality-risk",
                      label = "Specify Targeted Population's Relative Mortality Risk (%)",
                      min = 0,
                      max = 140,
                      value = 100
                    ),
                    sliderInput(
                      inputId = "custom1-reactivation-risk",
                      label = "Specify Targeted Population's Relative LTBI Progression Risk (%)",
                      min = 0,
                      max = 140,
                      value = 100
                    ),
                    sliderInput(
                      inputId = "custom1-treatment-initiation-rate",
                      label = "Specify Targeted Population's Relative LTBI Prevalence Risk (%)",
                      min = 0,
                      max = 140,
                      value = 100
                    )
                  )
                )
              )
            )
          ),
          tabPanel("Intervention 2", {}),
          tabPanel("Intervention 3", {})
          )
        )
      )
    }),
    tabPanel("Outcomes", {
    })
))
