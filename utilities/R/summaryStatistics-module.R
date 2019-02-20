summaryStatistics <- function(input, output, session) {
	output$ttt1numberTargeted <- renderText({input$ttt1numberTargeted})
	output$ttt2numberTargeted <- renderText({input$ttt2numberTargeted})
	output$ttt3numberTargeted <- renderText({input$ttt3numberTargeted})
}
