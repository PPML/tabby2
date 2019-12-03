app <- ShinyDriver$new("../")
app$snapshotInit("testing trends downloads")


geographies <- c("United States", "California", "Florida", "Georgia",
                 "Illinois", "Massachusetts", "New Jersey", "New York",
                 "Pennsylvania", "Texas", "Virginia", "Washington") 

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
  app$setInputs(`tabby1-trendsOutcomes` = "tb_deaths_per_100k")
  app$snapshotDownload("tabby1-trendsCSV")
}

filenames <- rep(geographies, each=4)
outcomes <- c("_incident_infections.csv",
              "_ltbi.csv",
              "_tb_incidence.csv",
              "_tb_deaths.csv")

filenames <- sapply(1:length(filenames), function(iter) {
    file.path("testing trends downloads-current/", 
      paste0(filenames[[iter]],
             outcomes[[((iter -1) %% 4)+1]])
    )
  })

current_files <- list.files("testing trends downloads-current/", full.names=T)

file.rename(current_files, filenames)
