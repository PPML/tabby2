tabby1Server <- function(input, output, session, ns, sim_data, cost_data, geo_short_code, geographies) {
#cost_data, 
  # (to use these headings press COMMAND+SHIFT+O)
  # data server ----
	AGEGROUPS_DATA <- reactive({ sim_data()[['AGEGROUPS_DATA']] })
	ESTIMATES_DATA <- reactive({ sim_data()[['ESTIMATES_DATA']] })
	TRENDS_DATA <- reactive({ sim_data()[['TRENDS_DATA']] })
  ADDOUTPUTS_DATA <-  reactive({ sim_data()[['ADDOUTPUTS_DATA']] })
  COSTCOMPARISON_DATA <-  reactive({ sim_data()[['COSTCOMPARISON_DATA']] })
  EFFECTS_DATA <-  reactive({ cost_data()[['EFFECTS_DATA']] })
  COSTS_DATA <-  reactive({ cost_data()[['COSTS_DATA']] })
  COSTEFF_ICER_DATA <-  reactive({ cost_data()[['COSTEFF_ICER_DATA']] })
  COSTEFF_ACER_DATA <-  reactive({ cost_data()[['COSTEFF_ACER_DATA']] })
  
  
  
  # The session info is used to title the downloads with the tabby2 version
  # number. 
  session_info <- sessionInfo()

  # format the version number to be included in filenames to use underscores.
  version_number <- gsub("\\.", "_", session_info[['otherPkgs']][['utilities']][['Version']])

  # We will also include the sys_date in all download names
  sys_date <- Sys.Date()

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
        outcome  == input[[estimates$IDs$controls$outcomes]],
				scenario %in% 
				  c(input[[estimates$IDs$controls$interventions]],
						input[[estimates$IDs$controls$analyses]], 
						"base_case" 
						),
        comparator == input[[estimates$IDs$controls$comparators]]
      ) %>%
      arrange(scenario) %>%
      mutate(
        value = signif(value, 3)
      ) %>% 
      mutate(scenario = relevel(as.factor(scenario), 'base_case'))

  })

  estimatesDataTransformed <- reactive({
    estimatesData() %>% 
      mutate(
        year = recode(as.character(year), '2020'=2000, '2022'=2025, '2025'=2050, '2035'=2075, '2050'=2100),
        year_adj = year + position_year(scenario)
      )
  })

	# user_filtered_data[['estimatesData()']] <- estimatesData()

  # __generate point labels ----
  estimatesLabels <- reactive({
    padding_x <- 5

    label_df <- estimatesDataTransformed() %>%
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

    data <- spread(estimatesDataTransformed(), type, value)

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
        labels = c("2020", "2022", "2025", "2035", "2050"),
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
        color = guide_legend(ncol = 2)
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
        panel.ontop = TRUE,
        plot.margin=unit(c(1,1,1.5,1.2),"cm")
      ) +
      expand_limits(y=0) 
  })


  output[[estimates$IDs$plot]] <- renderPlot({
    estimatesPlot() +
      theme(
        plot.title = element_blank(),
        plot.subtitle = element_blank()
      )
  }, res=85)


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
          "base_case"
        ),
        comparator == input[[trends$IDs$controls$comparators]]
      ) %>%
      arrange(scenario) %>%
      mutate(
        year_adj = year + position_year(scenario)
      ) %>% 
      mutate(scenario = relevel(as.factor(scenario), 'base_case'),
      value = signif(value, 3))
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
      ncol = 2
      # nrow = min(n_distinct(data$scenario), 2)
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
        values = 1:length(plots$linetypes),
        labels = plots$labels
      ) +
      scale_x_continuous(
        name = "Year",
        breaks = c(2020, 2030, 2040, 2050) 
      ) +
      scale_y_continuous(
        name = trends$outcomes$formatted[[input[[trends$IDs$controls$outcomes]]]]
      ) +
      labs(
        title = title,
        subtitle = trends$comparators$formatted[[input[[trends$IDs$controls$comparators]]]]
      ) +
      guides(
        color = guide_legend(title = 'Scenario', ncol = 2),
        fill = guide_legend(title = 'Scenario', ncol = 2),
        linetype = guide_legend(title = 'Scenario', ncol = 2)
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
        plot.margin=unit(c(1,1,1.5,1.2),"cm")
      ) +
      expand_limits(y=0) 

    # if(input[['trendsUncertaintyInterval-1']]) {
    #   p <- p +
    #     geom_ribbon(
    #       mapping = aes(
    #         x = year,
    #         ymin = ci_low,
    #         ymax = ci_high,
    #         fill = scenario
    #       ),
    #       alpha = 0.3
    #     )
    # }

    return(p)
  })

  output[[trends$IDs$plot]] <- renderPlot({
    trendsPlot() +
      theme(
        plot.title = element_blank(),
        plot.subtitle = element_blank()
      )
  }, res=85)
  
  # addoutputs server ----
  # __calculate data ----
  addoutputsData <- reactive({
    req(
      input[[addoutputs$IDs$controls$comparators]],
      input[[addoutputs$IDs$controls$outcomes]],
      c(
        input[[addoutputs$IDs$controls$interventions]],
        input[[addoutputs$IDs$controls$analyses]],
        "base_case"
      )
    )
    
    ADDOUTPUTS_DATA() %>%
      dplyr::filter(
        population == input[[addoutputs$IDs$controls$populations]],
        age_group == input[[addoutputs$IDs$controls$ages]],
        outcome == input[[addoutputs$IDs$controls$outcomes]],
        scenario %in% c(
          input[[addoutputs$IDs$controls$interventions]],
          input[[addoutputs$IDs$controls$analyses]],
          "base_case"
        ),
        comparator == input[[addoutputs$IDs$controls$comparators]]
      ) %>%
      arrange(scenario) %>%
      mutate(
        year_adj = year + position_year(scenario)
      ) %>% 
      mutate(scenario = relevel(as.factor(scenario), 'base_case'),
             value = signif(value, 3))  %>% 
      mutate(scenario = sapply(scenario, function(x) {
        if (x %in% c('base_case', names(addoutputs$interventions$labels), names(addoutputs$analyses$labels))) {
          c(base_case = "Base Case", addoutputs$interventions$labels, addoutputs$analyses$labels)[[x]]
        } else as.character(x)
      })) 
  })
  
  # user_filtered_data[['addoutputsData()']] <- addoutputsData()
  
  # __set title ----
  addoutputsTitle <- reactive({
    req(
      input[[addoutputs$IDs$controls$outcomes]],
      input[[addoutputs$IDs$controls$populations]],
      input[[addoutputs$IDs$controls$ages]]
    )
    
    sprintf(
      "Projected %s in the %s, %s in %s",
      addoutputs$outcomes$labels[[input[[addoutputs$IDs$controls$outcomes]]]],
      addoutputs$populations$formatted[[input[[addoutputs$IDs$controls$populations]]]],
      addoutputs$ages$formatted[[input[[addoutputs$IDs$controls$ages]]]],
      if (geo_short_code() == 'US') 'the US' else unname(geographies[geo_short_code()])
    )
  })
  
  output[[addoutputs$IDs$title]] <- reactive({
    title <- addoutputsTitle()
    
    session$sendCustomMessage("tabby:altupdate", list(
      selector = paste0("#", addoutputs$IDs$plot),
      alt = title
    ))
    
    title
  })
  
  # __set subtitle ----
  output[[addoutputs$IDs$subtitle]] <- reactive({
    req(
      input[[addoutputs$IDs$controls$outcomes]],
      input[[addoutputs$IDs$controls$populations]],
      input[[addoutputs$IDs$controls$ages]]
    )
    
    addoutputs$comparators$formatted[[input[[addoutputs$IDs$controls$comparators]]]]
  })
  
  # __generate plot ----
  addoutputsPlot <- reactive({
    
    data <- spread(addoutputsData(), type, value)
    
    title <- addoutputsTitle()
    guide <- guide_legend(
      title = "Scenario",
      ncol = 2
      # nrow = min(n_distinct(data$scenario), 2)
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
        values = 1:length(plots$linetypes),
        labels = plots$labels
      ) +
      scale_x_continuous(
        name = "Year",
        breaks = c(2020, 2030, 2040, 2050) 
      ) +
      scale_y_continuous(
        name = addoutputs$outcomes$formatted[[input[[addoutputs$IDs$controls$outcomes]]]]
      ) +
      labs(
        title = title,
        subtitle = addoutputs$comparators$formatted[[input[[addoutputs$IDs$controls$comparators]]]]
      ) +
      guides(
        color = guide_legend(title = 'Scenario', ncol = 2),
        fill = guide_legend(title = 'Scenario', ncol = 2),
        linetype = guide_legend(title = 'Scenario', ncol = 2)
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
        plot.margin=unit(c(1,1,1.5,1.2),"cm")
      ) +
      expand_limits(y=0) 
    
    # if(input[['addoutputsUncertaintyInterval-1']]) {
    #   p <- p +
    #     geom_ribbon(
    #       mapping = aes(
    #         x = year,
    #         ymin = ci_low,
    #         ymax = ci_high,
    #         fill = scenario
    #       ),
    #       alpha = 0.3
    #     )
    # }
    
    return(p)
  })
  
  output[[addoutputs$IDs$plot]] <- renderPlot({
    addoutputsPlot() +
      theme(
        plot.title = element_blank(),
        plot.subtitle = element_blank()
      )
  }, res=85)
  
  # addoutputs server ----
  # __calculate data ----
  costcomparisonData <- reactive({
    req(
      # input[[costcomparison$IDs$controls$comparators]],
      input[[costcomparison$IDs$controls$costs]],
      c(
        input[[costcomparison$IDs$controls$interventions]],
        input[[costcomparison$IDs$controls$analyses]],
        "base_case"
      )
    )
    
    COSTCOMPARISON_DATA() %>%
      dplyr::filter(
        population == "all_populations",
        age_group == "all_ages",
        outcome == input[[costcomparison$IDs$controls$costs]],
        scenario %in% c(
          input[[costcomparison$IDs$controls$interventions]],
          input[[costcomparison$IDs$controls$analyses]],
          "base_case"
        ),
        comparator == "absolute_value"
      ) %>%
      arrange(scenario) %>%
      mutate(
        year_adj = year + position_year(scenario)
      ) %>% 
      mutate(scenario = relevel(as.factor(scenario), 'base_case'),
             value = signif(value, 3)*2) 
  })
  
  # user_filtered_data[['costcomparisonData()']] <- costcomparisonData()
  
  # __set title ----
  costcomparisonTitle <- reactive({
    req(
      input[[costcomparison$IDs$controls$costs]]
    )
    sprintf(
      "Cost Effectiveness as measured by %s in %s",
      costcomparison$costs$labels[[input[[costcomparison$IDs$controls$costs]]]],
      if (geo_short_code() == 'US') 'the US' else unname(geographies[geo_short_code()])
    )
  })
  
  output[[costcomparison$IDs$title]] <- reactive({
    title <- costcomparisonTitle()
    
    session$sendCustomMessage("tabby:altupdate", list(
      selector = paste0("#", costcomparison$IDs$plot),
      alt = title
    ))
    
    title
  })
  
  # __set subtitle ----
  output[[costcomparison$IDs$subtitle]] <- reactive({
    req(
      input[[costcomparison$IDs$controls$costs]]#,
    )
    costcomparison$costs$formatted[[input[[costcomparison$IDs$controls$costs]]]]
  })
  
  # __generate plot ----
  costcomparisonPlot <- reactive({
    
    data <- spread(costcomparisonData(), type, value)
    
    title <- costcomparisonTitle()
    guide <- guide_legend(
      title = "Scenario",
      ncol = 2
      # nrow = min(n_distinct(data$scenario), 2)
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
        values = 1:length(plots$linetypes),
        labels = plots$labels
      ) +
      scale_x_continuous(
        name = "Year",
        breaks = c(2020, 2030, 2040, 2050) 
      ) +
      scale_y_continuous(
        name = costcomparison$costs$formatted[[input[[costcomparison$IDs$controls$costs]]]]
      ) +
      labs(
        title = title,
        subtitle = "" #costcomparison$comparators$formatted[[input[[costcomparison$IDs$controls$comparators]]]]
      ) +
      guides(
        color = guide_legend(title = 'Scenario', ncol = 2),
        fill = guide_legend(title = 'Scenario', ncol = 2),
        linetype = guide_legend(title = 'Scenario', ncol = 2)
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
        plot.margin=unit(c(1,1,1.5,1.2),"cm")
      ) +
      expand_limits(y=0) 
    
    # if(input[['costcomparisonUncertaintyInterval-1']]) {
    #   p <- p +
    #     geom_ribbon(
    #       mapping = aes(
    #         x = year,
    #         ymin = ci_low,
    #         ymax = ci_high,
    #         fill = scenario
    #       ),
    #       alpha = 0.3
    #     )
    # }
    
    return(p)
  })
  
  output[[costcomparison$IDs$plot]] <- renderPlot({
    costcomparisonPlot() +
      theme(
        plot.title = element_blank(),
        plot.subtitle = element_blank()
      )
  }, res=85)
  
  
  #EFFECTS server ----
  #___calculate data ----
  effectsData <- reactive({
    req(
      c(
        input[[costcomparison$IDs$controls$interventions]],
        # input[[costcomparison$IDs$controls$analyses]],
        "base_case"
      )
    )
    
    EFFECTS_DATA() %>%
      dplyr::filter(
        Scenario %in% c(
          input[[costcomparison$IDs$controls$interventions]],
          input[[costcomparison$IDs$controls$analyses]],
          "base_case"
        )) %>% mutate(Scenario = sapply(Scenario, function(x) {
      if (x %in% c('base_case', names(costcomparison$interventions$labels), names(costcomparison$analyses$labels))) {
        c(base_case = "Base Case", costcomparison$interventions$labels, costcomparison$analyses$labels)[[x]]
      } else as.character(x)
    }))
    # ) %>%
    # arrange(scenario)
  })
  
  #costs server ----
  #___calculate data ----
    costsData <- reactive({
    req(
      c(
        input[[costcomparison$IDs$controls$interventions]],
        # input[[costcomparison$IDs$controls$analyses]],
        "base_case"
      )
    )
    
    COSTS_DATA() %>%
      dplyr::filter(
        Discount == 0,
        Scenario %in% c(
          input[[costcomparison$IDs$controls$interventions]],
          input[[costcomparison$IDs$controls$analyses]],
          "base_case"
        )) %>%
          dplyr::select(!Discount) %>% mutate(Scenario = sapply(Scenario, function(x) {
            if (x %in% c('base_case', names(costcomparison$interventions$labels), names(costcomparison$analyses$labels))) {
              c(base_case = "Base Case", costcomparison$interventions$labels, costcomparison$analyses$labels)[[x]]
            } else as.character(x)
          }))
        
      # ) %>%
      # arrange(scenario)
  })
  
  #cost effectiveness server ----
  #___calculate data ----
  costeffData <- reactive({
    req(
      input[[costcomparison$IDs$controls$discount]],
      input[[costcomparison$IDs$controls$perspectives]],
      input[[costcomparison$IDs$controls$comparator]],
      c(
        input[[costcomparison$IDs$controls$interventions]],
        # input[[costcomparison$IDs$controls$analyses]],
        "base_case"
      )
    )
    if(input[[costcomparison$IDs$controls$comparator]]=="ICER"){
    COSTEFF_ICER_DATA() %>%
      dplyr::filter(
        discount == input[[costcomparison$IDs$controls$discount]],
        perspectives == input[[costcomparison$IDs$controls$perspectives]],
        `Effectiveness Measure` == input[[costcomparison$IDs$controls$costs]],
        Scenario %in% c(
          input[[costcomparison$IDs$controls$interventions]],
          input[[costcomparison$IDs$controls$analyses]],
          "base_case"
        )) %>% arrange(`Effectiveness Measure`, desc(value)) %>%
      mutate("Incremental Cost"=Cost-lag(Cost),"Effectiveness (in 000s)"=value, "Incremental Effectiveness (in 000s)"=value-lag(value))%>%
      mutate("ICER"=round(`Incremental Cost`/`Incremental Effectiveness (in 000s)`,0))%>%
      # mutate("ACER"=round(`Incremental Cost`/`Incremental Effectiveness (in 000s)`,0))%>%
      select(!c(discount,perspectives,`Effectiveness Measure`,value)) %>% 
      mutate(ICER=case_when(ICER < 0 ~ "Dominated", TRUE ~ as.character(ICER)))%>%
        mutate(Scenario = sapply(Scenario, function(x) {
        if (x %in% c('base_case', names(costcomparison$interventions$labels), names(costcomparison$analyses$labels))) {
          c(base_case = "Base Case", costcomparison$interventions$labels, costcomparison$analyses$labels)[[x]]
        } else as.character(x)
      }))
      # mutate(ICER=ifelse(as.numeric(ICER) < 0, "Dominated", as.character(ICER)))
    } else {
      COSTEFF_ACER_DATA() %>%
        dplyr::filter(
          discount == input[[costcomparison$IDs$controls$discount]],
          perspectives == input[[costcomparison$IDs$controls$perspectives]],
          `Effectiveness Measure` == input[[costcomparison$IDs$controls$costs]],
          Scenario %in% c(
            input[[costcomparison$IDs$controls$interventions]],
            input[[costcomparison$IDs$controls$analyses]],
            "base_case"
          )) %>% 
        mutate("Effectiveness (in 000s)"=value, "Incremental Effectiveness (in 000s)"=value-first(value)) %>%
        mutate("ACER"=round(`Incremental Cost`/`Incremental Effectiveness (in 000s)`,0))%>%
        select(!c(discount,perspectives,`Effectiveness Measure`,value))   %>%
        mutate(ACER=case_when(ACER<0 ~ "Dominated", TRUE ~ as.character(ACER)))%>% 
        mutate(Scenario = sapply(Scenario, function(x) {
          if (x %in% c('base_case', names(costcomparison$interventions$labels), names(costcomparison$analyses$labels))) {
            c(base_case = "Base Case", costcomparison$interventions$labels, costcomparison$analyses$labels)[[x]]
          } else as.character(x)
        }))

        
      # %>% arrange(`Effectiveness Measure`, desc(value)) %>%
      #   mutate("Incremental Cost"=Cost-lag(Cost),"Effectiveness (in 000s)"=value, "Incremental Effectiveness (in 000s)"=value-lag(value))%>%
      #   mutate("ACER"=round(`Incremental Cost`/`Incremental Effectiveness (in 000s)`,0))%>%
      #   # mutate("ACER"=round(`Incremental Cost`/`Incremental Effectiveness (in 000s)`,0))%>%
      #   select(!c(discount,perspectives,`Effectiveness Measure`,value)) %>% 
      #   mutate(ACER=case_when(ACER<0 ~ "Dominated", TRUE ~ as.character(ACER)))
      }
  })

