outputIncludeCustomScenarioOptions <- function(input, output, session) { 
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
}
