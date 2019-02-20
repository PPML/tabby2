#' Render Comparison to Recent Data Plots
#' 
#' Fetch plots depicting a comparison of model performance to the data
#' available. First a reactive element computes the path to the RDS file
#' containing the plot corresponding to the user's choice in which
#' comparison to visualize, then the RDS file is read and the plot object
#' is rendered as output with renderPlot.

comparisonToRecentData <- function(input, output, session, geo_short_code) {
  # comparisonDataChoices is a vector mapping the filenames (without .rds) or
  # short-versions of the calibration data targets to their proper names as they
  # appear in the titles of the calibration plots.
  comparisonDataChoices <- c(
    total_population = "Population: Total, US, and Non-US Born",
    `total-deaths-by-age` = "Total TB Deaths by Age Group",
    percent_of_cases_in_non_usb = "Percent of TB Cases in Non-US-Born 2000-2014",
    `percent-of-non-usb-cases-in-recent-immigrants` = "Percent of Non-US Born Cases Arrived in Past 2 Years",
    mortality_by_age = "Mortality by Age",
    mortality = "Mortality: Total, US, and Non-US Born",
    `ltbi-prev-by-age-usb` = "LTBI in US Born Population by Age",
    `ltbi-prev-by-age-non-usb` = "LTBI in Non-US Born Population by Age",
    diagnosed_cases_2006 = "Total TB Cases Identified, 2006-2016",
    age_distribution_all_ages = "Total Population by Age Group 2014",
    age_distribution = "Population by Age for Non-US Born and US Born",
    treatment_outcomes = "Treatment Outcomes",
    `age-distribution-of-cases` = "TB Cases By Age (2000-16)"
  )
  
  # Reverse comparisonDataChoices so that we can look up short codes from the 
  # users choice, given as the proper name (with spaces and title casing). 
  # This is used in the comparison_to_recent_data_plot_path reactive below.
  comparisonDataChoices_rev <- names(comparisonDataChoices)
  names(comparisonDataChoices_rev) <- unlist(comparisonDataChoices)
  
  # Render the options for calibration data targets  (Comparison to Recent Data)
  # depending on the geo_short_code (geography selected by the user). This is
  # dynamic because the states and US differ in which data targets are available
  # / calibrated to.
  output$comparison_to_recent_data_buttons <- renderUI({
    req(input[['state']])
    radioButtons(
      inputId = "comparisonDataChoice",
      label = "Select an option below to compare the model's performance to observed data.",
      choices = as.character(comparisonDataChoices[
        gsub(".rds",
             "",
             list.files(
               paste0("utilities/inst/calibration_plots/", geo_short_code(), "/")
             ))])
    )
  })
  
  # Get the path to the comparison plot chosen by the user
  comparison_to_recent_data_plot_path <- reactive({
    req(input[['comparisonDataChoice']], input[['state']])
    file <- comparisonDataChoices_rev[input$comparisonDataChoice]
    return(paste0('calibration_plots/', geo_short_code(), '/', file, ".rds"))
  })
  
  # Render the calibration data target from its RDS file
  output$calib_data_target_plot <- renderPlot({
    readRDS(system.file(comparison_to_recent_data_plot_path(), package = 'utilities'))
  })

	# Download server ----
  output$downloadParameters <- downloadHandler(
    filename = function() { "input_parameters.yaml" },
    content = function(file) { cat(yaml::as.yaml(reactiveValuesToList(input)), file = file) })
}
