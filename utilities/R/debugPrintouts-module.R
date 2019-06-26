#' Render a Debug Printouts Panel to See Reactive Values
#' 
#' To help with debugging the reactive values used in this application, a 
#' debugging option can be turned on inside the application which adds 
#' another sidebarPanel to the application in which the contents of the 
#' values object is rendered as text. To use this feature, assign
#' debug <- TRUE before running the application via runApp().

debugPrintoutsModule <- function(input, output, session, values) {
  if (exists('debug', envir = .GlobalEnv) && isTRUE(get('debug', envir = .GlobalEnv))) {
    output$debugPrintouts <- renderUI({ 
		  tabsetPanel(
			  tabPanel(title = 'user_settings', 
					tagList(
						HTML(paste0(capture.output(Hmisc::list.tree(reactiveValuesToList(values), maxlen = 80)), collapse = "<br>"))
					)
				),
				tabPanel(title = 'extraDebugOutputs', 
				  verbatimTextOutput('extraDebugOutputs')
				)
			)
    })
  }
}
