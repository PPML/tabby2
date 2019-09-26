

###################
### Description ### 
###################

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


####################
### Dependencies ###
####################

library(shiny)
library(shinydashboard)
library(shinyjs)
library(MITUS)
library(MITUSCalibPlots)
library(tabus)
library(shinycssloaders)
library(DT)
devtools::load_all("utilities")
source("tabby1/tabby1dependencies.R")
devtools::load_all("tabby1/tabby1utilities")
source("tabby1/tabby1global.R")
source("globals.R")


####################
### cpp_reshaper ###
####################

# This cpp_reshaper is a function, written in C++, which reshapes simulation
# data from the Modeling Interventions on Tuberculosis in the United States
# (MITUS) package.
#
# The reshaper converts 4 dimentional arrays with measures of TB outcomes (like
# LTBI per million, TB related deaths, etc.), and converts those arrays into
# 2-dimensional `tidy` data frames suitable for plotting with ggplot2.
#
# cpp_reshaper is built using construct_cpp_reshaper() from the tabus package,
# which uses the inline package which compiles Rcpp functions source code from
# the R-session.

assign('cpp_reshaper', tabus::construct_cpp_reshaper(), envir = .GlobalEnv)


######################################
### Geographies Available in MITUS ### 
######################################

# These functions should scan the MITUS package for directories which have data
# available in the format that Tabby2 requires to visualize outcomes for a
# specific geography.  Such folders are automatically detected using the
# scan_for_available_geographies function.

# geographies is all possible geographies, assumed at this time to be the US,
# DC, and the 50 states.

# available_geographies is filtered for the geographies available in MITUS
# according to the criterion specified in scan_for_available_geographies.

# invert_geographies is a list with geography names as keys and their
# short-codes as values, inverted from geographies for use as a lookup to go
# back and forth between long-names and short-names for the available
# geographies.

geographies <- setNames(nm = state.abb, state.name)
geographies[['US']] <- 'United States'
geographies[['DC']] <- 'District of Columbia'

available_geographies <- geographies[scan_for_available_geographies(names(geographies))]

invert_geographies <- setNames(nm = unname(geographies), object = names(geographies))


##############################
### Risk Group Rate Ratios ###
##############################

# Load risk group rate ratios for use in the targeted testing and treatment
# intervention builder

risk_group_rate_ratios <- load_risk_group_data()


##############
### Server ###
##############

