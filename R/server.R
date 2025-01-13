

source(file = here("R", "utils.r"))

server <- function(input, output, session) {


    # To-do: Turn this into a function and place into the utils.r file.
    # Subset of the dataframe depending on the user's input selection.
    dynamic_dataframe <- reactive({
      #  req(input$comparison_1, input$comparison_2)  # Ensure inputs exist

        df <- lifelines_df %>%
            filter(AGE_T1 >= input$age_slider[1] & AGE_T1 <= input$age_slider[2],
                   HEIGHT_T1 >= input$height_slider[1] & HEIGHT_T1 <= input$height_slider[2],
                   WEIGHT_T1 >= input$weight_slider[1] & WEIGHT_T1 <= input$weight_slider[2],
                   (FINANCE_T1 %in% input$salary_slider))

        return(df)
    })

    output$progression_graph <- renderPlot({
        df <- dynamic_dataframe()

        # The two variable for the x and y axis.
        x_comp <- input$comparison_1
        y_comp <- input$comparison_2

        if ("Count" %in% input$comparison_1) {
            count_var <- TRUE
        } else {
            count_var <- FALSE
        }

        progression_graph(df, x_comp, y_comp, count_var, input$color_theme)


    })

    # To print general statistics like mean, sd and variance for the selected variables.
    output$stats <- renderTable({
        df <- dynamic_dataframe()
        stat_viewer(df, input$comparison_1, input$comparison_2)


    })

    output$weight_dist <- renderPlot({
        df <- dynamic_dataframe()
        weight_dist(df)
    })

    output$comparison_graph <- renderPlot({
        df <- dynamic_dataframe()

      # The two variable for the x and y axis.
      x_comp <- input$comparison_1
      y_comp <- input$comparison_2

    if ("Count" %in% input$comparison_1) {
        count_var <- TRUE
    } else {
        count_var <- FALSE
    }

      comparison_graph(df, x_comp, y_comp, count_var, input$color_theme)


    })

    output$distPlot <- renderPlot({
        df <- dynamic_dataframe()
        x    <- df$BIRTHYEAR

        bins <- seq(min(x), max(x), length.out = input$slider_2 + 1)

        lower <- input$age_slider[1]
        upper <- input$age_slider[2]

        hist(
            x,
            breaks = bins,
            col = "#807fc3",
            border = "white",
            xlab = "BIRTHYEAR",
            main = "Age:"
        )

    })

    output$distHeight <- renderPlot({
        ages <- df$HEIGHT_T1
        hist(
            ages,
            col = "#807fc3",
            border = "white",
            xlab = "",
            main = "Height distribution"
        )


    })

    output$wealth_cor <- renderPlot({
      #  df <<-
        finance_neighborhood_cor(lifelines_df)


    })


    output$data_points <- renderText({
        df <- dynamic_dataframe()
        paste("Amount of datapoints used with these filters:", length(df$GENDER))
    })

#    output$testtt <- renderText({
#        df <- dynamic_dataframe()
#        paste("Input", input$comparison_1)
#    })

    output$interactive_table1 <- renderDataTable(lifelines_df)

    output$interactive_table_filterd <- renderDataTable({
        df <- dynamic_dataframe()
        df
        })




    output$selected_values <- renderPrint({
        lower <- input$age_slider[1]
        upper <- input$age_slider[2]
        paste("Lower value:", lower, "\nUpper value:", upper)
    })}
