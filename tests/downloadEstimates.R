#!/bin/Rscript

# When this shiny test is run: 
# 
# - a headless browser launches running shiny 
# - selects each geography
# - downloads estimates data for all interventions measured as percent basecase 2018
# - each of the downloads are renamed to reflect what data they contain

library(shinytest)

# before we run the shinytest which downloads the Estimates data, 
# we need to delete the data that's in the test's download folder

current_files <- list.files("downloadEstimates-current/", full.names=T)
file.remove(current_files)


# start a new headless browser running Tabby2

app <- ShinyDriver$new("../")

# name the test so that the data downloaded goes into downloadEstimates-current

app$snapshotInit("downloadEstimates")

# these are the geographies downloaded in this test -- this needs to be updated
# as more are included for the paper

geographies <- c("United States", "California", "Florida", "Georgia",
                 "Illinois", "Massachusetts", "New Jersey", "New York",
                 "Pennsylvania", "Texas", "Virginia", "Washington") 

# select each location, then go to the estimates and turn on all the 
# intervention scenarios. 
#
# save each of the outcomes available in the estimates page
# 

for (location in geographies) {

  app$setInputs(state = location)
  app$setInputs(sidebar = "estimates")
  app$setInputs(`tabby1-estimatesInterventions-1` = TRUE)
  app$setInputs(`tabby1-estimatesInterventions` = "intervention_1")
  app$setInputs(`tabby1-estimatesInterventions-2` = TRUE)
  app$setInputs(`tabby1-estimatesInterventions` = c("intervention_1", "intervention_2"))
  app$setInputs(`tabby1-estimatesInterventions-3` = TRUE)
  app$setInputs(`tabby1-estimatesInterventions` = c("intervention_1", "intervention_2", "intervention_3"))
  app$setInputs(`tabby1-estimatesInterventions-5` = TRUE)
  app$setInputs(`tabby1-estimatesInterventions` = c("intervention_1", "intervention_2", "intervention_3", "intervention_5"))
  app$setInputs(`tabby1-estimatesInterventions-4` = TRUE)
  app$setInputs(`tabby1-estimatesInterventions` = c("intervention_1", "intervention_2", "intervention_3", "intervention_4", "intervention_5"))
  app$setInputs(`tabby1-estimatesComparator` = "pct_basecase_2018")
  app$setInputs(`tabby1-estimatesOutcomes` = "tb_incidence_per_100k")
  app$snapshotDownload("tabby1-estimatesCSV")
  app$setInputs(`tabby1-estimatesOutcomes` = "tb_infection_per_100k")
  app$snapshotDownload("tabby1-estimatesCSV")
  app$setInputs(`tabby1-estimatesOutcomes` = "pct_ltbi")
  app$snapshotDownload("tabby1-estimatesCSV")
  app$setInputs(`tabby1-estimatesOutcomes` = "tb_deaths_per_100k")
  app$snapshotDownload("tabby1-estimatesCSV")

}

# the downloads' filenames are unfortunately overwritten by whatever 
# shinytest does to put them in the downloadEstimates-current/ folder.
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
outcomes <- c("_tb_incidence.csv",
              "_ltbi.csv",
              "_incident_infections.csv",
              "_tb_deaths.csv")

# filenames are constructed using the filenames and 
# outcomes lists

filenames <- sapply(1:length(filenames), function(iter) {
    file.path("downloadEstimates-current/", 
      paste0(filenames[[iter]],
             outcomes[[((iter -1) %% 4)+1]])
    )
  })


# rename the files

current_files <- list.files("downloadEstimates-current/", full.names=T)
file.rename(current_files, filenames)
