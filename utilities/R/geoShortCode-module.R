geoShortCode <- function(input, output, session) { 
  geo_short_code <- reactive({
    l <- state.abb
    names(l) <- state.name
    l <- c(`United States` = "US", l)
    l[[input$state]]
  })

  # Output the Selected Geography
  output$location_selected <- renderUI({
    tags$a(paste0("Location: ", input$state))
  })

	# Output short-code for use in plot titles
  output$geo_short_code <- renderText({ geo_short_code() }) 	
	
	# return the reactive for use elsewhere in our server
	return(geo_short_code)
}