#___reactive title for cost effectiveness table 
  # costeffTitle <- reactive({
  #   req(
  #     input[[costcomparison$IDs$controls$costs]]
  #   )
  #   sprintf(
  #     "Cost Effectiveness as measured by %s in %s",
  #     costcomparison$costs$labels[[input[[costcomparison$IDs$controls$costs]]]],
  #     if (geo_short_code() == 'US') 'the US' else unname(geographies[geo_short_code()])
  #   )
  # })
  # 
  # output[[costeff$IDs$title]] <- reactive({
  #   title <-costeffTitle()
  #   
  #   session$sendCustomMessage("tabby:altupdate", list(
  #     selector = paste0("#", costeff$IDs$plot),
  #     alt = title
  #   ))
  #   
  #   title
  # })
  # 
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
          "base_case"
        ),
        comparator == 'absolute_value'
      ) %>% 
      mutate(scenario = relevel(as.factor(scenario), 'base_case'),
        value = signif(value, 3)) 

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

    bands_data <- data.frame(xstart = seq(1,11,1)-.45, xend = seq(1,11,1)+.45, col = '#F5F5F5')

    ggplot(data, aes(x = age_group)) +
      geom_rect(data = bands_data, mapping = aes(x = NULL, xmin = xstart, xmax = xend, ymin = -Inf, ymax = Inf), fill = '#F5F5F5') + 
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
          ncol = 2
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
        panel.grid.major.y = element_blank(), # element_line(size = 0.15, color = "#989898"),
        strip.background = element_blank(),
        strip.text = element_blank(),
        plot.margin=unit(c(1,1,1.5,1.2),"cm")

      ) +
      expand_limits(y=0) 
  })

  output[[agegroups$IDs$plot]] <- renderPlot({
    agegroupsPlot() +
      theme(
        plot.title = element_blank()
      )
  }, res=85)

  # downloads ----
  # __estimates png ----
  output[[estimates$IDs$downloads$png]] <- downloadHandler(
    filename = reactive({ paste0("tabby", 
      version_number, 
      "-estimates-plot-", geo_short_code(), "_", sys_date, ".png") }),
    content = function(file) {
      png(file, res = 85, width = 13, height = 9, units = "in")
      print(estimatesPlot())
      dev.off()
    }
  )

  # __estimates pdf ----
  output[[estimates$IDs$downloads$pdf]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
      version_number,
      "-estimates-plot-", geo_short_code(), "_", sys_date, ".pdf") }),
    content = function(file) {
      this <- estimatesPlot()

      pdf(file, width = 11, height = 8, title = this$plot$title)
      print(this)
      dev.off()
    }
  )

  # __estimates pptx ----
  output[[estimates$IDs$downloads$pptx]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
      version_number,
      "-estimates-plot-", geo_short_code(), "_", sys_date, ".pptx") }),
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
    filename = reactive({ paste0("tabby",
      version_number, 
      "-estimates-data-", geo_short_code(), "_", sys_date, ".xlsx") }),
    content = function(file) {
      estimatesData() %>% filter(outcome!="total_additional_ltbi_tests") %>%
        mutate(
          year = ifelse(year == 2000, 2016, year)
        ) %>%
        spread(type, value) %>%
        mutate(scenario = sapply(scenario, function(x) {
          if (x %in% c('base_case', names(estimates$interventions$labels), names(estimates$analyses$labels))) {
            c(base_case = "Base Case", estimates$interventions$labels, estimates$analyses$labels)[[x]]
          } else as.character(x)
        })) %>%
        mutate(outcome = sapply(outcome, function(x) estimates$outcomes$labels[[x]])) %>%
        select(
          outcome, scenario, age_group, year, mean # , ci_high, ci_low
        ) %>%
        openxlsx::write.xlsx(
          file = file,
          colNames = TRUE
        )
    }
  )

  # __estimates csv ----
  output[[estimates$IDs$downloads$csv]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
      version_number, 
      "-estimates-data-", geo_short_code(), "_", sys_date, ".csv") }),
    content = function(file) {
      estimatesData() %>% filter(outcome!="total_additional_ltbi_tests") %>%
        mutate(
          year = ifelse(year == 2000, 2016, year)
        ) %>%
        spread(type, value) %>%
        mutate(scenario = sapply(scenario, function(x) {
          if (x %in% c('base_case', names(estimates$interventions$labels), names(estimates$analyses$labels))) {
            c(base_case = "Base Case", estimates$interventions$labels, estimates$analyses$labels)[[x]]
          } else as.character(x)
        })) %>%
        mutate(outcome = sapply(outcome, function(x) estimates$outcomes$labels[[x]])) %>%
        select(
          outcome, scenario, age_group, year, mean # , ci_high, ci_low
        ) %>%
        write.csv(
          file = file,
          row.names = FALSE
        )
    }
  )

  # __trends png ----
  output[[trends$IDs$downloads$png]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
      version_number,
      "-trends-plot-", geo_short_code(), "_", sys_date, ".png") }),
    content = function(file) {
      png(file, res = 85, width = 13, height = 9, units = "in")
      print(trendsPlot())
      dev.off()
    }
  )

  # __trends pdf ----
  output[[trends$IDs$downloads$pdf]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
      version_number, "-trends-plot-", geo_short_code(), "_", sys_date, ".pdf") }),
    content = function(file) {
      this <- trendsPlot()
      pdf(file, width = 11, height = 8, title = this$plot$title)
      print(this)
      dev.off()
    }
  )

  # __trends pptx ----
  output[[trends$IDs$downloads$pptx]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
      version_number, "-trends-plot-", geo_short_code(), "_", sys_date, ".pptx") }),
    content = function(file) {
      tmp <- tempfile(fileext = "jpg")
      on.exit(unlink(tmp))

      this <- try(trendsPlot(), silent = TRUE)

      jpeg(tmp, res = 85, width = 13, height = 9, units = "in")

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
    filename = paste0("tabby",
      version_number, "-trends-data-", geo_short_code(), "_", sys_date, ".xlsx"),
    content = function(file) {
      trendsData() %>% filter(outcome!="total_additional_ltbi_tests") %>%
        mutate(
          year = ifelse(year == 2000, 2016, year)
        ) %>%
        spread(type, value) %>%
        mutate(scenario = sapply(scenario, function(x) {
          if (x %in% c('base_case', names(estimates$interventions$labels), names(estimates$analyses$labels))) {
            c(base_case = "Base Case", estimates$interventions$labels, estimates$analyses$labels)[[x]]
          } else as.character(x)
        })) %>%
        mutate(outcome = sapply(outcome, function(x) trends$outcomes$labels[[x]])) %>%
        select(
          outcome, scenario, age_group, year, mean # , ci_high, ci_low
        ) %>%
        openxlsx::write.xlsx(
          file = file,
          colNames = TRUE
        )
    }
  )

  # __trends csv ----
  output[[trends$IDs$downloads$csv]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
      version_number, "-trends-data-", geo_short_code(), "_", sys_date, ".csv") }),
    content = function(file) {
      trendsData() %>% filter(outcome!="total_additional_ltbi_tests") %>%
        mutate(
          year = ifelse(year == 2000, 2016, year)
        ) %>%
        spread(type, value) %>%
        mutate(scenario = sapply(scenario, function(x) {
          if (x %in% c('base_case', names(estimates$interventions$labels), names(estimates$analyses$labels))) {
            c(base_case = "Base Case", estimates$interventions$labels, estimates$analyses$labels)[[x]]
          } else as.character(x)
        })) %>%
        mutate(outcome = sapply(outcome, function(x) trends$outcomes$labels[[x]])) %>%
        select(
          outcome, scenario, age_group, year, mean # , ci_high, ci_low
        ) %>%
        write.csv(
          file = file,
          row.names = FALSE
        )
    }
  )

  # __agegroups png ----
  output[[agegroups$IDs$downloads$png]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
      version_number, "-agegroups-plot-", geo_short_code(), "_", sys_date, ".png") }),
    content = function(file) {
      png(file, res = 85, width = 13, height = 9, units = "in")
      print(agegroupsPlot())
      dev.off()
    }
  )

  # __agegroups pdf ----
  output[[agegroups$IDs$downloads$pdf]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
      version_number, "-agegroups-plot-", geo_short_code(), "_", sys_date, ".pdf") }),
    content = function(file) {
      this <- agegroupsPlot()
      pdf(file, width = 11, height = 8, title = this$plot$title)
      print(this)
      dev.off()
    }
  )

  # __agegroups pptx ----
  output[[agegroups$IDs$downloads$pptx]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
      version_number, "-agegroups-plot-", geo_short_code(), "_", sys_date, ".pptx") }),
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
    filename = reactive({ paste0("tabby",
      version_number, "-agegroups-data-", geo_short_code(), "_", sys_date, ".xlsx") }),
    content = function(file) {
      agegroupsData() %>% filter(outcome!="total_additional_ltbi_tests") %>%
        mutate(
          year = ifelse(year == 2000, 2016, year)
        ) %>%
        mutate(
          agegroup_start = as.numeric(sapply(strsplit(age_group, split="[-+]"), `[[`, 1))
        ) %>%
        spread(type, value) %>%
        mutate(scenario = sapply(scenario, function(x) {
          if (x %in% c('base_case', names(estimates$interventions$labels), names(estimates$analyses$labels))) {
            c(base_case = "Base Case", estimates$interventions$labels, estimates$analyses$labels)[[x]]
          } else as.character(x)
        })) %>%
        mutate(outcome = sapply(outcome, function(x) agegroups$outcomes$labels[[x]])) %>%
        arrange(agegroup_start) %>%
        select(
          outcome, scenario, age_group, year, mean #, ci_high, ci_low
        ) %>%
        openxlsx::write.xlsx(
          file = file,
          colNames = TRUE
        )
    }
  )
  
  # __agegroups csv ----
  output[[agegroups$IDs$downloads$csv]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
      version_number, "-agegroups-data-", geo_short_code(), "_", sys_date, ".csv") }),
    content = function(file) {
      agegroupsData() %>% filter(outcome!="total_additional_ltbi_tests") %>%
        mutate(
          year = ifelse(year == 2000, 2016, year)
        ) %>%
        mutate(
          agegroup_start = as.numeric(sapply(strsplit(age_group, split="[-+]"), `[[`, 1))
        ) %>%
        spread(type, value) %>%
        mutate(scenario = sapply(scenario, function(x) {
          if (x %in% c('base_case', names(estimates$interventions$labels), names(estimates$analyses$labels))) {
            c(base_case = "Base Case", estimates$interventions$labels, estimates$analyses$labels)[[x]]
          } else as.character(x)
        })) %>%
        mutate(outcome = sapply(outcome, function(x) agegroups$outcomes$labels[[x]])) %>%
        arrange(agegroup_start) %>%
        select(
          outcome, scenario, age_group, year, mean #, ci_high, ci_low
        ) %>%
        write.csv(
          file = file,
          row.names = FALSE
        )
    }
  )
  
  # __addoutputs png ----
  output[[addoutputs$IDs$downloads$png]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
                                 version_number,
                                 "-addoutputs-plot-", geo_short_code(), "_", sys_date, ".png") }),
    content = function(file) {
      png(file, res = 85, width = 13, height = 9, units = "in")
      print(addoutputsPlot())
      dev.off()
    }
  )
  
  # __addoutputs pdf ----
  output[[addoutputs$IDs$downloads$pdf]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
                                 version_number, "-addoutputs-plot-", geo_short_code(), "_", sys_date, ".pdf") }),
    content = function(file) {
      this <- addoutputsPlot()
      pdf(file, width = 11, height = 8, title = this$plot$title)
      print(this)
      dev.off()
    }
  )
  
  # __addoutputs pptx ----
  output[[addoutputs$IDs$downloads$pptx]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
                                 version_number, "-addoutputs-plot-", geo_short_code(), "_", sys_date, ".pptx") }),
    content = function(file) {
      tmp <- tempfile(fileext = "jpg")
      on.exit(unlink(tmp))
      
      this <- try(addoutputsPlot(), silent = TRUE)
      
      jpeg(tmp, res = 85, width = 13, height = 9, units = "in")
      
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
  
  # __addoutputs xlsx ----
  output[[addoutputs$IDs$downloads$xlsx]] <- downloadHandler(
    filename = paste0("tabby",
                      version_number, "-addoutputs-data-", geo_short_code(), "_", sys_date, ".xlsx"),
    content = function(file) {
      addoutputsData() %>% 
        mutate(
          year = ifelse(year == 2000, 2016, year)
        ) %>%
        spread(type, value) %>%
        mutate(scenario = sapply(scenario, function(x) {
          if (x %in% c('base_case', names(estimates$interventions$labels), names(estimates$analyses$labels))) {
            c(base_case = "Base Case", estimates$interventions$labels, estimates$analyses$labels)[[x]]
          } else as.character(x)
        })) %>%
        mutate(outcome = sapply(outcome, function(x) addoutputs$outcomes$labels[[x]])) %>%
        select(
          outcome, scenario, age_group, year, mean # , ci_high, ci_low
        ) %>%
        openxlsx::write.xlsx(
          file = file,
          colNames = TRUE
        )
    }
  )
  
  # __addoutputs csv ----
  output[[addoutputs$IDs$downloads$csv]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
                                 version_number, "-addoutputs-data-", geo_short_code(), "_", sys_date, ".csv") }),
    content = function(file) {
      addoutputsData() %>%
        mutate(
          year = ifelse(year == 2000, 2016, year)
        ) %>%
        spread(type, value) %>%
        mutate(scenario = sapply(scenario, function(x) {
          if (x %in% c('base_case', names(estimates$interventions$labels), names(estimates$analyses$labels))) {
            c(base_case = "Base Case", estimates$interventions$labels, estimates$analyses$labels)[[x]]
          } else as.character(x)
        })) %>%
        mutate(outcome = sapply(outcome, function(x) addoutputs$outcomes$labels[[x]])) %>%
        select(
          outcome, scenario, age_group, year, mean # , ci_high, ci_low
        ) %>%
        write.csv(
          file = file,
          row.names = FALSE
        )
    }
  )

  
  # __costcomparison png ----
  output[[costcomparison$IDs$downloads$png]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
                                 version_number,
                                 "-costcomparison-plot-", geo_short_code(), "_", sys_date, ".png") }),
    content = function(file) {
      png(file, res = 85, width = 13, height = 9, units = "in")
      print(costcomparisonPlot())
      dev.off()
    }
  )
  
  # __costcomparison pdf ----
  output[[costcomparison$IDs$downloads$pdf]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
                                 version_number, "-costcomparison-plot-", geo_short_code(), "_", sys_date, ".pdf") }),
    content = function(file) {
      this <- costcomparisonPlot()
      pdf(file, width = 11, height = 8, title = this$plot$title)
      print(this)
      dev.off()
    }
  )
  
  # __costcomparison pptx ----
  output[[costcomparison$IDs$downloads$pptx]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
                                 version_number, "-costcomparison-plot-", geo_short_code(), "_", sys_date, ".pptx") }),
    content = function(file) {
      tmp <- tempfile(fileext = "jpg")
      on.exit(unlink(tmp))
      
      this <- try(costcomparisonPlot(), silent = TRUE)
      
      jpeg(tmp, res = 85, width = 13, height = 9, units = "in")
      
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
  
  # __costcomparison xlsx ----
  output[[costcomparison$IDs$downloads$xlsx]] <- downloadHandler(
    filename = paste0("tabby",
                      version_number, "-costcomparison-data-", geo_short_code(), "_", sys_date, ".xlsx"),
    content = function(file) {
      
      #create a list of all costs data
      cost_list<-list()
      cost_list[["Effects Table"]]<-effectsData()
      cost_list[["Costs Table"]]<-costsData()
      cost_list[["Cost Effectiveness Table"]]<-costeffData()
      openxlsx::write.xlsx(
        cost_list,
        file,
        colNames = TRUE
      )
    }
  )
  
  # __costcomparison csv ----
  output[[costcomparison$IDs$downloads$csv]] <- downloadHandler(
    filename = reactive({ paste0("tabby",
                                 version_number, "-costcomparison-data-csv-", geo_short_code(), "_", sys_date, ".zip") }),
    content = function(file) {
      #go to a temp dir to avoid permission issues
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      files <- NULL;
      #create a list of all costs data
      cost_list<-list()
      cost_list[[1]]<-effectsData()
      cost_list[[2]]<-costsData()
      cost_list[[3]]<-costeffData()
      # cost_list[[4]]<-costsData()
      for (i in 1:3){
        namestr<-ifelse(i==1,"Effects Table",ifelse(i==2,"Costs Table",ifelse(i==3,"Cost Effectiveness Table")))
        fileName <- paste0(namestr,"_", geo_short_code(), "_", sys_date, ".csv")
        # write.csv(
        #   file = file,
        #   row.names = FALSE
        # )
        write.table(cost_list[[i]],fileName,sep = ',', row.names = F, col.names = T)
        files <- c(fileName,files)
      } 
    #create the zip file
    zip(file,files)
    }
  )
  filtered_data <- list(estimatesData = estimatesData, trendsData = trendsData, agegroupsData = agegroupsData,
                        addoutputsData=addoutputsData, costcomparisonData=costcomparisonData, effectsData = effectsData, costsData = costsData, costeffData=costeffData) 
  return(filtered_data)
}
