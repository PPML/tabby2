summaryStatistics <- function(input, output, session, values, sim_data) {

	TRENDS_DATA <- sim_data[['presimulated']][['TRENDS_DATA']]

	output$ttt1numberTargeted <- renderText({input$ttt1numberTargeted})
	output$ttt2numberTargeted <- renderText({input$ttt2numberTargeted})
	output$ttt3numberTargeted <- renderText({input$ttt3numberTargeted})

	# Reactive Values for the Incidence in Age-Nativity Group
  ageNativityIncidenceForTTT <- function(n) { 
		reactive({
			value <- TRENDS_DATA %>% 
				filter(age_group == input[[paste0('ttt', n, 'agegroups')]],
							 population == input[[paste0('ttt', n, 'nativity')]],
							 outcome == 'tb_incidence_per_mil',
							 scenario == 'base_case',
							 year == 2018,
							 comparator == 'absolute_value',
							 type == 'mean'
							 ) %>% `[[`('value') 

			paste0("Incidence per Million: ", round(value, 2))
		 })
	 }

  ageNativityPrevalenceForTTT <- function(n) { 
		reactive({
			value <- TRENDS_DATA %>% 
				filter(age_group == input[[paste0('ttt', n, 'agegroups')]],
							 population == input[[paste0('ttt', n, 'nativity')]],
							 outcome == 'pct_ltbi',
							 scenario == 'base_case',
							 year == 2018,
							 comparator == 'absolute_value',
							 type == 'mean'
							 ) %>% `[[`('value') 

				paste0("LTBI Prevalence: ", round(value, 2), "%")
		 })
	 }


	# Reactive Values for the Prevalence in Age-Nativity Group
	output$ttt1AgeNativityIncidence <- renderText({ ageNativityIncidenceForTTT(1)() })
	output$ttt1AgeNativityPrevalence <- renderText({ ageNativityPrevalenceForTTT(1)() })
	output$ttt2AgeNativityIncidence <- renderText({ ageNativityIncidenceForTTT(2)() })
	output$ttt2AgeNativityPrevalence <- renderText({ ageNativityPrevalenceForTTT(2)() })
	output$ttt3AgeNativityIncidence <- renderText({ ageNativityIncidenceForTTT(3)() })
	output$ttt3AgeNativityPrevalence <- renderText({ ageNativityPrevalenceForTTT(3)() })

	# return(tttAgeNativity)
}
