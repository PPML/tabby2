estimatesControlPanel  <- function(ns) {
  controlPanel(
    class = "estimates-tab",
    comparators = radioButtons2(
      id = ns(estimates$IDs$controls$comparators),
      heading = estimates$comparators$heading,
      labels = estimates$comparators$labels,
      values = estimates$comparators$values,
      selected = estimates$comparators$selected
    ),
    populations = radioButtons2(
      id = ns(estimates$IDs$controls$populations),
      heading = estimates$populations$heading,
      labels = estimates$populations$labels,
      values = estimates$populations$values,
      selected = estimates$populations$selected
    ),
    ages = radioButtons2(
      id = ns(estimates$IDs$controls$ages),
      heading = estimates$ages$heading,
      labels = estimates$ages$labels,
      values = estimates$ages$values,
      selected = estimates$ages$selected
    ),
    outcomes = radioButtons2(
      id = ns(estimates$IDs$controls$outcomes),
      heading = estimates$outcomes$heading,
      labels = estimates$outcomes$labels,
      values = estimates$outcomes$values,
      selected = estimates$outcomes$selected,
    ),
    interventions = uiOutput('estimatesInterventions'),
    analyses = checkboxGroup2(
      id = ns(estimates$IDs$controls$analyses),
      heading = estimates$analyses$heading,
      labels = estimates$analyses$labels,
      values = estimates$analyses$values,
    ),
    labels = selectInput(
      inputId = ns(estimates$IDs$controls$labels),
      label = estimates$labels$heading,
      choices = estimates$labels$labels,
      selectize = FALSE
    ),
    downloads = downloadButtonBar(
      ids = ns(estimates$IDs$downloads),
      heading = estimates$downloads$heading,
      labels = estimates$downloads$labels
    )
  )
}

trendsControlPanel <- function(ns) {
  controlPanel(
    class = "trends-tab",
    comparators = radioButtons2(
      id = ns(trends$IDs$controls$comparators),
      heading = trends$comparators$heading,
      labels = trends$comparators$labels,
      values = trends$comparators$values,
      selected = trends$comparators$selected
    ),
    populations = radioButtons2(
      id = ns(trends$IDs$controls$populations),
      heading = trends$populations$heading,
      labels = trends$populations$labels,
      values = trends$populations$values,
      selected = trends$populations$selected
    ),
    ages = radioButtons2(
      id = ns(trends$IDs$controls$ages),
      heading = trends$ages$heading,
      labels = trends$ages$labels,
      values = trends$ages$values,
      selected = trends$ages$selected
    ),
    outcomes = radioButtons2(
      id = ns(trends$IDs$controls$outcomes),
      heading = trends$outcomes$heading,
      labels = trends$outcomes$labels,
      values = trends$outcomes$values,
      selected = trends$outcomes$selected,
      descriptions = trends$outcomes$descriptions
    ),
    interventions = uiOutput('trendsInterventions'),
    analyses = checkboxGroup2(
      id = ns(trends$IDs$controls$analyses),
      heading = trends$analyses$heading,
      labels = trends$analyses$labels,
      values = trends$analyses$values,
    ),
    downloads = downloadButtonBar(
      ids = ns(trends$IDs$downloads),
      heading = trends$downloads$heading,
      labels = trends$downloads$labels
    )
  )
}

agegroupsControlPanel <- function(ns) {
  controlPanel(
    class = "agegroups-tab",
    populations = radioButtons2(
      id = ns(agegroups$IDs$controls$populations),
      heading = agegroups$populations$heading,
      labels = agegroups$populations$labels,
      values = agegroups$populations$values,
      selected = agegroups$populations$selected
    ),
    years = {
      si <- selectInput(
        inputId = ns(agegroups$IDs$controls$years),
        label = agegroups$years$heading,
        choices = seq(from = agegroups$years$min, to = agegroups$years$max),
        selectize = FALSE
      )
      si$children[[2]]$children[[1]]$attribs$size <- 5
      si
    },
    outcomes = radioButtons2(
      id = ns(agegroups$IDs$controls$outcomes),
      heading = agegroups$outcomes$heading,
      labels = agegroups$outcomes$labels,
      values = agegroups$outcomes$values,
      selected = agegroups$outcomes$selected
    ),
    interventions = uiOutput('agesInterventions'),
    analyses = checkboxGroup2(
      id = ns(agegroups$IDs$controls$analyses),
      heading = agegroups$analyses$heading,
      labels = agegroups$analyses$labels,
      values = agegroups$analyses$values
    ),
    downloads = downloadButtonBar(
      ids = ns(agegroups$IDs$downloads),
      heading = agegroups$downloads$heading,
      labels = agegroups$downloads$labels
    )
  )
}

