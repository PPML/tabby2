origTabbyUI <- function(id) {
  ns <- NS(id)
  fluidPage(
    includeScript("tabby1/www/js/update-alt-text.js"),
    includeScript("tabby1/www/js/tab-keypress.js"),
    includeScript("tabby1/www/js/add-select-instructions.js"),
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css"),
      tags$style(
        type = "text/css",
        ".main-content { margin-top: 65px; }",
        ".recalculating { opacity: 1.0; }",
        ".nav a { cursor: pointer; }",
        ".tooltip-inner { width: 150px; }"
      )
    ),
    tags$div(
      role = "tabpanel",
    tags$nav(
      class = "navbar-dull navbar navbar-default navbar-fixed-top",
      tags$div(
        class = "container-fluid",
        tags$ul(
          class = "nav navbar-nav navbar-left",
          tags$li(
            role = "presentation",
            class = "active",
            tags$a(
              `data-toggle` = "tab",
              `data-value` = "about",
              `data-target` = ".about-tab",
              role = "tab",
              tabindex = 0,
              tags$span(
                tagAppendAttributes(
                  icon("info-circle"),
                  `aria-hidden` = TRUE
                ),
                "About Tabby"
              )
            )
          ),
          tags$li(
            role = "presentation",
            tags$a(
              `data-toggle` = "tab",
              `data-value` = "definitions",
              `data-target` = ".definitions-tab",
              role = "tab",
              tabindex = 0,
              tags$span(
                tagAppendAttributes(
                  icon("align-left"),
                  `aria-hidden` = TRUE
                ),
                "Definitions"
              )
            )
          ),
          tags$li(
            role = "presentation",
            tags$a(
              `data-toggle` = "tab",
              `data-value` = "faq",
              `data-target` = ".faq-tab",
              role = "tab",
              tabindex = 0,
              tags$span(
                tagAppendAttributes(
                  icon("question-circle"),
                  `aria-hidden` = TRUE
                ),
                "FAQ"
              )
            )
          ),
          tags$li(
            role = "presentation",
            tags$a(
              `data-toggle` = "tab",
              `data-value` = "estimates",
              `data-target` = ".estimates-tab",
              role = "tab",
              tabindex = 0,
              tags$span(
                tagAppendAttributes(
                  icon("line-chart"),
                  `aria-hidden` = TRUE
                ),
                "Estimates"
              )
            )
          ),
          tags$li(
            role = "presentation",
            tags$a(
              `data-toggle` = "tab",
              `data-value` = "trends",
              `data-target` = ".trends-tab",
              role = "tab",
              tabindex = 0,
              tags$span(
                tagAppendAttributes(
                  icon("area-chart"),
                  `aria-hidden` = TRUE
                ),
                "Time trends"
              )
            )
          ),
          tags$li(
            role = "presentation",
            tags$a(
              `data-toggle` = "tab",
              `data-value` = "ages",
              `data-target` = ".agegroups-tab",
              role = "tab",
              tabindex = 0,
              tags$span(
                tagAppendAttributes(
                  icon("bar-chart"),
                  `aria-hidden` = TRUE
                ),
                "Age groups"
              )
            )
          )
        )
      )
    )
    ),
    fluidRow(
      class = "main-content",
      column(
        width = 12,
        class="tab-content",
        descriptionPanel(
          tabclass = "about-tab active",
          content = shiny::includeMarkdown(system.file("about-tabby.md", package = "tabby1utilities", mustWork = TRUE))),
        emptyPanel("definitions-tab"),
        emptyPanel("faq-tab"),
        emptyPanel("estimates-tab"),
        emptyPanel("trends-tab"),
        emptyPanel("agegroups-tab")
      ),
      column(
        width = 12,
        class="tab-content",
        descriptionPanel(
          tabclass = "definitions-tab",
          content = shiny::includeMarkdown(system.file("definitions.md", package = "tabby1utilities", mustWork = TRUE))),
        emptyPanel("about-tab"),
        emptyPanel("faq-tab"),
        emptyPanel("estimates-tab"),
        emptyPanel("trends-tab"),
        emptyPanel("agegroups-tab")
      ),
      column(
        width = 12,
        class="tab-content",
        descriptionPanel(
          tabclass = "faq-tab",
          content = shiny::includeMarkdown(system.file("faq.md", package = "tabby1utilities", mustWork = TRUE))),
        emptyPanel("about-tab"),
        emptyPanel("definitions-tab"),
        emptyPanel("estimates-tab"),
        emptyPanel("trends-tab"),
        emptyPanel("agegroups-tab")
      ),
      column(
        width = 4,
        class = "tab-content",
        emptyPanel("about-tab"),
        emptyPanel("definitions-tab"),
      emptyPanel("faq-tab"),
      estimatesControlPanel(ns),
      trendsControlPanel(ns),
      agegroupsControlPanel(ns)
    ),
    column(
      width = 8,
      class = "tab-content",
      emptyPanel("about-tab"),
      emptyPanel("definitions-tab"),
      emptyPanel("faq-tab"),
      estimatesVisualizationPanel(ns),
      trendsVisualizationPanel(ns),
      agegroupsVisualizationPanel(ns)
    )
  )
)
}