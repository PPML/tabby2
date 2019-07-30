
### Load Dependencies ###

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

#
#            Shiny Server for Tabby2
#             ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅
#   This server includes the following components/modules: 
#     - Get short-codes for the user's selected geography
#     - Reactive Values to store custom scenarios' definitions
#     - Render custom scenarios' input settings UI
#     - Use the Tabby1 Output Server for plot generation
#     - Custom Scenarios Choice in Output Plots
#     - Plots for Comparison to Recent Data
#     - Debug Print Server (Optional) 

# In approximate steps, this server.R file does the following: 
#
#   - Load the risk group rate ratios data.

#   - Using the risk group rate ratios, and the user input 

# 

# Depending on the geography selected, load the presimulated data from MITUS
# and present it using the original tabby UI and server as a module. 



### cpp_reshaper ###

# This cpp_reshaper is a function, written in C++, which reshapes simulation data from
# the Modeling Interventions on Tuberculosis in the United States (MITUS) package.
#
# The reshaper converts 4 dimentional arrays with measures of TB outcomes (like
# LTBI per million, TB related deaths, etc.), and converts those arrays into 2-dimensional
# `tidy` data frames suitable for plotting with ggplot2.
#
# cpp_reshaper is built using construct_cpp_reshaper() from the tabus package, which uses
# the inline package which compiles Rcpp functions
# source code from the R-session.

assign('cpp_reshaper', tabus::construct_cpp_reshaper(), envir = .GlobalEnv)


### Geographies Available in MITUS ### 

# These functions should scan the MITUS package for directories which have data available 
# in the format that Tabby2 requires to visualize outcomes for a specific geography.

# Such folders are automatically detected using the scan_for_available_geographies function.

# Get all possible geographies, assumed at this time to be the US, DC, and the 50 states.
geographies <- setNames(nm = state.abb, state.name)
geographies[['US']] <- 'United States'
geographies[['DC']] <- 'District of Columbia'

# Filter the possible geographies for those available in MITUS.
available_geographies <- geographies[scan_for_available_geographies(names(geographies))]

# Invert the available geographies for using as a hash-table to go back and forth 
# between long-names and short-names for the available geographies.
invert_geographies <- setNames(nm = unname(geographies), object = names(geographies))


### Risk Group Rate Ratios ###

# Load risk group rate ratios for use in the targeted testing and treatment
# intervention builder

risk_group_rate_ratios <- load_risk_group_data()



