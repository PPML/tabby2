nextBackButtons <- function(input, output, session) {
  observeEvent(input$toPredefinedScenarios, updateTabItems(session = session, inputId = 'sidebar', selected = "predefined"))
  observeEvent(input$toAbout, updateTabItems(session = session, inputId = 'sidebar', selected = "about"))
  observeEvent(input$toEstimates, updateTabItems(session = session, inputId = 'sidebar', selected = "estimates"))
  observeEvent(input$toBuildScenarios, updateTabItems(session = session, inputId = 'sidebar', selected = "customscenarios"))
}
