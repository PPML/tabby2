#' Construct an Empty Panel where Content Used to Be
#'
#' This function is used in the ui.R to replace tab-content with
#' empty content so that when the user clicks on different tabs
#' the content is swapped out properly.
emptyPanel <- function(tabclass) {
  tags$div(
    class = paste(tabclass, "tab-pane")
  )
}

#' Construct a Description Panel from Content intended for a Navbar Tab
#'
#' The tabclass will be appended with " tab-pane", so for example to construct
#' the about-tab which is the first to display to the user we would use
#' tabclass = "about-tab active".
descriptionPanel <- function(tabclass, content) {
  tags$div(
    class=paste(tabclass, " tab-pane"),
    content
  )
}
