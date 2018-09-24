library(shiny)
library(shinydashboard)
devtools::load_all("utilities")
source("tabby1/tabby1dependencies.R")
devtools::load_all("tabby1/tabby1utilities")
source("tabby1/tabby1global.R")

# Global Variables ----
tabnames <- c(
  about = "Introduction",
  scenarios = "Scenarios",
  predefined = "Predefined Scenarios",
  customscenarios = "Build Scenarios",
  # tltbi = "Targeted LTBI Testing",
  estimates = "Estimates",
  timetrends = "Time Trends",
  agegroups = "Age Groups",
  downloads = "Downloads",
  readmore = "Further Description"
)

tabcontents <- list(
  about = aboutUI(),
  scenarios = NULL,
  predefined = NULL,
  customscenarios = scenariosUI(),
  # tltbi = customInterventionsUI(),
  estimates = tabby1Estimates('tabby1'),
  timetrends = tabby1TimeTrends('tabby1'),
  agegroups = tabby1AgeGroups('tabby1'),
  downloads = downloadsAndSettingsUI(),
  readmore = readmoreUI()
)

# Sidebar Menu ----
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(tabnames[[1]], tabName = names(tabnames)[[1]], selected = T), # intro
    menuItem(tabnames[[2]], tabName = names(tabnames)[[2]], startExpanded = T, # scenarios menu dropdown
      menuItem(tabnames[[3]], tabName = names(tabnames)[[3]]), # custom model scenarios
      menuItem(tabnames[[4]], tabName = names(tabnames)[[4]]) # ltbi ttt
    ),
    menuItem(
      "Outcomes", startExpanded = T,
      menuItem(tabnames[[5]], tabName = names(tabnames)[[5]]), # tabby1 estimates
      menuItem(tabnames[[6]], tabName = names(tabnames)[[6]]), # tabby1 time trends
      menuItem(tabnames[[7]], tabName = names(tabnames)[[7]])  # tabby1 age groups
    ),
    menuItem(tabnames[[8]], tabName = names(tabnames)[[8]]), # downloads
    menuItem(tabnames[[9]], tabName = names(tabnames)[[9]])  # further description
  )
)

# Dashboard Body ----
body <- dashboardBody(
  tagList(
    tags$head(
      tags$style(HTML(
"
@import url('//fonts.googleapis.com/css?family=Josefin+Slab');

.logo {
font-family: 'Josefin Slab' !important ;
font-size: 25px !important;
}
"))
      ),
    
  # This is an anonymous function which does the exact same thing 
  # as tabItems() except that it does not call list() on `...`.
  # This allows me to pass a list which I construct with a vectorized
  # operation, namely lapply.
  # This is just 
  # tabItems(tabItem(), ...), but written in a way that allows me
  # to automatically loop over my tabnames and tabcontents variables.
  (function (...) 
  {
    lapply(..., shinydashboard:::tagAssert, class = "tab-pane")
    div(class = "tab-content", ...)
  })(lapply(seq_along(tabnames), function(x) {
    tabItem(tabName = names(tabnames)[[x]], tabcontents[[x]])
  }))
  )
  
)

# Run the Application ----
shinyUI(
  dashboardPage(
    dashboardHeader(title = 'TabbyII'),
    sidebar,
    body
))


