outputIncludeCustomScenarioOptions <- function(input, output, session) { 
  # These are the Model Scenarios available in the Outcomes - Estimates page
  output$estimatesInterventions <- renderUI({
    checkboxGroup2(
        id = paste0('tabby1-', estimates$IDs$controls$interventions),
        heading = estimates$interventions$heading,
        labels = c(
          estimates$interventions$labels,
          if (input$ttt1name != '') input$ttt1name else NULL,
          if (input$ttt2name != '') input$ttt2name else NULL,
          if (input$ttt3name != '') input$ttt3name else NULL,
          if (input$programChange1Name != '') input$programChange1Name else NULL,
          if (input$programChange2Name != '') input$programChange2Name else NULL,
          if (input$programChange3Name != '') input$programChange3Name else NULL,
          if (input$scenario1Name != '') input$scenario1Name else NULL,
          if (input$scenario2Name != '') input$scenario2Name else NULL,
          if (input$scenario3Name != '') input$scenario3Name else NULL
        ),
        values = c(
				  estimates$interventions$values,
          if (input$ttt1name != '') 'ttt1' else NULL,
          if (input$ttt2name != '') 'ttt2' else NULL,
          if (input$ttt3name != '') 'ttt3' else NULL,
          if (input$programChange1Name != '') 'programChange1' else NULL,
          if (input$programChange2Name != '') 'programChange2' else NULL,
          if (input$programChange3Name != '') 'programChange3' else NULL,
          if (input$scenario1Name != '') 'scenario1' else NULL,
          if (input$scenario2Name != '') 'scenario2' else NULL,
          if (input$scenario3Name != '') 'scenario3' else NULL
				)
      )
  })
  
  # These are the Model Scenarios available in the Outcomes - Trends page
  output$trendsInterventions <- renderUI({
      checkboxGroup2(
      id = paste0('tabby1-', trends$IDs$controls$interventions),
      heading = trends$interventions$heading,
      labels = c(
        estimates$interventions$labels,
				if (input$ttt1name != '') input$ttt1name else NULL,
				if (input$ttt2name != '') input$ttt2name else NULL,
				if (input$ttt3name != '') input$ttt3name else NULL,
				if (input$programChange1Name != '') input$programChange1Name else NULL,
				if (input$programChange2Name != '') input$programChange2Name else NULL,
				if (input$programChange3Name != '') input$programChange3Name else NULL,
        if (input$scenario1Name != '') input$scenario1Name else NULL,
        if (input$scenario2Name != '') input$scenario2Name else NULL,
        if (input$scenario3Name != '') input$scenario3Name else NULL
      ),
      values = c(
			  trends$interventions$values,
				if (input$ttt1name != '') 'ttt1' else NULL,
				if (input$ttt2name != '') 'ttt2' else NULL,
				if (input$ttt3name != '') 'ttt3' else NULL,
				if (input$programChange1Name != '') 'programChange1' else NULL,
				if (input$programChange2Name != '') 'programChange2' else NULL,
				if (input$programChange3Name != '') 'programChange3' else NULL,
				if (input$scenario1Name != '') 'scenario1' else NULL,
				if (input$scenario2Name != '') 'scenario2' else NULL,
				if (input$scenario3Name != '') 'scenario3' else NULL
			)
    )
  })
  
  # These are the Model Scenarios available in the Outcomes - Ages page
  output$agesInterventions <- renderUI({
      checkboxGroup2(
      id = paste0('tabby1-', agegroups$IDs$controls$interventions),
      heading = agegroups$interventions$heading,
      labels = c(
        estimates$interventions$labels,
				if (input$ttt1name != '') input$ttt1name else NULL,
				if (input$ttt2name != '') input$ttt2name else NULL,
				if (input$ttt3name != '') input$ttt3name else NULL,
				if (input$programChange1Name != '') input$programChange1Name else NULL,
				if (input$programChange2Name != '') input$programChange2Name else NULL,
				if (input$programChange3Name != '') input$programChange3Name else NULL,
        if (input$scenario1Name != '') input$scenario1Name else NULL,
        if (input$scenario2Name != '') input$scenario2Name else NULL,
        if (input$scenario3Name != '') input$scenario3Name else NULL
      ),
      values = c(
			  agegroups$interventions$values,
				if (input$ttt1name != '') 'ttt1' else NULL,
				if (input$ttt2name != '') 'ttt2' else NULL,
				if (input$ttt3name != '') 'ttt3' else NULL,
				if (input$programChange1Name != '') 'programChange1' else NULL,
				if (input$programChange2Name != '') 'programChange2' else NULL,
				if (input$programChange3Name != '') 'programChange3' else NULL,
				if (input$scenario1Name != '') 'scenario1' else NULL,
				if (input$scenario2Name != '') 'scenario2' else NULL,
				if (input$scenario3Name != '') 'scenario3' else NULL
			)
    )
  })
}
