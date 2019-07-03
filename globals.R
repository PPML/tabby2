tabnames <- c(
  about = "Introduction",
  scenarios = "Scenarios",
  predefined = "Predefined Scenarios",
  customscenarios = "Build Scenarios",
  estimates = "Estimates",
  timetrends = "Time Trends",
  agegroups = "Age Groups",
  calibration = "Comparison to Recent Data",
  # downloads = "Downloads",
  readmore = "Further Description",
	feedback = "Feedback"
)

tabcontents <- list(
  about = aboutUI(),#  uiOutput('aboutUI'),
  scenarios = NULL,
  predefined = standardInterventionsUI(),
  customscenarios = scenariosUI(),
  estimates = tabby1Estimates('tabby1'),
  timetrends = tabby1TimeTrends('tabby1'),
  agegroups = tabby1AgeGroups('tabby1'),
  calibration = comparison_to_recent_data(),
  # downloads = downloadsAndSettingsUI(),
  readmore = readmoreUI(),
	feedback = feedbackForm()
)

if (exists('debug', envir = .GlobalEnv) && isTRUE(debug)) {
  tabnames[['debug']] <- 'Debug Printouts'
  tabcontents[['debug']] <- debugPrintouts()
}
