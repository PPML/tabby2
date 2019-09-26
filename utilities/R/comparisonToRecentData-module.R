
comparisonToRecentData <- function(input, output, session, geo_short_code) { 

  plots <- reactive({ MITUSCalibPlots::calib_plots(loc = geo_short_code()) }) 

  # A future goal is to separate these out into Demographic and Epidemiological 
  # targets, but I'm not sure how to split up one set of radio buttons into 
  # multiple sections.
  output$comparison_to_recent_data_buttons <- renderUI({
    radioButtons(
      inputId = "comparisonDataChoice",
      label = "Select an option below to compare the model's performance to observed data.",
      choices = setNames(nm = plots()[['name']], object = plots()[['shortname']])
    )
  })

  calib_data_target_plot <- reactive({
	  plt_idx <- which(plots()[['shortname']] == input[['comparisonDataChoice']]) 
    plots()[[plt_idx, 'plot']]
  })

  output$calib_data_target_plot <- renderPlot({ calib_data_target_plot() })

}
