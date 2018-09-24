library(shiny)
library(shinydashboard)
devtools::load_all("utilities")
source("tabby1/tabby1dependencies.R")
devtools::load_all("tabby1/tabby1utilities")
source("tabby1/tabby1global.R")


shinyServer(function(input, output, session) {
  
  callModule(module = tabby1Server, id = "tabby1", ns = NS("tabby1")) 
  
  # downloadHandler() takes two arguments, both functions.
  # The content function is passed a filename as an argument, and
  #   it should write out data to that filename.
  output$downloadParameters <- downloadHandler(
    
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      "input_parameters.yaml"
    },
    
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      cat(yaml::as.yaml(reactiveValuesToList(input)), file = file)
    }
  )
  
  output$plot_outcome <- renderText({input$plot_outcome})
  
  output$outcome_plot <- renderPlot({
    render_plot(DATA, selected_output = input$plot_outcome)
  })
  
  output$custom1numberTargeted <- renderText({input$custom1numberTargeted})
  output$custom2numberTargeted <- renderText({input$custom2numberTargeted})
  output$custom3numberTargeted <- renderText({input$custom3numberTargeted})
  
  renderScenariosInterventionRadioChoice <- function(n) {
    renderUI({
      radioButtons(
        inputId = paste0('scenarion', n, "TLTBI"),
        label = "Select a Targeted LTBI Treatment Intervention",
        choices = c(
          "No Intervention",
          if (input$custom1name != '') input$custom1name else "Intervention 1",
          if (input$custom2name != '') input$custom2name else "Intervention 2",
          if (input$custom3name != '') input$custom3name else "Intervention 3"))
    })
  }
  
  output$custom1ScenarioRadios <- renderScenariosInterventionRadioChoice(1)
  output$custom2ScenarioRadios <- renderScenariosInterventionRadioChoice(2)
  output$custom3ScenarioRadios <- renderScenariosInterventionRadioChoice(3)
  
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
})
