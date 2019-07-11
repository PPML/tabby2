tabby1Server <- function(input, output, session, ns, sim_data, geo_short_code, geographies) {

  # (to use these headings press COMMAND+SHIFT+O)
  # data server ----
	AGEGROUPS_DATA <- reactive({ sim_data()[['AGEGROUPS_DATA']] })
	ESTIMATES_DATA <- reactive({ sim_data()[['ESTIMATES_DATA']] })
	TRENDS_DATA <- reactive({ sim_data()[['TRENDS_DATA']] })


	# user_filtered_data <- reactiveValues()

  # estimates server ----
  # __calculate data ----
  estimatesData <- reactive({
    req(
      input[[estimates$IDs$controls$comparators]], input[[estimates$IDs$controls$outcomes]],
      c(input[[estimates$IDs$controls$interventions]], input[[estimates$IDs$controls$analyses]], 'base_case')
    )

    ESTIMATES_DATA() %>%
      filter(
        population == input[[estimates$IDs$controls$populations]],
        age_group == input[[estimates$IDs$controls$ages]],
        outcome == input[[estimates$IDs$controls$outcomes]],
				scenario %in% 
				  c(input[[estimates$IDs$controls$interventions]],
						input[[estimates$IDs$controls$analyses]], 
						"base_case", 
				    'programChange0', 
						'programChange1', 
						'programChange2', 
						'programChange3'),
        comparator == input[[estimates$IDs$controls$comparators]]
      ) %>%
      arrange(scenario) %>%
      mutate(
        year = recode(as.character(year), '2018'=2000, '2020'=2025, '2025'=2050, '2035'=2075, '2049'=2100),
        year_adj = year + position_year(scenario)
      )
  })

	# user_filtered_data[['estimatesData()']] <- estimatesData()

  # __generate point labels ----
  estimatesLabels <- reactive({
    padding_x <- 5

    label_df <- estimatesData() %>%
      group_by(year) %>%
      mutate(
        nudge_x = ifelse(
          mean(year_adj) < year_adj,
          max(year_adj) - year_adj + padding_x,
          min(year_adj) - year_adj - padding_x
        )
      ) %>%
      ungroup()

    labels <- input[[estimates$IDs$controls$labels]]

    if (labels == "none") {
      return(NULL)
    }

    if (labels == "means") {
      label_df <- filter(label_df, type == "mean")
    } else if (labels == "intervals") {
      label_df <- filter(label_df, type == "ci_high" | type == "ci_low")
    }

    label_df <- select(label_df, scenario, year, year_adj, value, starts_with("nudge"))

    geom_label_repel(
      mapping = aes(
        x = year_adj,
        y = value,
        color = scenario,
        label = signif(value, 3)
      ),
      data = label_df,
      # fill = "transparent",
      fontface = "bold",
      size = 4,
      box.padding = unit(0.20, "lines"),
      point.padding = unit(0.75, "lines"),
      force = 1.0,
      show.legend = FALSE,
      nudge_x = label_df$nudge_x,
      min.segment.length = unit(0.25, "lines")
    )
  })

  # __set title ----
  estimatesTitle <- reactive({
    req(
      input[[estimates$IDs$controls$outcome]],
      input[[estimates$IDs$controls$population]],
      input[[estimates$IDs$controls$ages]]
    )

    sprintf(
      "Projected %s in the %s, %s in %s",
      estimates$outcomes$labels[[input[[estimates$IDs$controls$outcomes]]]],
      estimates$populations$formatted[[input[[estimates$IDs$controls$populations]]]],
      estimates$ages$formatted[[input[[estimates$IDs$controls$ages]]]],
			if (geo_short_code() == 'US') 'the US' else unname(geographies[geo_short_code()])
    )
  })

  output[[estimates$IDs$title]] <- reactive({
    title <- estimatesTitle()

    session$sendCustomMessage("tabby:altupdate", list(
      selector = paste0("#", estimates$IDs$plot),
      alt = title
    ))

    title
  })

  # __set subtitle ----
  output[[estimates$IDs$subtitle]] <- reactive({
    req(
      input[[estimates$IDs$controls$comparators]],
      input[[estimates$IDs$controls$outcomes]],
      input[[estimates$IDs$controls$populations]],
      input[[estimates$IDs$controls$ages]]
    )

    estimates$comparators$formatted[[input[[estimates$IDs$controls$comparators]]]]
  })

  # __generate plot ----
  estimatesPlot <- reactive({

    data <- spread(estimatesData(), type, value)

    title <- estimatesTitle()

    ggplot(data) +
      geom_rect(
        data = as.data.frame(plots$region),
        mapping = aes(
          xmin = right_bound,
          xmax = left_bound,
          ymin = bottom_bound,
          ymax = top_bound
        ),
        fill = "#F5F5F5"
      ) +
      geom_pointrange(
        mapping = aes(
          year_adj, mean,
          ymin = ci_low, ymax = ci_high,
          color = scenario,
          shape = scenario,
          fill = scenario
        ),
        size = 0.5,
        fatten = 8
      ) +
      estimatesLabels() +
      scale_color_manual(
        name = "Scenario",
        values = plots$colors,
        labels = plots$labels
      ) +
      scale_fill_manual(
        name = "Scenario",
        values = plots$fills,
        labels = plots$labels
      ) +
      scale_shape_manual(
        name = "Scenario",
        values = plots$shapes,
        labels = plots$labels
      ) +
      scale_x_continuous(
        name = "Year",
        breaks = plots$region$year,
        labels = c("2018", "2020", "2025", "2035", "2050"),
        limits = range(plots$region$right_bound, plots$region$left_bound),
        expand = c(0, 0)
      ) +
      scale_y_continuous(
        name = estimates$outcomes$formatted[[input[[estimates$IDs$controls$outcomes]]]]
      ) +
      labs(
        title = title,
        subtitle = estimates$comparators$formatted[[input[[estimates$IDs$controls$comparators]]]]
      ) +
      guides(
        color = guide_legend(ncol = 4)
      ) +
      theme_bw() +
      theme(
        text = element_text(size = 14),
        plot.title = element_text(
          size = rel(1.5),
          margin = margin(0, 0, 10 , 0)
        ),
        plot.subtitle = element_text(
          size = rel(1.25),
          margin = margin(0, 0, 10, 0)
        ),
        axis.title = element_text(size = rel(1.15)),
        axis.title.x = element_text(margin = margin(t = 20)),
        axis.title.y = element_text(margin = margin(r = 20)),
        axis.text = element_text(size = rel(1)),
        axis.ticks = element_blank(),
        legend.position = "bottom",
        legend.justification = c(0, 0),
        legend.text = element_text(size = rel(0.85)),
        legend.title = element_text(size = rel(1.15)),
        legend.key.size = unit(1, "cm"),
        legend.box.spacing = unit(8, "mm"),
        panel.background = element_blank(),
        panel.grid = element_blank(),
        panel.border = element_blank(),
        panel.ontop = TRUE
      ) +
      expand_limits(y=0) + 
		  annotate("text", x = Inf, y = -Inf, label = "DRAFT",
				hjust=1.1, vjust=-1.1, col="dimgrey", cex=28,
				fontface = "bold", alpha = 0.8)
  })


  output[[estimates$IDs$plot]] <- renderPlot({
    estimatesPlot() +
      theme(
        plot.title = element_blank(),
        plot.subtitle = element_blank()
      )
  })


  # trends server ----
  # __calculate data ----
  trendsData <- reactive({
    req(
      input[[trends$IDs$controls$comparators]],
      input[[trends$IDs$controls$outcomes]],
      c(
        input[[trends$IDs$controls$interventions]],
        input[[trends$IDs$controls$analyses]],
        "base_case"
      )
    )

    TRENDS_DATA() %>%
      filter(
        population == input[[trends$IDs$controls$populations]],
        age_group == input[[trends$IDs$controls$ages]],
        outcome == input[[trends$IDs$controls$outcomes]],
        scenario %in% c(
          input[[trends$IDs$controls$interventions]],
          input[[trends$IDs$controls$analyses]],
          "base_case",
					"programChange0",
					"programChange1",
					"programChange2",
					"programChange3"
        ),
        comparator == input[[trends$IDs$controls$comparators]]
      ) %>%
      arrange(scenario) %>%
      mutate(
        year_adj = year + position_year(scenario)
      )
  })

	# user_filtered_data[['trendsData()']] <- trendsData()

  # __set title ----
  trendsTitle <- reactive({
    req(
      input[[trends$IDs$controls$outcomes]],
      input[[trends$IDs$controls$populations]],
      input[[trends$IDs$controls$ages]]
    )

    sprintf(
      "Projected %s in the %s, %s in %s",
      trends$outcomes$labels[[input[[trends$IDs$controls$outcomes]]]],
      trends$populations$formatted[[input[[trends$IDs$controls$populations]]]],
      trends$ages$formatted[[input[[trends$IDs$controls$ages]]]],
			if (geo_short_code() == 'US') 'the US' else unname(geographies[geo_short_code()])
    )
  })

  output[[trends$IDs$title]] <- reactive({
    title <- trendsTitle()

    session$sendCustomMessage("tabby:altupdate", list(
      selector = paste0("#", trends$IDs$plot),
      alt = title
    ))

    title
  })

  # __set subtitle ----
  output[[trends$IDs$subtitle]] <- reactive({
    req(
      input[[trends$IDs$controls$outcomes]],
      input[[trends$IDs$controls$populations]],
      input[[trends$IDs$controls$ages]]
    )

    trends$comparators$formatted[[input[[trends$IDs$controls$comparators]]]]
  })

  # __generate plot ----
  trendsPlot <- reactive({

    data <- spread(trendsData(), type, value)

    title <- trendsTitle()
    guide <- guide_legend(
      title = "Scenario",
      nrow = min(n_distinct(data$scenario), 2)
    )

    p <- ggplot(data) +
      geom_line(
        mapping = aes(
          x = year,
          y = mean,
          color = scenario,
          linetype = scenario
        ),
        size = 1.05,
        linejoin = "round"
      ) +
      scale_fill_manual(
        name = "Scenario",
        values = plots$colors,
        labels = plots$labels
      ) +
      scale_color_manual(
        name = "Scenario",
        values = plots$colors,
        labels = plots$labels
      ) +
      scale_linetype_manual(
        name = "Scenario",
        values = plots$linetypes,
        labels = plots$labels
      ) +
      scale_x_continuous(
        name = "Year",
        breaks = if (geo_short_code() == 'US') c(2018, 2025, 2050, 2075, 2100) else c(2018, 2020, 2025, 2035, 2050)
      ) +
      scale_y_continuous(
        name = trends$outcomes$formatted[[input[[trends$IDs$controls$outcomes]]]]
      ) +
      labs(
        title = title,
        subtitle = trends$comparators$formatted[[input[[trends$IDs$controls$comparators]]]]
      ) +
      guides(
        color = guide
      ) +
      theme_bw() +
      theme(
        text = element_text(size = 14),
        plot.title = element_text(
          size = rel(1.5),
          margin = margin(0, 0, 10 , 0)
        ),
        plot.subtitle = element_text(
          size = rel(1.25),
          margin = margin(0, 0, 10, 0)
        ),
        axis.title = element_text(size = rel(1.15)),
        axis.title.x = element_text(margin = margin(t = 20)),
        axis.title.y = element_text(margin = margin(r = 20)),
        axis.text = element_text(size = rel(1)),
        legend.position = "bottom",
        legend.direction = "horizontal",
        legend.justification = c(0, 0),
        legend.text = element_text(size = rel(0.85)),
        legend.title = element_text(size = rel(1.15)),
        legend.key = element_rect(size = 2),
        legend.key.size = unit(2, "lines"), #unit(0.75, "cm"),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(size = 0.15, color = "#989898")
      ) +
      expand_limits(y=0) + 
		  annotate("text", x = Inf, y = -Inf, label = "DRAFT",
				hjust=1.1, vjust=-1.1, col="dimgrey", cex=28,
				fontface = "bold", alpha = 0.8)

    if(input[['trendsUncertaintyInterval-1']]) {
      p <- p +
        geom_ribbon(
          mapping = aes(
            x = year,
            ymin = ci_low,
            ymax = ci_high,
            fill = scenario
          ),
          alpha = 0.3
        )
    }

    return(p)
  })

  output[[trends$IDs$plot]] <- renderPlot({
    trendsPlot() +
      theme(
        plot.title = element_blank(),
        plot.subtitle = element_blank()
      )
  })


  # ages server ----
  # __calculate data ----
  agegroupsData <- reactive({
    req(
      input[[agegroups$IDs$controls$populations]],
      input[[agegroups$IDs$controls$outcomes]],
      c(
        input[[agegroups$IDs$controls$populations]],
        input[[agegroups$IDs$controls$analyses]],
        "base_case"
      ),
      input[[agegroups$IDs$controls$years]] >= 2016 &&
        input[[agegroups$IDs$controls$years]] <= 2100
    )
    
    AGEGROUPS_DATA() %>%
      filter(
        population == input[[agegroups$IDs$controls$populations]],
        outcome == input[[agegroups$IDs$controls$outcomes]],
        year == if (input[[agegroups$IDs$controls$years]] == 2100) 2099 else
          input[[agegroups$IDs$controls$years]],
        scenario %in% c(
          input[[agegroups$IDs$controls$interventions]],
          input[[agegroups$IDs$controls$analyses]],
          "base_case",
					'programChange0',
					'programChange1',
					'programChange2',
					'programChange3'
        ),
        comparator == 'absolute_value'
      )
  })

	# user_filtered_data[['agegroupsData()']] <- agegroupsData()

  # __set title ----
  agegroupsTitle <- reactive({
    req(
      input[[agegroups$IDs$controls$populations]],
      input[[agegroups$IDs$controls$outcomes]],
      input[[agegroups$IDs$controls$years]] >= 2016 &&
        input[[agegroups$IDs$controls$years]] <= 2100
    )

    sprintf(
      "Projected %s in the %s, for %s in %s",
      agegroups$outcomes$labels[[input[[agegroups$IDs$controls$outcomes]]]],
      agegroups$populations$formatted[[input[[agegroups$IDs$controls$populations]]]],
      input[[agegroups$IDs$controls$years]],
			if (geo_short_code() == 'US') 'the US' else unname(geographies[geo_short_code()])
    )
  })

  output[[agegroups$IDs$title]] <- reactive({
    title <- agegroupsTitle()

    session$sendCustomMessage("tabby:altupdate", list(
      selector = paste0("#", agegroups$IDs$plot),
      alt = title
    ))

    title
  })

  # __generate plot ----
  agegroupsPlot <- reactive({

    data <- spread(agegroupsData(), type, value)

    title <- agegroupsTitle()

    dodge <- position_dodge(0.85)

    ggplot(data, aes(x = age_group)) +
      geom_pointrange(
        mapping = aes(
          y = mean,
          ymin = data$ci_low,
          ymax = data$ci_high,
          color = scenario,
          shape = scenario,
          fill = scenario
        ),
        size = .5,
        fatten = 8,
        position = dodge
      ) +
      scale_x_discrete(
        name = "Age group",
        limits = naturalsort(unique(data$age_group))
      ) +
      scale_y_continuous(
        name = agegroups$outcomes$formatted[[input[[agegroups$IDs$controls$outcomes]]]]
      ) +
      scale_fill_manual(
        name = "Scenario",
        values = plots$fills,
        labels = plots$labels
      ) +
      scale_color_manual(
        name = "Scenario",
        values = plots$colors, # darken(plots$colors, 1.75),
        labels = plots$labels
      ) +
      scale_shape_manual(
        name = "Scenario",
        values = plots$shapes,
        labels = plots$labels
      ) +
      labs(
        title = title
      ) +
      guides(
        fill = guide_legend(
          title = "Scenario",
          nrow = min(n_distinct(data$scenario), 2)
        )
      ) +
      theme_bw() +
      theme(
        text = element_text(size = 14),
        plot.title = element_text(
          size = rel(1.5),
          margin = margin(0, 0, 10 , 0)
        ),
        plot.subtitle = element_text(
          size = rel(1.25),
          margin = margin(0, 0, 10, 0)
        ),
        axis.title = element_text(size = rel(1.15)),
        axis.title.x = element_text(margin = margin(t = 20)),
        axis.title.y = element_text(margin = margin(r = 20)),
        axis.text = element_text(size = rel(1)),
        legend.position = "bottom",
        legend.direction = "horizontal",
        legend.justification = c(0, 0),
        legend.text = element_text(size = rel(0.85)),
        legend.title = element_text(size = rel(1.15)),
        legend.key = element_rect(size = 2),
        legend.key.size = unit(2, "lines"), #unit(0.75, "cm"),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(size = 0.15, color = "#989898"),
        strip.background = element_blank(),
        strip.text = element_blank()
      ) +
      expand_limits(y=0) + 
		  annotate("text", x = Inf, y = -Inf, label = "DRAFT",
				hjust=1.1, vjust=-1.1, col="dimgrey", cex=28,
				fontface = "bold", alpha = 0.8)
  })

  output[[agegroups$IDs$plot]] <- renderPlot({
    agegroupsPlot() +
      theme(
        plot.title = element_blank()
      )
  })

  # downloads ----
  # __estimates png ----
  output[[estimates$IDs$downloads$png]] <- downloadHandler(
    filename = "tabby-estimates-plot.png",
    content = function(file) {
      png(file, res = 72, width = 13, height = 9, units = "in")
      print(estimatesPlot())
      dev.off()
    }
  )

  # __estimates pdf ----
  output[[estimates$IDs$downloads$pdf]] <- downloadHandler(
    filename = "tabby-estimates-plot.pdf",
    content = function(file) {
      this <- estimatesPlot()

      pdf(file, width = 11, height = 8, title = this$plot$title)
      print(this)
      dev.off()
    }
  )

  # __estimates pptx ----
  output[[estimates$IDs$downloads$pptx]] <- downloadHandler(
    filename = "tabby-estimates-plot.pptx",
    content = function(file) {
      tmp <- tempfile(fileext = "jpg")
      on.exit(unlink(tmp))

      this <- try(estimatesPlot(), silent = TRUE)

      jpeg(tmp, res = 72, width = 13, height = 9, units = "in")

      if (is.ggplot(this)) {
        print(this)
      }

      dev.off()

      read_pptx() %>%
        add_slide(layout = "Title and Content", master = "Office Theme") %>%
        ph_with_text(type = "title", str = "") %>%
        ph_with_img(type = "body", src = tmp, width = 7, height = 5) %>%
        print(target = file)
    }
  )

  # __estimates xlsx ----
  output[[estimates$IDs$downloads$xlsx]] <- downloadHandler(
    filename = "tabby-estimates-data.xlsx",
    content = function(file) {
      estimatesData() %>%
        mutate(
          year = ifelse(year == 2000, 2016, year)
        ) %>%
        spread(type, value) %>%
        mutate(scenario = sapply(scenario, function(x) c(estimates$interventions$labels, estimates$analyses$labels, c(base_case = "Base Case"))[[x]])) %>%
        mutate(outcome = sapply(outcome, function(x) estimates$outcomes$labels[[x]])) %>%
        select(
          outcome, scenario, age_group, year, mean, ci_high, ci_low
        ) %>%
        openxlsx::write.xlsx(
          file = file,
          colNames = TRUE
        )
    }
  )

  # __estimates csv ----
  output[[estimates$IDs$downloads$csv]] <- downloadHandler(
    filename = "tabby-estimates-data.csv",
    content = function(file) {
      estimatesData() %>%
        mutate(
          year = ifelse(year == 2000, 2016, year)
        ) %>%
        spread(type, value) %>%
        mutate(scenario = sapply(scenario, function(x) c(estimates$interventions$labels, estimates$analyses$labels, c(base_case = "Base Case"))[[x]])) %>%
        mutate(outcome = sapply(outcome, function(x) estimates$outcomes$labels[[x]])) %>%
        select(
          outcome, scenario, age_group, year, mean, ci_high, ci_low
        ) %>%
        write.csv(
          file = file,
          row.names = FALSE
        )
    }
  )

  # __trends png ----
  output[[trends$IDs$downloads$png]] <- downloadHandler(
    filename = "tabby-trends-plot.png",
    content = function(file) {
      png(file, res = 72, width = 13, height = 9, units = "in")
      print(trendsPlot())
      dev.off()
    }
  )

  # __trends pdf ----
  output[[trends$IDs$downloads$pdf]] <- downloadHandler(
    filename = "tabby-trends-plot.pdf",
    content = function(file) {
      this <- trendsPlot()
      pdf(file, width = 11, height = 8, title = this$plot$title)
      print(this)
      dev.off()
    }
  )

  # __trends pptx ----
  output[[trends$IDs$downloads$pptx]] <- downloadHandler(
    filename = "tabby-trends-plot.pptx",
    content = function(file) {
      tmp <- tempfile(fileext = "jpg")
      on.exit(unlink(tmp))

      this <- try(trendsPlot(), silent = TRUE)

      jpeg(tmp, res = 72, width = 13, height = 9, units = "in")

      if (is.ggplot(this)) {
        print(this)
      }

      dev.off()

      read_pptx() %>%
        add_slide(layout = "Title and Content", master = "Office Theme") %>%
        ph_with_text(type = "title", str = "") %>%
        ph_with_img(type = "body", src = tmp, width = 7, height = 5) %>%
        print(target = file)
    }
  )

  # __trends xlsx ----
  output[[trends$IDs$downloads$xlsx]] <- downloadHandler(
    filename = "tabby-trends-data.xlsx",
    content = function(file) {
      trendsData() %>%
        mutate(
          year = ifelse(year == 2000, 2016, year)
        ) %>%
        spread(type, value) %>%
        mutate(scenario = sapply(scenario, function(x) c(trends$interventions$labels, trends$analyses$labels, c(base_case = "Base Case"))[[x]])) %>%
        mutate(outcome = sapply(outcome, function(x) trends$outcomes$labels[[x]])) %>%
        select(
          outcome, scenario, age_group, year, mean, ci_high, ci_low
        ) %>%
        openxlsx::write.xlsx(
          file = file,
          colNames = TRUE
        )
    }
  )

  # __trends csv ----
  output[[trends$IDs$downloads$csv]] <- downloadHandler(
    filename = "tabby-trends-data.csv",
    content = function(file) {
      trendsData() %>%
        mutate(
          year = ifelse(year == 2000, 2016, year)
        ) %>%
        spread(type, value) %>%
        mutate(scenario = sapply(scenario, function(x) c(trends$interventions$labels, trends$analyses$labels, c(base_case = "Base Case"))[[x]])) %>%
        mutate(outcome = sapply(outcome, function(x) trends$outcomes$labels[[x]])) %>%
        select(
          outcome, scenario, age_group, year, mean, ci_high, ci_low
        ) %>%
        write.csv(
          file = file,
          row.names = FALSE
        )
    }
  )

  # __agegroups png ----
  output[[agegroups$IDs$downloads$png]] <- downloadHandler(
    filename = "tabby-agegroups-plot.png",
    content = function(file) {
      png(file, res = 72, width = 13, height = 9, units = "in")
      print(agegroupsPlot())
      dev.off()
    }
  )

  # __agegroups pdf ----
  output[[agegroups$IDs$downloads$pdf]] <- downloadHandler(
    filename = "tabby-agegroups-plot.pdf",
    content = function(file) {
      this <- agegroupsPlot()
      pdf(file, width = 11, height = 8, title = this$plot$title)
      print(this)
      dev.off()
    }
  )

  # __agegroups pptx ----
  output[[agegroups$IDs$downloads$pptx]] <- downloadHandler(
    filename = "tabby-agegroups-plot.pptx",
    content = function(file) {
      tmp <- tempfile(fileext = "jpg")
      on.exit(unlink(tmp))

      this <- try(agegroupsPlot(), silent = TRUE)

      jpeg(tmp, res = 72, width = 13, height = 9, units = "in")

      if (is.ggplot(this)) {
        print(this)
      }

      dev.off()

      read_pptx() %>%
        add_slide(layout = "Title and Content", master = "Office Theme") %>%
        ph_with_text(type = "title", str = "") %>%
        ph_with_img(type = "body", src = tmp, width = 7, height = 5) %>%
        print(target = file)
    }
  )

  # __agegroups xlsx ----
  output[[agegroups$IDs$downloads$xlsx]] <- downloadHandler(
    filename = "tabby-agegroups-data.xlsx",
    content = function(file) {
      agegroupsData() %>%
        mutate(
          year = ifelse(year == 2000, 2016, year)
        ) %>%
        mutate(
          agegroup_start = as.numeric(sapply(strsplit(age_group, split="[-+]"), `[[`, 1))
        ) %>%
        spread(type, value) %>%
        mutate(scenario = sapply(scenario, function(x) c(agegroups$interventions$labels, agegroups$analyses$labels, c(base_case = "Base Case"))[[x]])) %>%
        mutate(outcome = sapply(outcome, function(x) agegroups$outcomes$labels[[x]])) %>%
        arrange(agegroup_start) %>%
        select(
          outcome, scenario, age_group, year, mean, ci_high, ci_low
        ) %>%
        openxlsx::write.xlsx(
          file = file,
          colNames = TRUE
        )
    }
  )

  # __agegroups csv ----
  output[[agegroups$IDs$downloads$csv]] <- downloadHandler(
    filename = "tabby-agegroups-data.csv",
    content = function(file) {
      agegroupsData() %>%
        mutate(
          year = ifelse(year == 2000, 2016, year)
        ) %>%
        mutate(
          agegroup_start = as.numeric(sapply(strsplit(age_group, split="[-+]"), `[[`, 1))
        ) %>%
        spread(type, value) %>%
        mutate(scenario = sapply(scenario, function(x) c(agegroups$interventions$labels, agegroups$analyses$labels, c(base_case = "Base Case"))[[x]])) %>%
        mutate(outcome = sapply(outcome, function(x) agegroups$outcomes$labels[[x]])) %>%
        arrange(agegroup_start) %>%
        select(
          outcome, scenario, age_group, year, mean, ci_high, ci_low
        ) %>%
        write.csv(
          file = file,
          row.names = FALSE
        )
    }
  )

  filtered_data <- list(estimatesData = estimatesData, trendsData = trendsData, agegroupsData = agegroupsData)
  return(filtered_data)
}
