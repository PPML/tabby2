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
devtools::load_all("utilities")
source("tabby1/tabby1dependencies.R")
devtools::load_all("tabby1/tabby1utilities")
source("tabby1/tabby1global.R")
source("globals.R")




# Simple MD5 Username/Password Authentication Schema 
library(datasets)
Logged <- TRUE
PASSWORD <- data.frame(
  Username = c('earlyAccess'), 
	Password = c('fcce0e290f8059681e31d617930a663d') # generate MD5 hashed passwords with digest::digest(..., serialize=FALSE)
	)

# Set up a named vector for geographies calibrated in MITUS
geographies <- setNames(nm = state.abb, state.name)
geographies[['US']] <- 'United States'
geographies[['DC']] <- 'District of Columbia'
# Subset geographies to include only geographies with rendered results
available_geographies <- geographies[scan_for_available_geographies(names(geographies))]

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

		# Display the summary statistics in the TTT interventions
		callModule(summaryStatistics, NULL)
			
		# Add TTT Interventions to the Custom Scenarios tab
		callModule(customScenarioTTTChoices, NULL)
		
		# Add Program Change Interventions to the Custom Scenarios tab
		callModule(customScenarioProgramChangeChoices, NULL)
		
		# Next/Back Page Buttons
		callModule(nextBackButtons, NULL)
		
		# MITUS Interaction Server
		# callModule(mitusInteractionServer, NULL, geo_short_code = geo_short_code)
		
		# Tabby1 Server
		callModule(module = tabby1Server, id = "tabby1", ns = NS("tabby1"), geo_short_code = geo_short_code) 
		
		# Custom Scenarios Choice in Output
		callModule(outputIncludeCustomScenarioOptions, NULL)
		
		# Plots for Comparison to Recent Data
		callModule(comparisonToRecentData, NULL, geo_short_code)

		# Debug Printout Server 
		callModule(debugPrintoutsModule, NULL, values = values)

	} # else {
	
	})
})
