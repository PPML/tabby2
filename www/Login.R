# Adapted with modification from https://gist.github.com/withr/9001831 

#### Log in module ###
USER <- reactiveValues(Logged = Logged)

passwdInput <- function(inputId, label) {
  tagList(
    tags$label(label),
    tags$input(id = inputId, class = 'form-control', type="password", value="")
  )
}

output$uiLogin <- renderUI({
  if (USER$Logged == FALSE) {
    wellPanel(
      textInput("userName", "Username:"),
      passwdInput("passwd", "Password:"),
      br(),
      actionButton("Login", "Login")
    )
  }
})

output$pass <- renderText({  
  if (USER$Logged == FALSE) {
    if (!is.null(input$Login)) {
   if (input$Login > 0) {
      Username <- isolate(input$userName)
      Password <- isolate(input$passwd)
      Id.username <- which(PASSWORD$Username == Username)
      Id.password <- which(PASSWORD$Password    == Password)
      if (length(Id.username) > 0 & length(Id.password) > 0) {
        if (Id.username == Id.password) {
          USER$Logged <- TRUE
        } 
      } else  {
        "Login failed"
      }
    } 
    }
  }
})
