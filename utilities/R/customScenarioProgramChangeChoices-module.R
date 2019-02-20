customScenarioProgramChangeChoices <- function(input, output, session) {
  renderProgramChangesChoice <- function(n) {
    renderUI({
      radioButtons(
        inputId = paste0('scenario', n, "ProgramChange"),
        label = "Select a Program Change",
        choices = c(
          "No Change", 
          if (input$programChange1Name != '') input$programChange1Name else NULL,
          if (input$programChange2Name != '') input$programChange2Name else NULL,
          if (input$programChange3Name != '') input$programChange3Name else NULL))
    })
  }
  
  output$custom1ProgramChangeRadios <- renderProgramChangesChoice(1)
  output$custom2ProgramChangeRadios <- renderProgramChangesChoice(2)
  output$custom3ProgramChangeRadios <- renderProgramChangesChoice(3)
}
