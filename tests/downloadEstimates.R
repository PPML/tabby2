app <- ShinyDriver$new("../")
app$snapshotInit("downloadEstimates")

geographies <- c("United States", "California", "Florida", "Georgia",
                 "Illinois", "Massachusetts", "New Jersey", "New York",
                 "Pennsylvania", "Texas", "Virginia", "Washington") 

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


filenames <- rep(geographies, each=4)
outcomes <- c("_tb_incidence.csv",
              "_ltbi.csv",
              "_incident_infections.csv",
              "_tb_deaths.csv")


filenames <- sapply(1:length(filenames), function(iter) {
    file.path("downloadEstimates-current/", 
      paste0(filenames[[iter]],
             outcomes[[((iter -1) %% 4)+1]])
    )
  })

current_files <- list.files("downloadEstimates-current/", full.names=T)

file.rename(current_files, filenames)
