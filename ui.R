library(shiny)
library(shinyFeedback)
library(shinydashboard)
library(shinyjs)
devtools::load_all("utilities")
source("tabby1/tabby1dependencies.R")
devtools::load_all("tabby1/tabby1utilities")
source("tabby1/tabby1global.R")
source("globals.R")

# Global Variables ----
# tabnames <- c(
#   about = "Introduction",
#   scenarios = "Scenarios",
#   predefined = "Predefined Scenarios",
#   customscenarios = "Build Scenarios",
#   estimates = "Estimates",
#   timetrends = "Time Trends",
#   agegroups = "Age Groups",
#   calibration = "Comparison to Recent Data",
#   downloads = "Downloads",
#   readmore = "Further Description"
# )

# tabcontents <- list(
#   about = aboutUI(),
#   scenarios = NULL,
#   predefined = standardInterventionsUI(),
#   customscenarios = scenariosUI(),
#   estimates = tabby1Estimates('tabby1'),
#   timetrends = tabby1TimeTrends('tabby1'),
#   agegroups = tabby1AgeGroups('tabby1'),
#   calibration = comparison_to_recent_data(),
#   downloads = downloadsAndSettingsUI(),
#   readmore = readmoreUI()
# )

# if (exists('debug', envir = .GlobalEnv) && isTRUE(debug)) {
#   tabnames[['debug']] <- 'Debug Printouts'
#   tabcontents[['debug']] <- debugPrintouts()
# }

# Sidebar Menu ----
sidebar <- dashboardSidebar(
  sidebarMenu(id = 'sidebar',
    menuItem(tabnames[[1]], tabName = names(tabnames)[[1]], selected = T), # intro
    menuItem(tabnames[[2]], tabName = names(tabnames)[[2]], startExpanded = T, # scenarios menu dropdown
      menuItem(tabnames[[3]], tabName = names(tabnames)[[3]]), # pre-defined scenarios
      menuItem(tabnames[[4]], tabName = names(tabnames)[[4]]) # custom scenarios
    ),
    menuItem(
      "Modelled Outcomes", startExpanded = T,
      menuItem(tabnames[[5]], tabName = names(tabnames)[[5]]), # tabby1 estimates
      menuItem(tabnames[[6]], tabName = names(tabnames)[[6]]), # tabby1 time trends
      menuItem(tabnames[[7]], tabName = names(tabnames)[[7]]),  # tabby1 age groups
      menuItem(tabnames[[8]], tabName = names(tabnames)[[8]])  # comparison to recent data
      
    ),
    # menuItem(tabnames[[9]], tabName = names(tabnames)[[9]]), # downloads
    menuItem(tabnames[[9]], tabName = names(tabnames)[[9]]),  # further description
		menuItem(tabnames[[10]], tabName = names(tabnames)[[10]]),
    if (
      exists('debug', envir = .GlobalEnv) && isTRUE(debug)
      ) { menuItem(tabnames[[11]], tabName = names(tabnames)[[11]]) # debug printouts
    } else { NULL },
		# render location selected
    tags$li(uiOutput('location_selected'), style = 'position: absolute; bottom: 20px; left: 20px;')
  )
)

# Dashboard Body ----
body <- dashboardBody(
  tagList(
    useShinyjs(),
    useShinyFeedback(),
    tags$head(

			tags$link(rel="stylesheet", type="text/css",href="style.css"),
			tags$script(type="text/javascript", src = "md5.js"),
			tags$script(type="text/javascript", src = "passwdInputBinding.js"),
			tags$script(src='disable-ttt.js'),
			HTML(
				"<!-- Global site tag (gtag.js) - Google Analytics -->
				<script async src='https://www.googletagmanager.com/gtag/js?id=UA-108248643-2'></script>
				<script>
					window.dataLayer = window.dataLayer || [];
					function gtag(){dataLayer.push(arguments);}
					gtag('js', new Date());

					gtag('config', 'UA-108248643-2');
				</script>
				")
      ),

		# div(class = "login", id = 'uiLogin', uiOutput("uiLogin"), textOutput("pass")),

		# uiOutput('page')
	
    
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

shinyUI(dashboardPage(
    dashboardHeader(title = "Tabby2",
			dropdownMenu(type = 'notifications', icon = icon('link'), # badgeStatus = F,
				notificationItem(
				  text = "Go to the PPML Website", 
					href='https://prevention-policy-modeling-lab.sph.harvard.edu/',
					icon = icon("link")
				),
				notificationItem(
				  text = "Go to ppmltools.org",
					href='https://ppmltools.org/',
					icon = icon('link')
				)
			)
		),
    sidebar,
		body
	))

