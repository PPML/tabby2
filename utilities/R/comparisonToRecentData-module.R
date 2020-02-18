
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

  # download handler id names for output for download buttons
  download_handlers <- paste0('comparison_to_recent_data_download_', c('png', 'pdf', 'pptx'))

  # The session info is used to title the downloads with the tabby2 version
  # number. 
  session_info <- sessionInfo()

  # format the version number to be included in filenames to use underscores.
  version_number <- gsub("\\.", "_", session_info[['otherPkgs']][['utilities']][['Version']])

  # We will also include the sys_date in all download names
  sys_date <- Sys.Date()

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

  # get the calibration target data according to the shortname chosen 
  comparison_to_recent_data_target_data <- reactive({
	  plt_idx <- which(calib_plots()[['shortname']] == input[['comparisonDataChoice']]) 
    calib_plots()[[plt_idx, 'target_data']] %>% mutate_if(is.numeric, signif, 3)
  })
  output$comparison_to_recent_data_target_data <- DT::renderDataTable(comparison_to_recent_data_target_data())

  # get the model estimates used for calibration according to the shortname chosen 
  comparison_to_recent_data_model_estimates<- reactive({
	  plt_idx <- which(calib_plots()[['shortname']] == input[['comparisonDataChoice']]) 
    calib_plots()[[plt_idx, 'model_estimate']] %>% mutate_if(is.numeric, signif, 3)
  })
  output$comparison_to_recent_data_model_estimates  <- DT::renderDataTable(comparison_to_recent_data_model_estimates()) 

  # Render the plot from the plots reactive containing the output from calib_plots()
  output$calib_data_target_plot <- renderPlot({ calib_data_target_plot() }, res = 100)

  # PNG download
  output[[download_handlers[[1]]]] <- downloadHandler(
    filename = reactive({ paste0("tabby", 
      version_number, 
      "-comparison-to-recent-data-", geo_short_code(), "_", sys_date, ".png") }),
    content = function(file) {
      png(file, res = 85, width = 13, height = 9, units = "in")
      print(calib_data_target_plot())
      dev.off()
    }
  )

  # PDF download
  output[[download_handlers[[2]]]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
      version_number,
      "-comparison-to-recent-data-", geo_short_code(), "_", sys_date, ".pdf") }),
    content = function(file) {
      pdf(file, width = 11, height = 8, title = '')
      print(calib_data_target_plot())
      dev.off()
    }
  )

  # PPTX download
  output[[download_handlers[[3]]]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
      version_number,
      "-comparison-to-recent-data-", geo_short_code(), "_", sys_date, ".pptx") }),
    content = function(file) {
      tmp <- tempfile(fileext = "jpg")
      on.exit(unlink(tmp))

      this <- try(calib_data_target_plot(), silent = TRUE)

      jpeg(tmp, res = 72, width = 13, height = 9, units = "in")

      if (is.ggplot(this)) {
        print(this)
      }

      dev.off()

      read_pptx() %>%
        add_slide(layout = "Title and Content", master = "Office Theme") %>%
        ph_with_text(type = "title", str = "") %>%
        ph_with_img(type = "body", src = tmp, width = 7, height = 5) %>%
        print(target = file)
    }
  )


}
