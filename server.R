

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
#     - Render Data Tables for the Outputs in Tabby2
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

risk_group_rate_ratios <- load_risk_group_data2()

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

		# Re-Render About UI
		# callModule(updateAboutUI, NULL, available_geographies)

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


		#  Setup `values` to contain our reactiveValues
		values <- callModule(constructReactiveValues, NULL)
    #  Setup the default parameter values by call MITUS functions
    default_prg_chng <- callModule(compute_default_prg_chng, NULL, geo_short_code)
    default_cost_inputs <- callModule(compute_default_cost_inputs, NULL, geo_short_code)
    
		# Watch for Updates to Custom Scenarios
		values <- callModule(updateProgramChanges, NULL, values)

    # Render the program change input UI
		output$programChange1 <- renderUI({ programChangePanel(1, default_prg_chng()) })
		output$programChange2 <- renderUI({ programChangePanel(2, default_prg_chng()) })
		output$programChange3 <- renderUI({ programChangePanel(3, default_prg_chng()) })
		
		output$inputcosts <- renderUI({ inputCostsPanel(cost_inputs=default_cost_inputs()) })
		
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

    # It's very critical to understand that compute_program_change_1 and similar reactives 
    # are called as if they are functions when the "Run Model!" buttons are called. 

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
    
    # After a user clicks "Run Model!", one of the compute_* reactives is run in the following modules,
    # and the output data is inserted into the sim_data reactives before sim_data is passed off 
    # to the tabby1server for providing filtering / visualization / download functionality in the 
    # user interface.

    treatment_distribution<-reactiveValues(programchange1=c(1/3,1/3,1/3,1/3),
                                           programchange2=c(1/3,1/3,1/3,1/3),
                                           programchange3=c(1/3,1/3,1/3,1/3))
    
		# Run & Append Program Changes Scenarios to Sim Data When RunSimulations Button is Pressed
		observeEvent(input[['programChange1RunSimulations']], {
		  x<- callModule(programChangesRunButton, NULL, n = 1, compute_program_change_1, sim_data)
			sim_data[['programChanges1']]<-x[['new_data']]
			treatment_distribution[["programchange1"]]<-x[['parameters']]
			})
		
		observeEvent(input[['programChange2RunSimulations']], {
		  x<- callModule(programChangesRunButton, NULL, n = 1, compute_program_change_2, sim_data)
		  sim_data[['programChanges2']]<-x[['new_data']]
		  treatment_distribution[["programchange2"]]<-x[['parameters']]
			# sim_data[['programChanges2']] <- callModule(programChangesRunButton, NULL, n = 2, compute_program_change_2, sim_data)[[1]]
			# treatment_distribution[["programchange2"]]<-callModule(programChangesRunButton, NULL, n = 1, compute_program_change_2, sim_data)[[2]]
		})
		observeEvent(input[['programChange3RunSimulations']], {
		  x<- callModule(programChangesRunButton, NULL, n = 1, compute_program_change_3, sim_data)
		  sim_data[['programChanges3']]<-x[['new_data']]
		  treatment_distribution[["programchange3"]]<-x[['parameters']]
			# sim_data[['programChanges3']] <- callModule(programChangesRunButton, NULL, n = 3, compute_program_change_3, sim_data)[[1]]
			# treatment_distribution[["programchange3"]]<-callModule(programChangesRunButton, NULL, n = 1, compute_program_change_3, sim_data)[[2]]
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
		observeEvent({ 
      input$state
      input[['programChange1ChangeSettings']] }, {
        sim_data[['programChanges1']] <- NULL
        callModule(programChangesChangeSettingsButton, NULL, n = 1)
		})
		observeEvent({ 
      input$state
      input[['programChange2ChangeSettings']] }, {
        sim_data[['programChanges2']] <- NULL
        callModule(programChangesChangeSettingsButton, NULL, n = 2)
		})
		observeEvent({ 
      input$state
      input[['programChange3ChangeSettings']] }, {
        sim_data[['programChanges3']] <- NULL
        callModule(programChangesChangeSettingsButton, NULL, n = 3)
		})

		# Delete TTT Scenarios from Sim Data When Change Settings Button is Pressed
		observeEvent({ 
      input$state
      input[['ttt1ChangeSettings']] }, {
        sim_data[['ttt1']] <- NULL
        callModule(tttChangeSettingsButton, NULL, n = 1)
		})
		observeEvent({
      input$state
      input[['ttt2ChangeSettings']] }, {
        sim_data[['ttt2']] <- NULL
        callModule(tttChangeSettingsButton, NULL, n = 2)
		})
		observeEvent({ 
      input$state
      input[['ttt3ChangeSettings']] }, {
        sim_data[['ttt3']] <- NULL
        callModule(tttChangeSettingsButton, NULL, n = 3)
		})

		# Delete Combination Scenarios from Sim Data When Change Settings Button is Pressed
		observeEvent({ 
      input$state
      input[['combination1ChangeSettings']] }, {
        sim_data[['combination1']] <- NULL
        callModule(combinationChangeSettingsButton, NULL, n = 1)
		})
		observeEvent({ 
      input$state
      input[['combination2ChangeSettings']] }, {
        sim_data[['combination2']] <- NULL
        callModule(combinationChangeSettingsButton, NULL, n = 2)
		})
		observeEvent({ 
      input$state
      input[['combination3ChangeSettings']] }, {
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

    # Restore Defaults for Costing Scenarios
    observeEvent(input[['RestoreDefaultsC']], {
      output$inputcosts<-renderUI({ inputCostsPanel(cost_inputs=default_cost_inputs()) })
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
			), 
			ADDOUTPUTS_DATA = rbind.data.frame(
			  sim_data[['presimulated']][['ADDOUTPUTS_DATA']],
			  sim_data[['programChanges1']][['ADDOUTPUTS_DATA']],
			  sim_data[['programChanges2']][['ADDOUTPUTS_DATA']],
			  sim_data[['programChanges3']][['ADDOUTPUTS_DATA']],
			  sim_data[['ttt1']][['ADDOUTPUTS_DATA']],
			  sim_data[['ttt2']][['ADDOUTPUTS_DATA']],
			  sim_data[['ttt3']][['ADDOUTPUTS_DATA']],
			  sim_data[['combination1']][['ADDOUTPUTS_DATA']],
			  sim_data[['combination2']][['ADDOUTPUTS_DATA']],
			  sim_data[['combination3']][['ADDOUTPUTS_DATA']]
			), 
			COSTCOMPARISON_DATA = rbind.data.frame(
			  sim_data[['presimulated']][['COSTCOMPARISON_DATA']],
			  sim_data[['programChanges1']][['COSTCOMPARISON_DATA']],
			  sim_data[['programChanges2']][['COSTCOMPARISON_DATA']],
			  sim_data[['programChanges3']][['COSTCOMPARISON_DATA']],
			  sim_data[['ttt1']][['COSTCOMPARISON_DATA']],
			  sim_data[['ttt2']][['COSTCOMPARISON_DATA']],
			  sim_data[['ttt3']][['COSTCOMPARISON_DATA']],
			  sim_data[['combination1']][['COSTCOMPARISON_DATA']],
			  sim_data[['combination2']][['COSTCOMPARISON_DATA']],
			  sim_data[['combination3']][['COSTCOMPARISON_DATA']]
			)
			)
		})

		# Display the summary statistics in the TTT interventions
    callModule(summaryStatistics, NULL, values, sim_data = sim_data,
      geo_short_code = geo_short_code)

 ### costs calculations 
    ##call the costs module	
    # Construct Reactive Objects which return cost scenario simulations when called
    compute_costs<-callModule(runCostComparisonModule, NULL, 
                              sim_data=combined_data,treat_dist=treatment_distribution[['programchange1']])
  
    # 
    #allows for the values to be changed when user selects change settings
    observeEvent({ 
      input$state
      input[['ChangeSettingsC']] }, {
        cost_data <- NULL
        callModule(costChangeSettingsButton, NULL)
      })
    #stores the costs
    cost_data<-reactiveValues(effects=NULL,
                              costs=NULL,
                              ICER=NULL,
                              ACER=NULL, 
                              annual=NULL)
    
    observeEvent(input[['CalculateCosts']], {
      cost_list<-callModule(costRunButton, NULL, compute_costs)
      cost_data[['effects']]<-cost_list[[1]]
      cost_data[['costs']]<-cost_list[[2]]
      cost_data[['ICER']]<-cost_list[[3]]
      cost_data[['ACER']]<-cost_list[[4]]
      cost_data[['annual']]<-cost_list[[5]]
    })
    
    combined_costdata <- reactive({
      list(
      EFFECTS_DATA = cost_data[['effects']], 
      COSTS_DATA = cost_data[['costs']], 
      COSTEFF_ICER_DATA = cost_data[['ICER']],
      COSTEFF_ACER_DATA = cost_data[['ACER']]
      )
      })
      
		# Tabby1 Visualization Server
		filtered_data <- 
			callModule(
					module = tabby1Server, 
					id = "tabby1", 
					ns = NS("tabby1"), 
					sim_data = combined_data,
					cost_data = combined_costdata,
					geo_short_code = geo_short_code, 
					geographies = geographies) 

    ### Add Data Tables to the Outcomes ###
    # 
    # Note that the filter(type == 'mean') %>% select(-type) works to remove 
    # the confidence intervals that would be depicted if we had a full posterior 
    # sample to work with instead of just the posterior mode / optimum. 
    # 
    # Note that for any developer who is working on adding confidence intervals 
    # to Tabby2: This code only removes the ci_high / ci_low values and the type 
    # column for the data table shown *in* Tabby2. For the data downloads (CSV, 
    # XLSX), make sure to edit the tabby1/tabby1utilities/R/tabby1server.R file, 
    # where the CSV and XLSX downloads also have this type column removed.

    # Add Data Table for Estimates
		output[['estimatesData']] <- 
			DT::renderDataTable(filtered_data[['estimatesData']]() %>% 
                          filter(type == 'mean') %>% 
			                      mutate(scenario = sapply(scenario, function(x) {
			                        if (x %in% c('base_case', names(estimates$interventions$labels), names(estimates$analyses$labels))) {
			                          c(base_case = "Base Case", estimates$interventions$labels, estimates$analyses$labels)[[x]]
			                        } else as.character(x)
			                      })) %>%			                    
			                      select(-type), 
				options = list(pageLength = 25, scrollX = TRUE), 
				rownames=FALSE )  

    # Add Data Table for Time Trends

		output[['trendsData']] <- 
			DT::renderDataTable( filtered_data[['trendsData']]() %>% 
                          filter(type == 'mean') %>% 
			                       mutate(scenario = sapply(scenario, function(x) {
			                         if (x %in% c('base_case', names(trends$interventions$labels), names(trends$analyses$labels))) {
			                           c(base_case = "Base Case", trends$interventions$labels, trends$analyses$labels)[[x]]
			                         } else as.character(x)
			                       })) %>%
                          select(-c(type, year_adj)), 
				options = list(pageLength = 25, scrollX = TRUE), 
				rownames=FALSE )  

    # Add Data Table for Age Groups

		output[['agegroupsData']] <- 
			DT::renderDataTable( filtered_data[['agegroupsData']]() %>% 
                          filter(type == 'mean') %>% 
			                       mutate(scenario = sapply(scenario, function(x) {
			                         if (x %in% c('base_case', names(agegroups$interventions$labels), names(agegroups$analyses$labels))) {
			                           c(base_case = "Base Case", agegroups$interventions$labels, agegroups$analyses$labels)[[x]]
			                         } else as.character(x)
			                       })) %>%
                          select(-type), 
				options = list(pageLength = 25, scrollX = TRUE), 
				rownames=FALSE )  
		
		# Add Data Table for ADDITIONAL OUTCOMES
		output[['addoutputsData']] <- 
		  DT::renderDataTable( filtered_data[['addoutputsData']]() %>% 
		                         filter(type == 'mean') %>%
		                         select(-c(type, year_adj)), 
		                       options = list(pageLength = 25, scrollX = TRUE), 
		                       rownames=FALSE )  
		
		  output[['costcomparisonData1']] <-
		  DT::renderDataTable(
		    #filtered_data[['effectsData']](),
		    datatable(filtered_data[['effectsData']](), 
		               options = list(pageLength = 100, scrollX = TRUE,dom = 't'),
		               rownames=FALSE) %>%          
		      # mutate(scenario = sapply(scenario, function(x) {
		      #            if (x %in% c('base_case', names(costcomparison$interventions$labels), names(costcomparison$analyses$labels))) {
		      #              c(base_case = "Base Case", costcomparison$interventions$labels, costcomparison$analyses$labels)[[x]]
		      #            } else as.character(x)
		      #          })) %>% 
		      formatCurrency(2:5, '', digits = 0))

		  output[['costcomparisonData2']] <-
      DT::renderDataTable(
        datatable(filtered_data[['costsData']](), rownames=FALSE, 
                  options = list(pageLength = 100, scrollX = TRUE,dom = 't')) %>% 
          # mutate(scenario = sapply(scenario, function(x) {
          #   if (x %in% c('base_case', names(costcomparison$interventions$labels), names(costcomparison$analyses$labels))) {
          #     c(base_case = "Base Case", costcomparison$interventions$labels, costcomparison$analyses$labels)[[x]]
          #   } else as.character(x)
          # })) %>%
                  formatCurrency(2:7, '', digits = 0)) 
                                                      
		
      output[['costcomparisonData3']] <- 
      DT::renderDataTable(
        datatable(filtered_data[['costeffData']](),      
                   rownames=FALSE , options = list(pageLength = 25, scrollX = TRUE,dom = 't')) %>%           
                   #  mutate(scenario = sapply(scenario, function(x) {
                   #   if (x %in% c('base_case', names(costcomparison$interventions$labels), names(costcomparison$analyses$labels))) {
                   #     c(base_case = "Base Case", costcomparison$interventions$labels, costcomparison$analyses$labels)[[x]]
                   #   } else as.character(x)
                   # })) %>%
           formatCurrency(2:5, '', digits = 0))
        
      
      output[['costcomparisonData4']] <- 
        DT::renderDataTable(cost_data[['annual']] %>%
                              mutate(Scenario = sapply(Scenario, function(x) {
                                if (x %in% c('base_case', names(costcomparison$interventions$labels), names(costcomparison$analyses$labels))) {
                                  c(base_case = "Base Case", costcomparison$interventions$labels, costcomparison$analyses$labels)[[x]]
                                } else as.character(x)
                              }))
                            , rownames=FALSE , 
                            options = list(pageLength = 25,scrollX = TRUE))
    
      # DT::renderDataTable(
      #   data.frame(A=c(1000000.51,5000.33, 2500, 251), B=c(0.565,0.794, .685, .456)) %>%
      #     datatable(extensions = 'Buttons',
      #               options = list(
      #                 pageLength = 50,
      #                 scrollX=TRUE,
      #                 dom = 'T<"clear">lBfrtip'
      #               )
      #     ) %>%
      #     formatCurrency(1:2, currency = "", interval = 3, mark = ",")
      # ) # close renderDataTable
			
		# Custom Scenarios Choice in Output
		callModule(outputIncludeCustomScenarioOptions, NULL, sim_data)
		
		# Plots for Comparison to Recent Data
		callModule(comparisonToRecentData, NULL, geo_short_code)
		
		# Call Module for Saving additional outputs
		# callModule(addOutputsModule, NULL, geo_short_code, filtered_data)

		# Call Module for Saving Feedback Form Input
		callModule(feedbackFormModule, NULL)

		# Debug Printout Server 
		callModule(debugPrintoutsModule, NULL, values = values)

    # The extraDebugOutputs is a tab of the application only visible when 
    # the Tabby2 application is run with debug <- TRUE in the global environment. 
    # 
    # i.e. run debug <- TRUE, then shiny::runApp() and the debugPrintouts tab will 
    # appear. 
    # 
    # Unless something is rendered there, it will appear empty. It's set up as a 
    # uiOutput, so you can render any HTML to it from the server side that you would like 
    # to as a developer. This can be useful for checking what data looks like at 
    # stages in between its most "raw" format and before its ready to be presented to the 
    # user. 

		# output[['extraDebugOutputs']] <- 
		# 	renderText({
		# 		paste0(apply(combined_data()[['ESTIMATES_DATA']], 2, unique), collapse = "\n")
		# 	})

})
