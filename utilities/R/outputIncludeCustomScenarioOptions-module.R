outputIncludeCustomScenarioOptions <- function(input, output, session, sim_data) { 
  
  handle_null_and_empty_str <- function(str, default) { 
    if (length(str) > 0) if (str == '') default else str else NULL
  }

  program_change_option <- function(n) { 
    pc_n <- paste0('programChange', n)
    if (! is.null(sim_data[[pc_n]])) {
      handle_null_and_empty_str(input[[pc_n]], pc_n)
    } else NULL
  }

  # These are the Model Scenarios available in the Outcomes - Estimates page
  output$estimatesInterventions <- renderUI({
    checkboxGroup2(
        id = paste0('tabby1-', estimates$IDs$controls$interventions),
        heading = estimates$interventions$heading,
        labels = c(
          estimates$interventions$labels,

          if (! is.null(sim_data[['ttt1']])) handle_null_and_empty_str(input$ttt1name, 'ttt1') else NULL,
          if (! is.null(sim_data[['ttt2']])) handle_null_and_empty_str(input$ttt2name, 'ttt2') else NULL,
          if (! is.null(sim_data[['ttt3']])) handle_null_and_empty_str(input$ttt3name, 'ttt3') else NULL,

          if (! is.null(sim_data[['programChanges1']])) handle_null_and_empty_str(input$programChange1Name, 'programChange1') else NULL,
          if (! is.null(sim_data[['programChanges2']])) handle_null_and_empty_str(input$programChange2Name, 'programChange2') else NULL,
          if (! is.null(sim_data[['programChanges3']])) handle_null_and_empty_str(input$programChange3Name, 'programChange3') else NULL,

          if (! is.null(sim_data[['combination1']])) handle_null_and_empty_str(input$combination1Name, 'combination1') else NULL,
          if (! is.null(sim_data[['combination2']])) handle_null_and_empty_str(input$combination2Name, 'combination2') else NULL,
          if (! is.null(sim_data[['combination3']])) handle_null_and_empty_str(input$combination3Name, 'combination3') else NULL
        ),
        values = c(
				  estimates$interventions$values,
          if (! is.null(sim_data[['ttt1']])) handle_null_and_empty_str(input$ttt1name, 'ttt1') else NULL,
          if (! is.null(sim_data[['ttt2']])) handle_null_and_empty_str(input$ttt2name, 'ttt2') else NULL,
          if (! is.null(sim_data[['ttt3']])) handle_null_and_empty_str(input$ttt3name, 'ttt3') else NULL,

          if (! is.null(sim_data[['programChanges1']])) handle_null_and_empty_str(input$programChange1Name, 'programChange1') else NULL,
          if (! is.null(sim_data[['programChanges2']])) handle_null_and_empty_str(input$programChange2Name, 'programChange2') else NULL,
          if (! is.null(sim_data[['programChanges3']])) handle_null_and_empty_str(input$programChange3Name, 'programChange3') else NULL,

          if (! is.null(sim_data[['combination1']])) handle_null_and_empty_str(input$combination1Name, 'combination1') else NULL,
          if (! is.null(sim_data[['combination2']])) handle_null_and_empty_str(input$combination2Name, 'combination2') else NULL,
          if (! is.null(sim_data[['combination3']])) handle_null_and_empty_str(input$combination3Name, 'combination3') else NULL
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
        if (! is.null(sim_data[['ttt1']])) handle_null_and_empty_str(input$ttt1name, 'ttt1') else NULL,
        if (! is.null(sim_data[['ttt2']])) handle_null_and_empty_str(input$ttt2name, 'ttt2') else NULL,
        if (! is.null(sim_data[['ttt3']])) handle_null_and_empty_str(input$ttt3name, 'ttt3') else NULL,

        if (! is.null(sim_data[['programChanges1']])) handle_null_and_empty_str(input$programChange1Name, 'programChange1') else NULL,
        if (! is.null(sim_data[['programChanges2']])) handle_null_and_empty_str(input$programChange2Name, 'programChange2') else NULL,
        if (! is.null(sim_data[['programChanges3']])) handle_null_and_empty_str(input$programChange3Name, 'programChange3') else NULL,

        if (! is.null(sim_data[['combination1']])) handle_null_and_empty_str(input$combination1Name, 'combination1') else NULL,
        if (! is.null(sim_data[['combination2']])) handle_null_and_empty_str(input$combination2Name, 'combination2') else NULL,
        if (! is.null(sim_data[['combination3']])) handle_null_and_empty_str(input$combination3Name, 'combination3') else NULL
      ),
      values = c(
			  trends$interventions$values,
        if (! is.null(sim_data[['ttt1']])) handle_null_and_empty_str(input$ttt1name, 'ttt1') else NULL,
        if (! is.null(sim_data[['ttt2']])) handle_null_and_empty_str(input$ttt2name, 'ttt2') else NULL,
        if (! is.null(sim_data[['ttt3']])) handle_null_and_empty_str(input$ttt3name, 'ttt3') else NULL,

        if (! is.null(sim_data[['programChanges1']])) handle_null_and_empty_str(input$programChange1Name, 'programChange1') else NULL,
        if (! is.null(sim_data[['programChanges2']])) handle_null_and_empty_str(input$programChange2Name, 'programChange2') else NULL,
        if (! is.null(sim_data[['programChanges3']])) handle_null_and_empty_str(input$programChange3Name, 'programChange3') else NULL,

        if (! is.null(sim_data[['combination1']])) handle_null_and_empty_str(input$combination1Name, 'combination1') else NULL,
        if (! is.null(sim_data[['combination2']])) handle_null_and_empty_str(input$combination2Name, 'combination2') else NULL,
        if (! is.null(sim_data[['combination3']])) handle_null_and_empty_str(input$combination3Name, 'combination3') else NULL

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
				# if (input$ttt1name != '') input$ttt1name else NULL,
				# if (input$ttt2name != '') input$ttt2name else NULL,
				# if (input$ttt3name != '') input$ttt3name else NULL,
        if (! is.null(sim_data[['ttt1']])) handle_null_and_empty_str(input$ttt1name, 'ttt1') else NULL,
        if (! is.null(sim_data[['ttt2']])) handle_null_and_empty_str(input$ttt2name, 'ttt2') else NULL,
        if (! is.null(sim_data[['ttt3']])) handle_null_and_empty_str(input$ttt3name, 'ttt3') else NULL,

        if (! is.null(sim_data[['programChanges1']])) handle_null_and_empty_str(input$programChange1Name, 'programChange1') else NULL,
        if (! is.null(sim_data[['programChanges2']])) handle_null_and_empty_str(input$programChange2Name, 'programChange2') else NULL,
        if (! is.null(sim_data[['programChanges3']])) handle_null_and_empty_str(input$programChange3Name, 'programChange3') else NULL,

        if (! is.null(sim_data[['combination1']])) handle_null_and_empty_str(input$combination1Name, 'combination1') else NULL,
        if (! is.null(sim_data[['combination2']])) handle_null_and_empty_str(input$combination2Name, 'combination2') else NULL,
        if (! is.null(sim_data[['combination3']])) handle_null_and_empty_str(input$combination3Name, 'combination3') else NULL

      ),
      values = c(
			  agegroups$interventions$values,
				# if (input$ttt1name != '') 'ttt1' else NULL,
				# if (input$ttt2name != '') 'ttt2' else NULL,
				# if (input$ttt3name != '') 'ttt3' else NULL,
        if (! is.null(sim_data[['ttt1']])) handle_null_and_empty_str(input$ttt1name, 'ttt1') else NULL,
        if (! is.null(sim_data[['ttt2']])) handle_null_and_empty_str(input$ttt2name, 'ttt2') else NULL,
        if (! is.null(sim_data[['ttt3']])) handle_null_and_empty_str(input$ttt3name, 'ttt3') else NULL,

        if (! is.null(sim_data[['programChanges1']])) handle_null_and_empty_str(input$programChange1Name, 'programChange1') else NULL,
        if (! is.null(sim_data[['programChanges2']])) handle_null_and_empty_str(input$programChange2Name, 'programChange2') else NULL,
        if (! is.null(sim_data[['programChanges3']])) handle_null_and_empty_str(input$programChange3Name, 'programChange3') else NULL,

        if (! is.null(sim_data[['combination1']])) handle_null_and_empty_str(input$combination1Name, 'combination1') else NULL,
        if (! is.null(sim_data[['combination2']])) handle_null_and_empty_str(input$combination2Name, 'combination2') else NULL,
        if (! is.null(sim_data[['combination3']])) handle_null_and_empty_str(input$combination3Name, 'combination3') else NULL

			)
    )
  })
}
