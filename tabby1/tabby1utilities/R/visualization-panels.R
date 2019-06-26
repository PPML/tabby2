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
      alt = "LTBI prevalence (per million), in the total US population, for 2016",
			data = 'agegroupsData'
    ),
    class = "agegroups-tab"
  )
}

visualizationPanel <- function(id, title, subtitle, plot, alt = NULL, brush = NULL,
                               click = NULL, dblclick = NULL, active = TRUE, data) {
  class <- paste0(id, "-tab")
  
	tabsetPanel(
	  tabPanel(title = 'plot', {
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
		tabPanel(title = data, 
		  # p('hi')
		  # tableOutput(outputId = data)
			DT::dataTableOutput(outputId = data)
		)
	)
}
