summaryStatistics <- function(input, output, session) {
	output$ttt1numberTargeted <- renderText({input$ttt1numberTargeted})
	output$ttt2numberTargeted <- renderText({input$ttt2numberTargeted})
	output$ttt3numberTargeted <- renderText({input$ttt3numberTargeted})

	output$ttt1AgeNativityIncidence <- renderText({ paste0("Incidence: ",
		round(runif(1), 2), "%",
		input$ttt1nativity,
		' ',
		input$ttt1agegroups
		) })

	output$ttt2AgeNativityIncidence <- renderText({ paste0("Incidence: ",
		round(runif(1), 2), "%") })

	output$ttt3AgeNativityIncidence <- renderText({ paste0("Incidence: ",
		round(runif(1), 2), "%") })
}
