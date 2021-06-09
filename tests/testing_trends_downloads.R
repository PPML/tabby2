#!/bin/Rscript

# When this shiny test is run: 
# 
# - a headless browser launches running shiny 
# - selects each geography
# - downloads the base case trends data for each outcome in absolute numbers
# - each of the downloads are renamed to reflect what data they contain


# before we run the shinytest which downloads the Estimates data, 
# we need to delete the data that's in the test's download folder

current_files <- list.files("testing_trends_downloads-current/", full.names=T)
file.remove(current_files)


# start a new headless browser running Tabby2
library(shinytest)
app <- ShinyDriver$new("../")

# name the test so that the data downloaded goes into downloadEstimates-current

app$snapshotInit("testing_trends_downloads")

# these are the geographies downloaded in this test 

geographies <- c("United States", "Alabama", "Alaska", "Arizona", "Arkansas", 
                 "California", "Colorado", "Connecticut", "Delaware", "Florida", 
                 "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", 
                 "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", 
                 "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", 
                 "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", 
                 "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", 
                 "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", 
                 "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", 
                 "West Virginia", "Wisconsin", "Wyoming")



# select each location, then go to trends, and  save each of the outcomes
# available in the estimates page

for (location in geographies) { 

  app$setInputs(sidebar = "timetrends")
  app$setInputs(sidebar = "about")
  app$setInputs(state = location)
  app$setInputs(sidebar = "timetrends")
  app$setInputs(`tabby1-trendsOutcomes` = "tb_infection_per_100k")
  app$snapshotDownload("tabby1-trendsCSV")
  app$setInputs(`tabby1-trendsOutcomes` = "pct_ltbi")
  app$snapshotDownload("tabby1-trendsCSV")
  app$setInputs(`tabby1-trendsOutcomes` = "tb_incidence_per_100k")
  app$snapshotDownload("tabby1-trendsCSV")
  app$setInputs(`tabby1-trendsOutcomes` = "tb_mortality_per_100k")
  app$snapshotDownload("tabby1-trendsCSV")
}


# the downloads' filenames are unfortunately overwritten by whatever 
# shinytest does to put them in the testing_trends_downloads-current/ folder.
#
# as a result, the downloads from this shinytest come out with names 
# 1.csv, 2.csv, etc. until we rename them in this next step.
# 
# the renaming here is done by making use of the fact that we know the 
# order in which we performed the downloads. 
# 
# i.e., we went through each of the geographies and downloaded the 4 
# files in order: tb incidence, tb infection, pct ltbi, tb deaths
#


filenames <- rep(geographies, each=4)
outcomes <- c("_incident_infections.csv",
              "_ltbi.csv",
              "_tb_incidence.csv",
              "_tb_deaths.csv")

# filenames are constructed using the filenames and 
# outcomes lists

filenames <- sapply(1:length(filenames), function(iter) {
    file.path("testing_trends_downloads-current/", 
      paste0(filenames[[iter]],
             outcomes[[((iter -1) %% 4)+1]])
    )
  })

# rename the files

current_files <- list.files("testing_trends_downloads-current/", full.names=T)
file.rename(current_files, filenames)