shinyServer(function(input, output, session) {
  # Load Authentication UI
  # source("www/Login.R",  local = TRUE)

  # Either render the Login/Authentication Page or Render 
	# the application pages.
	output$page <- renderUI({
	# if (USER$Logged == FALSE) { # Render Login Page
	# 		div(class = "login", id = 'uiLogin',
	# 				uiOutput("uiLogin"),
	# 				textOutput("pass")
	# 		)
	# } else { 
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
	})

  # Only render application features if the user is logged in
	# observe({
	#   if (USER$Logged == TRUE) {
			# Once the user is logged in, toggle which panel is selected (imperceptibly fast) 
			# so that the About-UI Re-renders.
			# observeEvent(USER$Logged, {
			#   updateTabsetPanel(session = session, inputId = 'sidebar', selected = 'predefined')
			#   updateTabsetPanel(session = session, inputId = 'sidebar', selected = 'about')

			# })

		# Output the Selected Geography
		output$location_selected <- renderUI({
			tags$a(paste0("Location: ", input$state))
		})

		# Geography Short Code
		geo_short_code <- 
			reactive({
				req(input$state)
				invert_geographies[[input$state]]
			})
			
			# callModule(geoShortCode, NULL, geographies)

		# Output short-code for use in plot titles
		output$geo_short_code <- renderText({ geo_short_code() }) 	

		# Specify sim_data to be a reactiveList which will hold our simulation outcomes,
		# both pre-simulated and simulated on the fly.
		sim_data <- reactiveValues(presimulated = NULL,
		  programChanges1 = NULL,
		  programChanges2 = NULL,
		  programChanges3 = NULL)

		# Re-Render About UI
		# callModule(updateAboutUI, NULL, available_geographies)

		#  Setup `values` to contain our reactiveValues
		values <- callModule(constructReactiveValues, NULL)

    default_prg_chng <- callModule(compute_default_prg_chng, NULL, geo_short_code)

		# Watch for Updates to Custom Scenarios
		values <- callModule(updateProgramChanges, NULL, values)

		output$programChange1 <- renderUI({ if (geo_short_code() == 'US') programChangePanel(1, default_prg_chng()) else p("Program Changes are currently only available for the US.") })
		output$programChange2 <- renderUI({ if (geo_short_code() == 'US') programChangePanel(2, default_prg_chng()) else p("Program Changes are currently only available for the US.") })
		output$programChange3 <- renderUI({ if (geo_short_code() == 'US') programChangePanel(3, default_prg_chng()) else p("Program Changes are currently only available for the US.") })
		
		# Update reactiveValues to reflect selected/defined risk group rate ratios
		values <- callModule(updateTargetedRiskGroupRates, NULL, risk_group_rate_ratios, values)

		# Add TTT Interventions to the Custom Scenarios tab
		callModule(customScenarioTTTChoices, NULL)
		
		# Add Program Change Interventions to the Custom Scenarios tab
		callModule(customScenarioProgramChangeChoices, NULL)
		
		# Next/Back Page Buttons
		callModule(nextBackButtons, NULL)
		
		# Load Presimulated Data Data Server Reactively Based on geo_short_code
		observeEvent(geo_short_code(), {
			sim_data[['presimulated']] <- load_data(geo_short_code()) # presimulated_data()
			sim_data[['programChanges1']] <- NULL
			sim_data[['programChanges2']] <- NULL
			sim_data[['programChanges3']] <- NULL
		})

    # Construct Reactive Objects Which Return Program Change Custom Scenarios
		compute_program_change_1 <- callModule(runProgramChanges, NULL, n = 1, values, geo_short_code, sim_data, default_prg_chng)
		compute_program_change_2 <- callModule(runProgramChanges, NULL, n = 2, values, geo_short_code, sim_data, default_prg_chng)
		compute_program_change_3 <- callModule(runProgramChanges, NULL, n = 3, values, geo_short_code, sim_data, default_prg_chng)


		# Run & Append Program Changes Custom Scenarios to Sim Data When programChange1RunSimulations Button is Pressed
		observeEvent(input[['programChange1RunSimulations']], {
			sim_data[['programChanges1']] <- callModule(programChangesRunButton, NULL, n = 1, compute_program_change_1, sim_data)
		})
		observeEvent(input[['programChange2RunSimulations']], {
			sim_data[['programChanges2']] <- callModule(programChangesRunButton, NULL, n = 2, compute_program_change_2, sim_data)
		})
		observeEvent(input[['programChange3RunSimulations']], {
			sim_data[['programChanges3']] <- callModule(programChangesRunButton, NULL, n = 3, compute_program_change_3, sim_data)
		})


		# Delete Program Changes Custom Scenarios from Sim Data When Change Settings Button is Pressed
		observeEvent(input[['programChange1ChangeSettings']], {
			sim_data[['programChanges1']] <- NULL
			callModule(programChangesChangeSettingsButton, NULL, n = 1)
		})
		observeEvent(input[['programChange2ChangeSettings']], {
			sim_data[['programChanges2']] <- NULL
			callModule(programChangesChangeSettingsButton, NULL, n = 2)
		})
		observeEvent(input[['programChange3ChangeSettings']], {
			sim_data[['programChanges3']] <- NULL
			callModule(programChangesChangeSettingsButton, NULL, n = 3)
		})


    # Restore Defaults for Program Change Scenarios
    observeEvent(input[['programChange1RestoreDefaults']], {
      output$programChange1 <- renderUI({ programChangePanel(1, default_prg_chng() ) })
    })
    observeEvent(input[['programChange2RestoreDefaults']], {
      output$programChange1 <- renderUI({ programChangePanel(2, default_prg_chng() ) })
    })
    observeEvent(input[['programChange3RestoreDefaults']], {
      output$programChange1 <- renderUI({ programChangePanel(3, default_prg_chng() ) })
    })


		# Construct a Reactive Returning One Data Frame with Pre-Simulated and Custom Scenarios
		combined_data <- reactive({ 
			list(
			AGEGROUPS_DATA = rbind.data.frame(
				sim_data[['presimulated']][['AGEGROUPS_DATA']],
				sim_data[['programChanges1']][['AGEGROUPS_DATA']],
				sim_data[['programChanges2']][['AGEGROUPS_DATA']],
				sim_data[['programChanges3']][['AGEGROUPS_DATA']]
			),
			ESTIMATES_DATA = rbind.data.frame(
				sim_data[['presimulated']][['ESTIMATES_DATA']],
				sim_data[['programChanges1']][['ESTIMATES_DATA']],
				sim_data[['programChanges2']][['ESTIMATES_DATA']],
				sim_data[['programChanges3']][['ESTIMATES_DATA']]
			),
		  TRENDS_DATA = rbind.data.frame(
				sim_data[['presimulated']][['TRENDS_DATA']],
				sim_data[['programChanges1']][['TRENDS_DATA']],
				sim_data[['programChanges2']][['TRENDS_DATA']],
				sim_data[['programChanges3']][['TRENDS_DATA']]
			)
			)
		})

		# Display the summary statistics in the TTT interventions
		callModule(summaryStatistics, NULL, values, sim_data = sim_data)

		# Tabby1 Server
		# outcomes_filtered_data <- 
		#   callModule(filterOutcomes, NULL, sim_data_w_program_changes)

		# Tabby1 Visualization Server
		filtered_data <- 
			callModule(
					module = tabby1Server, 
					id = "tabby1", 
					ns = NS("tabby1"), 
					sim_data = combined_data,
					geo_short_code = geo_short_code, 
					geographies = geographies) 
			
		# Custom Scenarios Choice in Output
		callModule(outputIncludeCustomScenarioOptions, NULL, sim_data)
		
		# Plots for Comparison to Recent Data
		callModule(comparisonToRecentData2, NULL, geo_short_code)

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

	# } # end of if USER$Logged == TRUE
	# }) # end of observer on USER$Logged
})
