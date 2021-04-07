estimatesVisualizationPanel <- function(ns) {
	tagAppendAttributes(
    visualizationPanel(
      id = ns(estimates$IDs$panels$visualization),
      title = ns(estimates$IDs$title),
      subtitle = ns(estimates$IDs$subtitle),
      plot = ns(estimates$IDs$plot),
      alt = "New TB infections, in the total US population, all age groups",
      brush = brushOpts(
        id = ns(estimates$IDs$brush),
        fill = "transparent",
        stroke = "#000000"
      ),
      click = clickOpts(estimates$IDs$click),
      dblclick = dblclickOpts(estimates$IDs$dblclick),
			data = 'estimatesData'
    ),
    class = "estimates-tab"
  )
}

trendsVisualizationPanel <- function(ns) {
  tagAppendAttributes(
    visualizationPanel(
      id = ns(trends$IDs$panels$visualization),
      title = ns(trends$IDs$title),
      subtitle = ns(trends$IDs$subtitle),
      plot = ns(trends$IDs$plot),
      alt = "New TB infections, in the total US population, all age groups",
			data = 'trendsData'
    ),
    class = "trends-tab"
  )
}

agegroupsVisualizationPanel <- function(ns) {
  tagAppendAttributes(
    visualizationPanel(
      id = ns(agegroups$IDs$panels$visualization),
      title = ns(agegroups$IDs$title),
      subtitle = NULL,
      plot = ns(agegroups$IDs$plot),
      alt = "LTBI prevalence (per hundred thousand), in the total US population, for 2018",
			data = 'agegroupsData'
    ),
    class = "agegroups-tab"
  )
}

addoutputsVisualizationPanel <- function(ns) {
  tagAppendAttributes(
    visualizationPanel(
      id = ns(addoutputs$IDs$panels$visualization),
      title = ns(addoutputs$IDs$title),
      subtitle = ns(addoutputs$IDs$subtitle),
      plot = ns(addoutputs$IDs$plot),
      alt = "Counts of LTBI Tests (in Thousands), in the total US population, all age groups",
      data = 'addoutputsData'
    ),
    class = "addoutputs-tab"
  )
}

visualizationPanel <- function(id, title, subtitle, plot, alt = NULL, brush = NULL,
                               click = NULL, dblclick = NULL, active = TRUE, data) {
  class <- paste0(id, "-tab")
  
	tabsetPanel(
	  tabPanel(title = 'Plot', {
			tags$div(
				class = paste(c(class, "tab-pane", if (active) " active"), collapse = " "),
				if (!is.null(title)) {
					tags$h3(
						textOutput(title)
					)
				},
				if (!is.null(subtitle)) {
					tags$h4(
						textOutput(subtitle)
					)
				},
				do.call(
					tagAppendAttributes,
					c(
						list(
							tag = withSpinner(tags$div(
								id = plot,
								class = "shiny-plot-output",
								style = "width: 90%; height: 600px;",
								`data-alt` = alt,
								tags$img(alt = alt)
							))
						)
					)
				)
			)
		}),
		tabPanel(title = 'Results Table', 
			DT::dataTableOutput(outputId = data)
		)
	)
}

costVisualizationPanel <- function(id, title, subtitle, plot, alt = NULL, brush = NULL,
                               click = NULL, dblclick = NULL, active = TRUE, data1) {
  class <- paste0(id, "-tab")
  column(11,{
  tabsetPanel(
    tabPanel(title = 'Comparison Table',{ 
      fluidRow(
        br(),
        br(),
        wellPanel(
       h3("Cost Effectiveness Table"),
       DT::dataTableOutput(outputId = data1)
        )
       ,
       actionButton(
         inputId = 'toCostOutputs2',
         label = 'View Costs and Outcomes',
         class = 'btn-primary',
         style = 'color: white;'
       ),
       actionButton(
         inputId = 'toInputCosts2',
         label = 'Change Unit Costs',
         class = 'btn-primary',
         style = 'color: white;'
       )
       
       )#end of fluid row
      })
  )
  })
}

costComparisonVisualizationPanel <- function(ns) {
  tagAppendAttributes(
    costVisualizationPanel(
      id = ns(costcomparison$IDs$panels$visualization),
      title = ns(costcomparison$IDs$title),
      subtitle = ns(costcomparison$IDs$subtitle),
      plot = ns(costcomparison$IDs$plot),
      alt = "Cost of Intervention",
      data1 = 'costcomparisonData3', 
    ),
      class = "costcomparison-tab"
  )
}

cost2VisualizationPanel <- function(id, title, subtitle, plot, alt = NULL, brush = NULL,
                                   click = NULL, dblclick = NULL, active = TRUE, data1, data2, data3) {
  class <- paste0(id, "-tab")
  column(11,{
  tabsetPanel(
    tabPanel(title = 'Summary Tables',{ 
      fluidRow(
        br(),
        br(),
        wellPanel(
        h3("Outcomes Table"),
        DT::dataTableOutput(outputId = data1)
        ),
        wellPanel(
        h3("Costs Table (in mil)"),
        DT::dataTableOutput(outputId = data2)
        ),
        actionButton(
          inputId = 'toCostComparison',
          label = 'View Cost Comparison',
          class = 'btn-primary',
          style = 'color: white;'
        ),
        actionButton(
          inputId = 'toInputCosts',
          label = 'Change Unit Costs',
          class = 'btn-primary',
          style = 'color: white;'
        )
      ) #end of fluid row
    }),
    tabPanel(title = 'Annual Table',{ 
      fluidRow(
        # h3("Effects Table"),
        DT::dataTableOutput(outputId = data3)
      )
    })
    
  )
  })
}

costsOutcomesVisualizationPanel <- function(ns) {
  tagAppendAttributes(
    cost2VisualizationPanel(
      id = ns(costsoutcomes$IDs$panels$visualization),
      title = ns(costsoutcomes$IDs$title),
      subtitle = ns(costsoutcomes$IDs$subtitle),
      plot = ns(costsoutcomes$IDs$plot),
      alt = "Cost of Intervention",
      data1 = 'costcomparisonData1', 
      data2 ='costcomparisonData2',
      data3 ='costcomparisonData4', 
    ),
    class = "costsoutcomes-tab"
  )
}
