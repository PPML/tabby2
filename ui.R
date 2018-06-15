library(shiny)
devtools::load_all("utilities")

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
        column(12, h1("About Tabby2")),
        column(6, includeMarkdown("inst/md/about.md")),
        column(6, wellPanel(
          # __ select your state ----
          tags$h4("Select your Location"),
          tags$p(
            "After specifying your location, Tabby2 will load historical data and model parameters calibrated to your state."
          ), 
          selectInput(inputId = "state",
                      label = "Select Your State",
                      choices = c('United States', state.name),
                      selected = 'United States')
        ))
      )
    }),
    # standard interventions ----
    tabPanel("Standard Interventions", {
      fluidRow(
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
    }),
    # custom interventions ----
    tabPanel("Custom Interventions", {
      fluidRow(
        column(8, includeMarkdown("inst/md/custom-interventions.md")),
        column(12, 
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
        )
      )
    }),
    tabPanel("Outcomes", {
      fluidRow(
        selectInput(inputId="plot_outcome", choices = unique(DATA$Output), label = "Choose something to plot"),
        plotOutput('outcome_plot')
      )
    }),
    tabPanel("Import/Export", {
      downloadButton('downloadParameters', 'Download User Interface Parameters')
    })
))