shinyServer(function(input, output, session) {
	output$page <- renderUI({
	  # Render tabPanel Contents
    
    # The tabPanel contents are contained in a list generated in globals.R, 
    # so we send the tabcontents and tabnames lists through two lapplys, 
    # the first of which turns each into a tabItem, the second of which 
    # appends class="tab-pane" into each tabItem.

    # This should probably be done with %>% instead of the anonymous function 
    # applied immediately used here.

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
			

		# Output short-code for use in plot titles
		output$geo_short_code <- renderText({ geo_short_code() }) 	

		# Specify sim_data to be a reactiveList which will hold our simulation outcomes,
		# both pre-simulated and simulated on the fly.
		sim_data <- reactiveValues(presimulated = NULL,
		  programChanges1 = NULL,
		  programChanges2 = NULL,
		  programChanges3 = NULL,
      ttt1 = NULL,
      ttt2 = NULL,
      ttt3 = NULL,
      combination1 = NULL,
      combination2 = NULL,
      combination3 = NULL
      )

		# Re-Render About UI
		callModule(updateAboutUI, NULL, available_geographies)

		#  Setup `values` to contain our reactiveValues
		values <- callModule(constructReactiveValues, NULL)

    default_prg_chng <- callModule(compute_default_prg_chng, NULL, geo_short_code)

		# Watch for Updates to Custom Scenarios
		values <- callModule(updateProgramChanges, NULL, values)

    # Render the program change input UI
		output$programChange1 <- renderUI({ programChangePanel(1, default_prg_chng()) })
		output$programChange2 <- renderUI({ programChangePanel(2, default_prg_chng()) })
		output$programChange3 <- renderUI({ programChangePanel(3, default_prg_chng()) })

    # provide feedback for user input
    callModule(shinyFeedbackModule, NULL)
		
		# Update reactiveValues to reflect selected/defined risk group rate ratios
		values <- callModule(updateTargetedRiskGroupRates, NULL, risk_group_rate_ratios, values)

		# Add TTT Interventions to the Custom Scenarios tab
		callModule(customScenarioTTTChoices, NULL, sim_data = sim_data)
		
		# Add Program Change Interventions to the Custom Scenarios tab
		callModule(customScenarioProgramChangeChoices, NULL, sim_data = sim_data)

		# Next/Back Page Buttons
		callModule(nextBackButtons, NULL)
		
		# Load Presimulated Data Data Server Reactively Based on geo_short_code
		observeEvent(geo_short_code(), {
			sim_data[['presimulated']] <- load_data(geo_short_code()) # presimulated_data()
			sim_data[['programChanges1']] <- NULL
			sim_data[['programChanges2']] <- NULL
			sim_data[['programChanges3']] <- NULL
			sim_data[['ttt1']] <- NULL
			sim_data[['ttt2']] <- NULL
			sim_data[['ttt3']] <- NULL
			sim_data[['combination1']] <- NULL
			sim_data[['combination2']] <- NULL
			sim_data[['combination3']] <- NULL
		})

    ### Set Up Reactives to Run Simulations ### 

    # Construct Reactive Objects Which Return Program Change scenarios when called 
		compute_program_change_1 <- callModule(runProgramChanges, NULL, n = 1, values, geo_short_code, sim_data, default_prg_chng)
		compute_program_change_2 <- callModule(runProgramChanges, NULL, n = 2, values, geo_short_code, sim_data, default_prg_chng)
		compute_program_change_3 <- callModule(runProgramChanges, NULL, n = 3, values, geo_short_code, sim_data, default_prg_chng)

    # Construct Reactive Objects which return TTT scenario simulations when called
    compute_ttt_1 <- callModule(runTTT, NULL, n = 1, geo_short_code)
    compute_ttt_2 <- callModule(runTTT, NULL, n = 2, geo_short_code)
    compute_ttt_3 <- callModule(runTTT, NULL, n = 3, geo_short_code)

    # Construct Reactive Objects which return Combination scenario simulations when called
    compute_combination_1 <- callModule(runCombination, NULL, n = 1, geo_short_code)
    compute_combination_2 <- callModule(runCombination, NULL, n = 2, geo_short_code)
    compute_combination_3 <- callModule(runCombination, NULL, n = 3, geo_short_code)


    ### Run and Simulations and Append to Presimulated Data ### 

		# Run & Append Program Changes Scenarios to Sim Data When RunSimulations Button is Pressed
		observeEvent(input[['programChange1RunSimulations']], {
			sim_data[['programChanges1']] <- callModule(programChangesRunButton, NULL, n = 1, compute_program_change_1, sim_data)
		})
		observeEvent(input[['programChange2RunSimulations']], {
			sim_data[['programChanges2']] <- callModule(programChangesRunButton, NULL, n = 2, compute_program_change_2, sim_data)
		})
		observeEvent(input[['programChange3RunSimulations']], {
			sim_data[['programChanges3']] <- callModule(programChangesRunButton, NULL, n = 3, compute_program_change_3, sim_data)
		})

		# Run & Append TTT Scenarios to Sim Data When RunSimulations Button is Pressed
		observeEvent(input[['ttt1RunSimulations']], {
			sim_data[['ttt1']] <- callModule(tttRunButton, NULL, n = 1, compute_ttt_1)
		})
		observeEvent(input[['ttt2RunSimulations']], {
			sim_data[['ttt2']] <- callModule(tttRunButton, NULL, n = 2, compute_ttt_2)
		})
		observeEvent(input[['ttt3RunSimulations']], {
			sim_data[['ttt3']] <- callModule(tttRunButton, NULL, n = 3, compute_ttt_3)
		})

		# Run & Append Combination Scenarios to Sim Data When RunSimulations Button is Pressed
		observeEvent(input[['combination1RunSimulations']], {
			sim_data[['combination1']] <- callModule(combinationRunButton, NULL, n = 1, compute_combination_1)
		})
		observeEvent(input[['combination2RunSimulations']], {
			sim_data[['combination2']] <- callModule(combinationRunButton, NULL, n = 2, compute_combination_2)
		})
		observeEvent(input[['combination3RunSimulations']], {
			sim_data[['combination3']] <- callModule(combinationRunButton, NULL, n = 3, compute_combination_3)
		})

    ### Delete Custom Scenario Data when Change Settings is Clicked ###

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

		# Delete TTT Scenarios from Sim Data When Change Settings Button is Pressed
		observeEvent(input[['ttt1ChangeSettings']], {
			sim_data[['ttt1']] <- NULL
			callModule(tttChangeSettingsButton, NULL, n = 1)
		})
		observeEvent(input[['ttt2ChangeSettings']], {
			sim_data[['ttt2']] <- NULL
			callModule(tttChangeSettingsButton, NULL, n = 2)
		})
		observeEvent(input[['ttt3ChangeSettings']], {
			sim_data[['ttt3']] <- NULL
			callModule(tttChangeSettingsButton, NULL, n = 3)
		})

		# Delete Combination Scenarios from Sim Data When Change Settings Button is Pressed
		observeEvent(input[['combination1ChangeSettings']], {
			sim_data[['combination1']] <- NULL
			callModule(combinationChangeSettingsButton, NULL, n = 1)
		})
		observeEvent(input[['combination2ChangeSettings']], {
			sim_data[['combination2']] <- NULL
			callModule(combinationChangeSettingsButton, NULL, n = 2)
		})
		observeEvent(input[['combination3ChangeSettings']], {
			sim_data[['combination3']] <- NULL
			callModule(combinationChangeSettingsButton, NULL, n = 3)
		})

    ### Restore Defaults Button Logic for Program Changes ### 

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


    ### Aggregate All Simulation Data into a Reactive ###

    # This is the data which gets sent to the tabby1 server
		combined_data <- reactive({ 
			list(
			AGEGROUPS_DATA = rbind.data.frame(
				sim_data[['presimulated']][['AGEGROUPS_DATA']],
				sim_data[['programChanges1']][['AGEGROUPS_DATA']],
				sim_data[['programChanges2']][['AGEGROUPS_DATA']],
				sim_data[['programChanges3']][['AGEGROUPS_DATA']],
        sim_data[['ttt1']][['AGEGROUPS_DATA']],
        sim_data[['ttt2']][['AGEGROUPS_DATA']],
        sim_data[['ttt3']][['AGEGROUPS_DATA']],
        sim_data[['combination1']][['AGEGROUPS_DATA']],
        sim_data[['combination2']][['AGEGROUPS_DATA']],
        sim_data[['combination3']][['AGEGROUPS_DATA']]
			),
			ESTIMATES_DATA = rbind.data.frame(
				sim_data[['presimulated']][['ESTIMATES_DATA']],
				sim_data[['programChanges1']][['ESTIMATES_DATA']],
				sim_data[['programChanges2']][['ESTIMATES_DATA']],
				sim_data[['programChanges3']][['ESTIMATES_DATA']],
				sim_data[['ttt1']][['ESTIMATES_DATA']],
				sim_data[['ttt2']][['ESTIMATES_DATA']],
				sim_data[['ttt3']][['ESTIMATES_DATA']],
				sim_data[['combination1']][['ESTIMATES_DATA']],
				sim_data[['combination2']][['ESTIMATES_DATA']],
				sim_data[['combination3']][['ESTIMATES_DATA']]
			),
		  TRENDS_DATA = rbind.data.frame(
				sim_data[['presimulated']][['TRENDS_DATA']],
				sim_data[['programChanges1']][['TRENDS_DATA']],
				sim_data[['programChanges2']][['TRENDS_DATA']],
				sim_data[['programChanges3']][['TRENDS_DATA']],
				sim_data[['ttt1']][['TRENDS_DATA']],
				sim_data[['ttt2']][['TRENDS_DATA']],
				sim_data[['ttt3']][['TRENDS_DATA']],
				sim_data[['combination1']][['TRENDS_DATA']],
				sim_data[['combination2']][['TRENDS_DATA']],
				sim_data[['combination3']][['TRENDS_DATA']]
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

	# } # end of if USER$Logged == TRUE
	# }) # end of observer on USER$Logged
})