addoutputsControlPanel <- function(ns) {
  controlPanel(
    class = "addoutputs-tab",
    comparators = radioButtons2(
      id = ns(addoutputs$IDs$controls$comparators),
      heading = addoutputs$comparators$heading,
      labels = addoutputs$comparators$labels,
      values = addoutputs$comparators$values,
      selected = addoutputs$comparators$selected
    ),
    populations = radioButtons2(
      id = ns(addoutputs$IDs$controls$populations),
      heading = addoutputs$populations$heading,
      labels = addoutputs$populations$labels,
      values = addoutputs$populations$values,
      selected = addoutputs$populations$selected
    ),
    ages = radioButtons2(
      id = ns(addoutputs$IDs$controls$ages),
      heading = addoutputs$ages$heading,
      labels = addoutputs$ages$labels,
      values = addoutputs$ages$values,
      selected = addoutputs$ages$selected
    ),
    outcomes = radioButtons2(
      id = ns(addoutputs$IDs$controls$outcomes),
      heading = addoutputs$outcomes$heading,
      labels = addoutputs$outcomes$labels,
      values = addoutputs$outcomes$values,
      selected = addoutputs$outcomes$selected,
      descriptions = addoutputs$outcomes$descriptions
    ),
    interventions = uiOutput('addoutputsInterventions'),
    analyses = checkboxGroup2(
      id = ns(addoutputs$IDs$controls$analyses),
      heading = addoutputs$analyses$heading,
      labels = addoutputs$analyses$labels,
      values = addoutputs$analyses$values,
    ),
    downloads = downloadButtonBar(
      ids = ns(addoutputs$IDs$downloads),
      heading = addoutputs$downloads$heading,
      labels = addoutputs$downloads$labels
    )
  )
}

costComparisonControlPanel <- function(ns) {
  costControlPanel(
    class = "costcomparison-tab",
    costs = radioButtons2(
      id = ns(costcomparison$IDs$controls$costs),
      heading = costcomparison$costs$heading,
      labels = costcomparison$costs$labels,
      values = costcomparison$costs$values,
      selected = costcomparison$costs$selected,
      descriptions = costcomparison$costs$descriptions
    ),
    perspectives = radioButtons2(
      id = ns(costcomparison$IDs$controls$perspectives),
      heading = costcomparison$perspectives$heading,
      labels = costcomparison$perspectives$labels,
      values = costcomparison$perspectives$values,
      selected = costcomparison$perspectives$selected,
      descriptions = costcomparison$perspectives$descriptions
    ),
    discount = radioButtons2(
      id = ns(costcomparison$IDs$controls$discount),
      heading = costcomparison$discount$heading,
      labels = costcomparison$discount$labels,
      values = costcomparison$discount$values,
      selected = costcomparison$discount$selected,
      descriptions = costcomparison$discount$descriptions
    ),
    comparator = radioButtons2(
      id = ns(costcomparison$IDs$controls$comparator),
      heading = costcomparison$comparator$heading,
      labels = costcomparison$comparator$labels,
      values = costcomparison$comparator$values,
      selected = costcomparison$comparator$selected,
      descriptions = costcomparison$comparator$descriptions
    ),
    interventions = uiOutput('costcomparisonInterventions'),
    analyses = checkboxGroup2(
      id = ns(costcomparison$IDs$controls$analyses),
      heading = costcomparison$analyses$heading,
      labels = costcomparison$analyses$labels,
      values = costcomparison$analyses$values,
    ),
    downloads = downloadButtonBar(
      ids = ns(costcomparison$IDs$downloads),
      heading = costcomparison$downloads$heading,
      labels = costcomparison$downloads$labels
    )
  )
}


controlPanel <- function(class, active = TRUE, comparators = NULL,
                         populations = NULL, ages = NULL, years = NULL,
                         outcomes = NULL, interventions = NULL,
                         analyses = NULL, labels = NULL, downloads = NULL) {
  tags$div(
    class = class,
    class = paste(c(class, "tab-pane", if (active) "active"), collapse = " "),
    comparators,
    populations,
    ages,
    years,
    outcomes,
    interventions,
    # if (class=="trends-tab") {
    #   checkboxGroup2(
    #     id = paste0("tabby1-", strsplit(class, "-")[[1]][[1]],
    #                 "UncertaintyInterval"),
    #     heading = "Uncertainty Intervals",
    #     labels = "Add uncertainty intervals to plots",
    #     values = "uncertainty_intervals",
    #     selected = TRUE
    #   )
    # },
    labels,
    downloads
  )
}

costControlPanel <- function(class, active = TRUE, costs = NULL,
                             perspectives = NULL, discount = NULL, comparator=NULL,
                             outcomes = NULL, interventions = NULL,
                             analyses = NULL, labels = NULL, downloads = NULL) {
  tags$div(
    class = class,
    class = paste(c(class, "tab-pane", if (active) "active"), collapse = " "),
    outcomes,
    interventions,
    comparator,
    costs,
    perspectives,
    discount,

    # if (class=="trends-tab") {
    #   checkboxGroup2(
    #     id = paste0("tabby1-", strsplit(class, "-")[[1]][[1]],
    #                 "UncertaintyInterval"),
    #     heading = "Uncertainty Intervals",
    #     labels = "Add uncertainty intervals to plots",
    #     values = "uncertainty_intervals",
    #     selected = TRUE
    #   )
    # },
    labels,
    downloads
  )
}
