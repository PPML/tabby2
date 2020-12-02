
comparisonToRecentData <- function(input, output, session, geo_short_code) { 

  # read in the (hopefully single) source of authority on the required_plots
  # that are tested to be ensured to be available from MITUSCalibPlots and
  # MITUS
  plots_subset <- readr::read_lines(system.file('required_plots.txt', package='MITUSCalibPlots'))

  # This reacitve renders the comparison to recent data plots using calib_plots
  # from the MITUSCalibPlots package.
  calib_plots <- reactive({ 
    MITUSCalibPlots::calib_plots(
      loc = geo_short_code(), 
      # filter the plots to only include these specified 6
      plots_subset = plots_subset) 
  }) 

  # A future goal is to separate these out into Demographic and Epidemiological 
  # targets, but I'm not sure how to split up one set of radio buttons into 
  # multiple sections.
  output$comparison_to_recent_data_buttons <- renderUI({
    radioButtons(
      inputId = "comparisonDataChoice",
      label = "Select an option below to compare the model's performance to observed data.",
      choices = setNames(nm = calib_plots()[['name']], object = calib_plots()[['shortname']])
    )
  })

  # Render the plot from the plots reactive containing the output from calib_plots()
  calib_data_target_plot <- reactive({
	  plt_idx <- which(calib_plots()[['shortname']] == input[['comparisonDataChoice']])
    calib_plots()[[plt_idx, 'plot']]
  })


  # Render the plot from the plots reactive containing the output from calib_plots()
  output$calib_data_target_plot <- renderPlot({ calib_data_target_plot() }, res = 100)
}
