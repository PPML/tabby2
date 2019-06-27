#
#            Shiny App Server for Tabby2
#             ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅
#   This server includes the following components/modules: 
#     - Get short-codes for the user's selected geography
#     - Reactive Values to store custom scenarios' definitions
#     - Render custom scenarios' input settings UI
#     - Use the Tabby1 Output Server for plot generation
#     - Custom Scenarios Choice in Output Plots
#     - Plots for Comparison to Recent Data
#     - Debug Print Server (Optional) 

library(shiny)
library(shinydashboard)
library(shinyjs)
library(MITUS)
library(tabus)
library(shinycssloaders)
library(DT)
devtools::load_all("utilities")
source("tabby1/tabby1dependencies.R")
devtools::load_all("tabby1/tabby1utilities")
source("tabby1/tabby1global.R")
source("globals.R")


# The c++ reshaper has to be built from the source code inside 
# the tabus package
cpp_reshaper <- cxxfunction(
	signature(ResTab='numeric', ResTabus='numeric', ResTabfb='numeric', res_tab2 = 'numeric'),
	plugin='Rcpp',
	body=readr::read_file(
		system.file('inline_cpp/format_restab2.cpp', package='tabus')))

# Simple MD5 Username/Password Authentication Schema 
library(datasets)
Logged <- FALSE

if (file.exists("secret.txt") && 
    digest::digest(readLines("secret.txt"), serialize=FALSE) == '5d41402abc4b2a76b9719d911017c592') {
	Logged <- TRUE
}

PASSWORD <- data.frame(
  Username = c('alphaVersion'), 
	Password = c('7ecc08db431548ba58865fc3fc09e831') # generate MD5 hashed passwords with digest::digest(..., serialize=FALSE)
	)

# Set up a named vector for geographies calibrated in MITUS
geographies <- setNames(nm = state.abb, state.name)
geographies[['US']] <- 'United States'
geographies[['DC']] <- 'District of Columbia'
# Subset geographies to include only geographies with rendered results
available_geographies <- geographies[scan_for_available_geographies(names(geographies))]
# available_geographies <- c(US = 'United States')

# Load risk group rate ratios for use in the targeted testing and treatment
# intervention builder
risk_group_rate_ratios <- load_risk_group_data()



shinyServer(function(input, output, session) {
  # Load Authentication UI
  source("www/Login.R",  local = TRUE)

  # Either render the Login/Authentication Page or Render 
	# the application pages.
	output$page <- renderUI({
	if (USER$Logged == FALSE) { # Render Login Page
			div(class = "login", id = 'uiLogin',
					uiOutput("uiLogin"),
					textOutput("pass")
			)
	} else { 
	  # Render tabPanel Contents

		# In order to wrap everything in tab-pane and tab-content html tags 
		# properly, an anonymous function is built that takes expanded tagLists,
		# tagAsserts them to tab-panes, and wraps them with class=tab-content divs.

		# Then we apply this anonymous function to the output of an lapply that 
		# runs along our tabnames and tabcontents lists to construct tabItems out of 
		# each correspondent pair.
		(function (...) 
		{
			lapply(..., shinydashboard:::tagAssert, class = "tab-pane")
			div(class = "tab-content", ...)
		})(lapply(seq_along(tabnames), function(x) {
			tabItem(tabName = names(tabnames)[[x]], tabcontents[[x]])
		}))
	}})

  # Only render application features if the user is logged in
	observe({
	  if (USER$Logged == TRUE) {
			# Once the user is logged in, toggle which panel is selected (imperceptibly fast) 
			# so that the About-UI Re-renders.
			observeEvent(USER$Logged, {
			  updateTabsetPanel(session = session, inputId = 'sidebar', selected = 'predefined')
			  updateTabsetPanel(session = session, inputId = 'sidebar', selected = 'about')

			})

		# Geography Short Code
		geo_short_code <- callModule(geoShortCode, NULL, geographies)

		# Re-Render About UI
		callModule(updateAboutUI, NULL, available_geographies)

		#  Setup `values` to contain our reactiveValues
		values <- callModule(constructReactiveValues, NULL)

		# Watch for Updates to Custom Scenarios
		values <- callModule(updateProgramChanges, NULL, values)
		
		# Update reactiveValues to reflect selected/defined risk group rate ratios
		values <- callModule(updateTargetedRiskGroupRates, NULL, risk_group_rate_ratios, values)

		# Add TTT Interventions to the Custom Scenarios tab
		callModule(customScenarioTTTChoices, NULL)
		
		# Add Program Change Interventions to the Custom Scenarios tab
		callModule(customScenarioProgramChangeChoices, NULL)
		
		# Next/Back Page Buttons
		callModule(nextBackButtons, NULL)
		
		# Load Data Server
		sim_data <- callModule(load_data, id = NULL, geo_short_code = geo_short_code)

		# Display the summary statistics in the TTT interventions
		callModule(summaryStatistics, NULL, values, sim_data = sim_data)

		# Run & Append Program Changes Custom Scenarios to Sim Data
		sim_data_w_program_changes <- 
			callModule(runProgramChanges, NULL, values, geo_short_code, sim_data)

		# Tabby1 Server
		# outcomes_filtered_data <- 
		#   callModule(filterOutcomes, NULL, sim_data_w_program_changes)

		# Tabby1 Visualization Server
		filtered_data <- 
			callModule(
					module = tabby1Server, 
					id = "tabby1", 
					ns = NS("tabby1"), 
					sim_data = sim_data_w_program_changes,
					geo_short_code = geo_short_code, 
					geographies = geographies) 
			
		# Custom Scenarios Choice in Output
		callModule(outputIncludeCustomScenarioOptions, NULL)
		
		# Plots for Comparison to Recent Data
		callModule(comparisonToRecentData, NULL, geo_short_code)

		# Call Module for Saving Feedback Form Input
		callModule(feedbackFormModule, NULL)

		# Debug Printout Server 
		callModule(debugPrintoutsModule, NULL, values = values)

		output[['estimatesData']] <- 
			DT::renderDataTable( filtered_data[['estimatesData']](), 
				options = list(pageLength = 25, scrollX = TRUE), 
				rownames=FALSE )  

		output[['trendsData']] <- 
			DT::renderDataTable( filtered_data[['trendsData']](), 
				options = list(pageLength = 25, scrollX = TRUE), 
				rownames=FALSE )  

		output[['agegroupsData']] <- 
			DT::renderDataTable( filtered_data[['agegroupsData']](), 
				options = list(pageLength = 25, scrollX = TRUE), 
				rownames=FALSE )  

		output[['extraDebugOutputs']] <- 
			renderText({
				capture.output(str(sim_data[['ESTIMATES_DATA']]))
			})

	} # end of if USER$Logged == TRUE
	}) # end of observer on USER$Logged
})
