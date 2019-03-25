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

risk_group_rate_ratios <- load_risk_group_data()

shinyServer(function(input, output, session) {

	# Geography Short Code
	geo_short_code <- callModule(geoShortCode, NULL)

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
	callModule(mitusInteractionServer, NULL, geo_short_code = geo_short_code)
  
  # Tabby1 Server
  callModule(module = tabby1Server, id = "tabby1", ns = NS("tabby1"), geo_short_code = geo_short_code) 
  
  # Custom Scenarios Choice in Output
	callModule(outputIncludeCustomScenarioOptions, NULL)
  
  # Plots for Comparison to Recent Data
	callModule(comparisonToRecentData, NULL, geo_short_code)

  # Debug Printout Server 
	callModule(debugPrintoutsModule, NULL, values = values)
})
