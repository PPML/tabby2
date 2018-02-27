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
  navbarPage(
    "Tabby2",
    tabPanel("About", {
      fluidRow(
        column(8, includeMarkdown("inst/md/about.md")),
        column(4, wellPanel(
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
    tabPanel("Custom Interventions", {
      fluidRow(
        column(6, includeMarkdown("inst/md/custom-interventions.md"),
               tags$br()),
        column(6, tabsetPanel(
          tabPanel("Intervention 1",
            tags$br(),
            fluidRow(
              column(6, 
                textInput(inputId = "custom1-name", label = "Name Custom Intervention:"),
                radioButtons(
                  inputId = "custom1-agegroups", 
                  label = "Select Targeted Age Groups",
                  choices = c("All Ages", "0 to 24", "25 to 64", "65+")
                  ),
                radioButtons(
                  inputId = "custom1-nativity",
                  label = "Select Targeted Nativity Groups",
                  choices = c("All Ages", "U.S. Born", "Non-U.S. Born")
                ),
                radioButtons(
                  inputId = "custom1-risk",
                  label = "Select Targeted Risk Groups",
                  choices = c("All Individuals", "HIV Positive", "Diabetics")
                )
              ),
              column(6, 
                sliderInput(
                  inputId = "custom1-mortality-risk",
                  label = "Adjust Targeted Population's Mortality Risk (%)",
                  min = 0, 
                  max = 100,
                  value = 0
                ),
                sliderInput(
                  inputId = "custom1-reactivation-risk",
                  label = "Adjust Targeted Population's Reactivation Risk (%)",
                  min = 0, 
                  max = 100,
                  value = 0
                ),
                sliderInput(
                  inputId = "custom1-additional-screening",
                  label = "Select Additional Number of Individuals Screened",
                  min = 0, 
                  max = 10000,
                  value = 0,
                  step = 10
                ),
                sliderInput(
                  inputId = "custom1-treatment-initiation-rate",
                  label = "Specify Improvement in Treatment Initiation Rates (%)",
                  min = 0,
                  max = 100,
                  value = 0
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
