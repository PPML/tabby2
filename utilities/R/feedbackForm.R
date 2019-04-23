feedbackForm <- function() { 
	tagList(
		column(12, 
		  h2("Have feedback?"),
			"If you have any questions, comments, or feedback that you'd like to share with us, please send it through the below form or email it to ",
			a("ppml@hsph.harvard.edu", href="mailto:ppml@hsph.harvard.edu"),
			br(),
			br(),
			textInput(inputId = 'feedback-emailer',
						    label = 'Email: ',
								placeholder = 'youremail@provider.com',
			          width='300px'),
			textInput(inputId = 'feedback-subject',
								label = 'Subject: ',
								placeholder = 'Comments, concerns, questions, etc.',
								width = '600px'),
		  textAreaInput(inputId = 'feedback-body',
										label = 'Body: ',
										width = '600px', rows=5),
			actionButton(inputId = 'feedback-submit', label = 'Submit'),
			br(),
			uiOutput(outputId = 'feedback-confirmation')
		)
	)
}
