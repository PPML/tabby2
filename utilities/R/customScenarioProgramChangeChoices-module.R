customScenarioProgramChangeChoices <- function(input, output, session, sim_data) {

  handle_null_and_empty_str <- function(str, default) { 
    if (length(str) > 0) if (str == '') default else str else NULL
  }

  renderProgramChangesChoice <- function(n) {
    renderUI({

      options <- 
         c(`0` =  "No Change",
           `1` =  if (! is.null(sim_data[['programChanges1']])) handle_null_and_empty_str(input$programChange1Name, 'programChange1') else NULL,
           `2` =  if (! is.null(sim_data[['programChanges2']])) handle_null_and_empty_str(input$programChange2Name, 'programChange2') else NULL,
           `3` =  if (! is.null(sim_data[['programChanges3']])) handle_null_and_empty_str(input$programChange3Name, 'programChange3') else NULL)

      revList <- function(l) {
       lnames <- names(l)
       lcontents <- unlist(l)
       setNames(nm = lcontents, object = lnames)
      }

      radioButtons(
        inputId = paste0('combination', n, "SelectedProgramChange"),
        label = "Select a Care Cascade Change Scenario",
        choices = revList(options))
    })
  }
  
  output$combination1ProgramChangeRadios <- renderProgramChangesChoice(1)
  output$combination2ProgramChangeRadios <- renderProgramChangesChoice(2)
  output$combination3ProgramChangeRadios <- renderProgramChangesChoice(3)
}
