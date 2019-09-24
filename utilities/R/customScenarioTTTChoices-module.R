customScenarioTTTChoices <- function(input, output, session, sim_data) {

  handle_null_and_empty_str <- function(str, default) { 
    if (length(str) > 0) if (str == '') default else str else NULL
  }

  renderTTTRadioChoice <- function(n) {
    renderUI({

      options <- 
        c(`0` = "No Intervention",
          `1` = if (! is.null(sim_data[['ttt1']])) handle_null_and_empty_str(input$ttt1name, 'ttt1') else NULL,
          `2` = if (! is.null(sim_data[['ttt2']])) handle_null_and_empty_str(input$ttt2name, 'ttt2') else NULL,
          `3` = if (! is.null(sim_data[['ttt3']])) handle_null_and_empty_str(input$ttt3name, 'ttt3') else NULL)

      revList <- function(l) {
       lnames <- names(l)
       lcontents <- unlist(l)
       setNames(nm = lcontents, object = lnames)
      }

      radioButtons(
        inputId = paste0('combination', n, "SelectedTTT"),
        label = "Select a Targeted Testing and Treatment Intervention",
        choices = revList(options))
    })
  }
  output$combination1TTTRadios <- renderTTTRadioChoice(1)
  output$combination2TTTRadios <- renderTTTRadioChoice(2)
  output$combination3TTTRadios <- renderTTTRadioChoice(3)
}
