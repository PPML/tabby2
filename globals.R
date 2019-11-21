
geographies <- setNames(nm = state.abb, state.name)
geographies[['US']] <- 'United States'
geographies[['DC']] <- 'District of Columbia'

available_geographies <- geographies[scan_for_available_geographies(names(geographies))]

invert_geographies <- setNames(nm = unname(geographies), object = names(geographies))

tabnames <- c(
  about = "Introduction",
  scenarios = "Scenarios",
  predefined = "Predefined Scenarios",
  customscenarios = "Build Custom Scenarios",
  estimates = "Estimates",
  timetrends = "Time Trends",
  agegroups = "Age Groups",
  calibration = "Comparison to Recent Data",
  readmore = "Further Description",
	feedback = "Feedback"
)

tabcontents <- list(
  about = aboutUI(available_geographies),# uiOutput('aboutUI'),
  scenarios = NULL,
  predefined = standardInterventionsUI(),
  customscenarios = scenariosUI(),
  estimates = tabby1Estimates('tabby1'),
  timetrends = tabby1TimeTrends('tabby1'),
  agegroups = tabby1AgeGroups('tabby1'),
  calibration = comparison_to_recent_data(),
  readmore = readmoreUI(),
	feedback = feedbackForm()
)

if (exists('debug', envir = .GlobalEnv) && isTRUE(debug)) {
  tabnames[['debug']] <- 'Debug Printouts'
  tabcontents[['debug']] <- debugPrintouts()
}
