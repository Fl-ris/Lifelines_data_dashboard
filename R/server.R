

source(file = here("R", "utils.r"))

server <- function(input, output, session) {


    # To-do: Turn this into a function and place into the utils.r file.
    # Subset of the dataframe depending on the user's input selection.
    dynamic_dataframe <- reactive({
      #  req(input$comparison_1, input$comparison_2)  # Ensure inputs exist

        df <- lifelines_df %>%
            filter(AGE_T1 >= input$age_slider[1] & AGE_T1 <= input$age_slider[2])

        return(df)
    })

    output$comparison_table <- renderDataTable({
        dynamic_dataframe()
    })

    # Interactive plot with a variable amount of bins.

    output$weight_dist <- renderPlot({
        df <- dynamic_dataframe()
        weight_dist(df)
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
    # Test using input/output.
    output$comparison_1 <- renderText({
        paste("selected:", input$comparison_1)
    })


    output$interactive_table1 <- renderDataTable(lifelines_df)

    output$selected_values <- renderPrint({
        lower <- input$age_slider[1]
        upper <- input$age_slider[2]
        paste("Lower value:", lower, "\nUpper value:", upper)
    })}
