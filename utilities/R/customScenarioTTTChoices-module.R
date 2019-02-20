customScenarioTTTChoices <- function(input, output, session) {
  renderTTTRadioChoice <- function(n) {
    renderUI({
      radioButtons(
        inputId = paste0('scenario', n, "TLTBI"),
        label = "Select a Targeted LTBI Treatment Intervention",
        choices = c(
          "No Intervention",
          if (input$ttt1name != '') input$ttt1name else NULL,
          if (input$ttt2name != '') input$ttt2name else NULL,
          if (input$ttt3name != '') input$ttt3name else NULL))
    })
  }
  output$custom1TTTRadios <- renderTTTRadioChoice(1)
  output$custom2TTTRadios <- renderTTTRadioChoice(2)
  output$custom3TTTRadios <- renderTTTRadioChoice(3)
}
