summaryStatistics <- function(input, output, session, values) {
	output$ttt1numberTargeted <- renderText({input$ttt1numberTargeted})
	output$ttt2numberTargeted <- renderText({input$ttt2numberTargeted})
	output$ttt3numberTargeted <- renderText({input$ttt3numberTargeted})

	# output$ttt1AgeNativityIncidence <- renderText({ paste0("Incidence: ",
	# 	round(runif(1), 2), "%"
	# 	) })
	output$ttt1AgeNativityIncidence <- renderText({ values[['ttt1AgeNativityIncidence']]() })
	output$ttt1AgeNativityPrevalence <- renderText({ values[['ttt1AgeNativityPrevalence']]() })

	output$ttt2AgeNativityIncidence <- renderText({ paste0("Incidence: ",
		round(runif(1), 2), "%") })

	output$ttt3AgeNativityIncidence <- renderText({ paste0("Incidence: ",
		round(runif(1), 2), "%") })

	tttAgeNativity <- reactive({ 
	  c(input$ttt1agegroups,
		  input$ttt2agegroups,
			input$ttt3agegroups,
			input$ttt1nativity,
			input$ttt2nativity,
			input$ttt3nativity) })

	return(tttAgeNativity)
}
