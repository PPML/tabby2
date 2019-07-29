


comparisonToRecentData2 <- function(input, output, session, geo_short_code) {
  # comparisonDataChoices is a vector mapping the filenames (without .rds) or
  # short-versions of the calibration data targets to their proper names as they
  # appear in the titles of the calibration plots.
  comparisonDataChoices <- c(
    total_population = "Population: Total, US, and Non-US Born",
    `total-deaths-by-age` = "Total TB Deaths by Age Group",
    percent_of_cases_in_non_usb = "Percent of TB Cases in Non-US-Born 2000-2014",
    `percent-of-non-usb-cases-in-recent-immigrants` = "Percent of Non-US Born Cases Arrived in Past 2 Years",
    # mortality_by_age = "Mortality by Age",
    mortality = "Mortality: Total, US, and Non-US Born",
    `ltbi-prev-by-age-usb` = "LTBI in US Born Population by Age",
    `ltbi-prev-by-age-non-usb` = "LTBI in Non-US Born Population by Age",
    tb_cases_2006 = "Total TB Cases Identified, 2006-2016",
    # age_distribution_all_ages = "Total Population by Age Group 2014",
    age_distribution = "Population by Age for Non-US Born and US Born",
    treatment_outcomes = "Treatment Outcomes",
    `age-distribution-of-cases` = "TB Cases By Age (2000-16)",
    `tb_deaths_last_ten_years` = "TB Deaths in Recent Years ()",
		`tb_cases_1953` = "Total TB Cases Identified, 1953-2016"
  )

  # Reverse comparisonDataChoices so that we can look up short codes from the 
  # users choice, given as the proper name (with spaces and title casing). 
  # This is used in the calib_data_target_plot below.
  comparisonDataChoices_rev <- names(comparisonDataChoices)
  names(comparisonDataChoices_rev) <- unlist(comparisonDataChoices)

  output$comparison_to_recent_data_buttons <- renderUI({
    # req(input[['state']])
    radioButtons(
      inputId = "comparisonDataChoice",
      label = "Select an option below to compare the model's performance to observed data.",
      choices = unname(comparisonDataChoices)
    )
  })


  # Render the calibration data target from its RDS file
  calib_data_target_plot <- reactive({
	  switch(comparisonDataChoices_rev[[input[['comparisonDataChoice']]]], 

			total_population = calib_plt_pop_by_nat_over_time(geo_short_code()),

			`total-deaths-by-age` = calib_plt_tb_deaths_by_age_over_time(geo_short_code()),

			percent_of_cases_in_non_usb = calib_plt_pct_cases_nusb(geo_short_code()),

			`percent-of-non-usb-cases-in-recent-immigrants` = calib_plt_pct_cases_nusb_recent(geo_short_code()),

			# mortality_by_age = calib_plt_tb_deaths_by_age_over_time(geo_short_code()),

			mortality = calib_plt_deaths_over_time(geo_short_code()),

			`ltbi-prev-by-age-usb` = calib_plt_us_ltbi_by_age(geo_short_code()),

			`ltbi-prev-by-age-non-usb` = calib_plt_nusb_ltbi(geo_short_code()),

			tb_cases_2006 = calib_plt_tb_cases_identified_over_ten_years(geo_short_code()),

			# age_distribution_all_ages = (geo_short_code()),

			age_distribution = calib_plt_pop_by_age_nat(geo_short_code()),

			treatment_outcomes = calib_plt_trt_outcomes(geo_short_code()),

			`age-distribution-of-cases` = calib_plt_tb_cases_age_dist(geo_short_code()),

			`tb_deaths_last_ten_years` = calib_plt_tb_deaths_by_year(geo_short_code()),

			`tb_cases_1953` = calib_plt_tb_cases_nat_over_time(geo_short_code())

		)
  })

	output$calib_data_target_plot <- renderPlot({ calib_data_target_plot() })

}
