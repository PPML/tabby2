feedbackFormModule <- function(input, output, session) {

	values <- reactiveValues(feedback_sent = F)

	output$`feedback-confirmation` <- renderText({
		if (values[['feedback_sent']]) 'Thank you for your feedback' else NULL
	})

	observeEvent(input[['feedback-submit']], {
		values[['feedback_sent']] <- T

		# Create a log file at ~/tabby2-feedback YYYY-MM-DD HH-MM-SS.txt
		fileConn <- file(paste0('~/tabby2-feedback-', 
			gsub(':', '-', Sys.time()),
			'.txt'))

		# Write each of the feedback form inputs to the log file
		writeLines( 
			c(paste0('emailer: ', input[['feedback-emailer']]),
				paste0('subject: ', input[['feedback-subject']]),
				paste0('body: ', input[['feedback-body']])
				),
			fileConn)
		 
		close(fileConn)
	})
}
