geoShortCode <- function(input, output, session, geographies) { 
  geo_short_code <- reactive({
    # l <- state.abb
    # names(l) <- state.name
    # l <- c(`United States` = "US", l)
    # l[[input$state]]
		# geographies[[input$state]]
		invert_geographies <- setNames(nm = unname(geographies), object = names(geographies))
		invert_geographies[[input$state]]
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
