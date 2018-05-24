library(shiny)

shinyServer(function(input, output) {
  # downloadHandler() takes two arguments, both functions.
  # The content function is passed a filename as an argument, and
  #   it should write out data to that filename.
  output$downloadParameters <- downloadHandler(
    
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      "input_parameters.yaml"
    },
    
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      # cat(str(input))
      # yaml::as.yaml(input)
      cat(yaml::as.yaml(reactiveValuesToList(input)), file = file)
    }
  )
  
  output$outcome_plot <- renderPlot({
    render_plot(DATA, selected_output = input$plot_outcome)
  })
  
})