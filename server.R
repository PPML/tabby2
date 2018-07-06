library(shiny)
library(shinyjs)

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
      cat(yaml::as.yaml(reactiveValuesToList(input)), file = file)
    }
  )
  
  # Set Custom Intervention Sliders and Numerics to Update Each Other
  values <- reactiveValues(custom1_mortality_rate=1) 
  observe({
    values$custom1_mortality_rate <- input[['custom1motality-rate-slider']]
    cat(input[['custom1mortality-rate-slider']])
  })
  observe({
    values$custom1_mortality_rate <- input[['custom1mortality-rate-numeric']]
    cat(input[['custom1mortality-rate-numeric']])
  })
  
  output$custom1_mortality_slider <- renderUI({sliderInput(
    inputId = paste0(customn, "mortality-rate-slider"),
    label = "Specify Targeted Population's Relative Mortality Rate",
    min = 1,
    max = 40,
    value = values$custom1_mortality_rate
  )})
  
  output$custom1_mortality_numeric <- renderUI({numericInput(
    inputId = paste0(customn, "mortality-rate-numeric"),
    label = '',
    min = 1, max = 40, 
    value = values$custom1_mortality_rate)
  })
  
  
  output$outcome_plot <- renderPlot({
    render_plot(DATA, selected_output = input$plot_outcome)
  })
  
})