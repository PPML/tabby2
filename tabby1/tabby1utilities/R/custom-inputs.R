radioButtons2 <- function(id, heading, labels, values, selected, ...,
                          descriptions = NULL) {
  if (is.null(descriptions)) {
    descriptions <- rep.int("", length(labels))
  }

  tags$section(
    `aria-label` = heading,
    tags$label(
      class = "control-label",
      `for` = id,
      tabindex = 0,
      heading,
      tags$span(
        class = "sr-only",
        paste0("Select the ", heading, " by tabbing through the inputs below and using enter to make your selection.")
      )
    ),
    tags$div(
      id = id,
      class = "shiny-input-radiogroup shiny-input-container",
      role = "radiogroup",
      `aria-labelledby` = id,
      tags$div(
        class = "shiny-options-group",
        Map(
          label = labels,
          value = values,
          this = paste0(id, "-", seq_along(labels)),
          select = selected,
          desc = descriptions,
          d_id = paste0(id, "Outcome-", seq_along(descriptions)),
          function(label, value, this, select, desc, d_id) {
            tags$div(
              class = "radio",
              role = "radio",
              `aria-checked` = if (select) "true" else "false",
              tabindex='0',
              tags$label(
                `for` = this,
                `aria-checked` = if (select) "true" else "false",
                tags$input(
                  type = "radio",
                  name = id,
                  id = this,
                  value = value,
                  checked = if (select) NA,
                  tabindex='-1',
                  `aria-checked` = if (select) "true" else "false",
                  `aria-describedby` = paste(this, "label", sep="-")
                ),
                tags$span(
                  class = paste(this, "label", sep="-"),
                  label
                )
              )
            )
          }
        )
      )
    )
  )
}

checkboxGroup2 <- function(id, heading, labels, values, selected = FALSE, descriptions = NULL) {
  if (is.null(descriptions)) {
    descriptions <- rep.int("", length(labels))
  }
  tags$section(
    id = id,
    class = "shiny-options-group shiny-input-checkboxgroup shiny-input-container",
    `aria-label` = heading,
    tags$label(
      class = "control-label",
      `for` = id,
      tabindex = 0,
      heading,
      tags$span(
        class = "sr-only",
        paste0("Select the ", heading, " by tabbing through the checkboxes below and using enter to make your selection.")
      )
    ),
    tags$div(
      Map(
        label = labels,
        value = values,
        select = selected,
        this = paste0(id, "-", seq_along(labels)),
        desc = descriptions,
        d_id = paste0(id, "Description-", seq_along(descriptions)),
        function(label, value, select, this, desc, d_id) {
          result <- tags$div(
            class = "checkbox",
            role = "checkboxgroup",
            tabindex='0',
            tags$label(
              `for` = this,
              tags$input(
                type = "checkbox",
                tabindex='-1',
                `aria-checked` = tolower(as.character(select)),
                value = value,
                name = id,
                id = this,
                `aria-describedby` = paste(this, "label", sep="-"),
                tags$span(
                  class = paste(this, "label", sep="-"),
                  label)
              )
            )
          )
          if (select) result$children[[length(result$children)]]$children[[1]] <- shiny::tagAppendAttributes(result$children[[length(result$children)]]$children[[1]] , checked = "checked")
          return(result)
        }
      )
    )
  )
}

downloadButtonBar <- function(ids, heading, labels) {
  descriptions <- paste(
    "This link acts like a button. Click this link or press the enter key to download",
    c(
      "the visualization as a PNG file.",
      "the visualization as a PDF file.",
      "the visualization as a Power Point file.",
      "the data used in the visualization as CSV file.",
      "the data used in the visualization as an Excel file."
    )
  )

  tags$div(
    tags$label(
      class = "control-label",
      heading
    ),
    tags$div(
      tags$div(
        class = "btn-group",
        role = "group",
        Map(
          id = ids,
          label = labels,
          desc = descriptions,
          d_id = paste0(ids, "Description"),
          function(id, label, desc, d_id) {
            tags$a(
              id = id,
              class = "btn btn-default shiny-download-link",
              href = "",
              target = "_blank",
              download = NA,
              `aria-describedby` = d_id,
              tabindex = 0,
              label,
              tags$span(
                class = "sr-only",
                id = d_id,
                `aria-hidden` = TRUE,
                desc
              )
            )
          }
        )
      )
    )
  )
}
