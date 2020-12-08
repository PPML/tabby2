filterOutcomes <- function(input, output, session, sim_data) {
  # get data out of reactiveValues input sim_data
	# AGEGROUPS_DATA <- sim_data[['AGEGROUPS_DATA']]
	# ESTIMATES_DATA <- sim_data[['ESTIMATES_DATA']]
	# TRENDS_DATA <- sim_data[['TRENDS_DATA']]

	sim_data[['ESTIMATES_DATA']] <- 
		reactive({
			req(
				input[[estimates$IDs$controls$comparators]], input[[estimates$IDs$controls$outcomes]],
				c(input[[estimates$IDs$controls$interventions]], input[[estimates$IDs$controls$analyses]], "base_case")
			)
			sim_data[['ESTIMATES_DATA']] %>%
				filter(
					population == input[[estimates$IDs$controls$populations]],
					age_group == input[[estimates$IDs$controls$ages]],
					outcome == input[[estimates$IDs$controls$outcomes]],
					scenario %in% c(input[[estimates$IDs$controls$interventions]], input[[estimates$IDs$controls$analyses]], "base_case", 'programChange1'),
					comparator == input[[estimates$IDs$controls$comparators]]
				) %>%
				arrange(scenario) %>%
				mutate(
					year = recode(as.character(year), '2018'=2000, '2020'=2025, '2025'=2050, '2035'=2075, '2049'=2100),
					year_adj = year + position_year(scenario)
				)
	})

	sim_data[['TRENDS_DATA']] <- 
		reactive({
			req(
				input[[trends$IDs$controls$comparators]],
				input[[trends$IDs$controls$outcomes]],
				c(
					input[[trends$IDs$controls$interventions]],
					input[[trends$IDs$controls$analyses]],
					"base_case"
				)
			)

			sim_data[['TRENDS_DATA']] %>%
				filter(
					population == input[[trends$IDs$controls$populations]],
					age_group == input[[trends$IDs$controls$ages]],
					outcome == input[[trends$IDs$controls$outcomes]],
					scenario %in% c(
						input[[trends$IDs$controls$interventions]],
						input[[trends$IDs$controls$analyses]],
						"base_case",
						"programChange1"
					),
					comparator == input[[trends$IDs$controls$comparators]]
				) %>%
				arrange(scenario) %>%
				mutate(
					year_adj = year + position_year(scenario)
				)
		})

	sim_data[['AGEGROUPS_DATA']] <- 
		reactive({
			req(
				input[[agegroups$IDs$controls$populations]],
				input[[agegroups$IDs$controls$outcomes]],
				c(
					input[[agegroups$IDs$controls$populations]],
					input[[agegroups$IDs$controls$analyses]],
					"base_case"
				),
				input[[agegroups$IDs$controls$years]] >= 2016 &&
					input[[agegroups$IDs$controls$years]] <= 2100
			)
			
				sim_data[['AGEGROUPS_DATA']] %>%
					filter(
						population == input[[agegroups$IDs$controls$populations]],
						outcome == input[[agegroups$IDs$controls$outcomes]],
						year == if (input[[agegroups$IDs$controls$years]] == 2100) 2099 else
							input[[agegroups$IDs$controls$years]],
						scenario %in% c(
							input[[agegroups$IDs$controls$interventions]],
							input[[agegroups$IDs$controls$analyses]],
							"base_case",
							'programChange1'
						),
						comparator == 'absolute_value'
					)
		})
	
	sim_data[['ADDOUTPUTS_DATA']] <-
	  reactive({
	    req(
	      input[[addoutputs$IDs$controls$comparators]],
	      input[[addoutputs$IDs$controls$outcomes]],
	      c(
	        input[[addoutputs$IDs$controls$interventions]],
	        input[[addoutputs$IDs$controls$analyses]],
	        "base_case"
	      )
	    )

	    sim_data[['ADDOUTPUTS_DATA']] %>%
	      filter(
	        population == input[[addoutputs$IDs$controls$populations]],
	        age_group == input[[addoutputs$IDs$controls$ages]],
	        outcome == input[[addoutputs$IDs$controls$outcomes]],
	        scenario %in% c(
	          input[[addoutputs$IDs$controls$interventions]],
	          input[[addoutputs$IDs$controls$analyses]],
	          "base_case",
	          "programChange1"
	        ),
	        comparator == input[[addoutputs$IDs$controls$comparators]]
	      ) %>%
	      arrange(scenario) %>%
	      mutate(
	        year_adj = year + position_year(scenario)
	      )
	  })
	
	sim_data[['COSTCOMPARISON_DATA']] <- 
	  reactive({
	    req(
	      input[[costcomparison$IDs$controls$comparators]],
	      input[[costcomparison$IDs$controls$outcomes]],
	      c(
	        input[[costcomparison$IDs$controls$interventions]],
	        input[[costcomparison$IDs$controls$analyses]],
	        "base_case"
	      )
	    )
	    
	    sim_data[['COSTCOMPARISON_DATA']] %>%
	      filter(
	        population == input[[costcomparison$IDs$controls$populations]],
	        age_group == input[[costcomparison$IDs$controls$ages]],
	        outcome == input[[costcomparison$IDs$controls$outcomes]],
	        scenario %in% c(
	          input[[costcomparison$IDs$controls$interventions]],
	          input[[costcomparison$IDs$controls$analyses]],
	          "base_case",
	          "programChange1"
	        ),
	        comparator == input[[costcomparison$IDs$controls$comparators]]
	      ) %>%
	      arrange(scenario) %>%
	      mutate(
	        year_adj = year + position_year(scenario)
	      )
	  })

	return(sim_data)

}
