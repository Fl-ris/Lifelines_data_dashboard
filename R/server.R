

library(shiny)
library(shinydashboard)
library(bslib)
library(here)
library(tidyverse)
library(DT)
library(plotly)
library(shinyWidgets)
library(markdown)

source(file = here("R", "utils.r"))

server <- function(input, output, session) {
    #lifelines_df <- reactiveValues(df = NULL)
    # To-do: Turn this into a function and place into the utils.r file.
    # Subset of the dataframe depending on the user's input selection.

    dynamic_dataframe <- reactive({
        df <- lifelines_df %>%
            filter(
                AGE_T1 >= input$age_slider[1] & AGE_T1 <= input$age_slider[2],
                HEIGHT_T1 >= input$height_slider[1] &
                    HEIGHT_T1 <= input$height_slider[2],
                WEIGHT_T1 >= input$weight_slider[1] &
                    WEIGHT_T1 <= input$weight_slider[2],
                (FINANCE_T1 %in% input$salary_slider)

            )
        return(df)
    })

    output$progression_graph <- renderPlot({
    df <- dynamic_dataframe()

    # The two variables for the x and y axis.
    x_comp <- column_mapper(input$comparison_1)
    y_comp <- column_mapper(input$comparison_2)

    if ("Count" %in% input$comparison_1) {
        count_var <- TRUE
    } else {
        count_var <- FALSE
    }

    progression_graph(df, x_comp, y_comp, count_var, input$color_theme)
})

    # To print general statistics like mean, sd and variance for the selected variables.
    output$stats <- renderDT({
        df <- dynamic_dataframe()
        stat_viewer(df, column_mapper(input$comparison_1), column_mapper(input$comparison_2))



    })

    output$weight_dist <- renderPlot({
        df <- dynamic_dataframe()
        weight_dist(df)
    })

    output$comparison_graph <- renderPlot({
        df <- dynamic_dataframe()

        # The two variable for the x and y axis, map the variable name to the column name.
        x_comp <- column_mapper(input$comparison_1)
        y_comp <- column_mapper(input$comparison_2)

        comp_one_var <- input$comp_one_var
        color_theme <- input$color_theme
        graph_type <- input$graph_selector
        alpha_value <- input$alpha_slider

        # Set count_var to TRUE if the user only wants to compare the amount of occurrences of a variable.
        if ("Count" %in% input$comparison_1) {
            count_var <- TRUE
        } else {
            count_var <- FALSE
        }

        comparison_graph(df,
                         x_comp,
                         y_comp,
                         comp_one_var,
                         color_theme,
                         graph_type,
                         alpha_value)


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
        paste("Amount of datapoints used with these filters:",
              length(df$GENDER))
    })


    output$sig_comparison <- renderDataTable({
        df <- dynamic_dataframe()
        comparison_number <- input$sig_input_field
        sig_comparison(df, column_mapper(input$comparison_1), comparison_number)
    })

    output$sd_viewer <- renderPlotly({
        df <- dynamic_dataframe()
        comparison_number <- input$sig_input_field
        sd_viewer(df, column_mapper(input$comparison_1),comparison_number, input$color_theme)
    })


    output$interactive_table1 <- renderDataTable(lifelines_df)



    output$interactive_table_filterd <- renderDataTable({
        df <- dynamic_dataframe()
        df
    })


    output$selected_values <- renderPrint({
        lower <- input$age_slider[1]
        upper <- input$age_slider[2]
        paste("Lower value:", lower, "\nUpper value:", upper)
    })

    output$column_text <- renderText({
        # Use an external text file to not clutter the ui.r file with long text strings:
        includeMarkdown(here("R/", "colums.md"))
    })


    output$downloadData <- downloadHandler(
        filename = function() {
            paste("input", ".csv", sep = "")
        },
        content = function(file) {
            write.csv(dynamic_dataframe(), file, row.names = FALSE)
        }
    )
}
