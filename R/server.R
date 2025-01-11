

source(file = here("R", "utils.r"))

server <- function(input, output) {


    # To-do: Turn this into a function and place into the utils.r file.
    # Subset of the dataframe depending on the user's input selection.
    dynamic_dataframe <- reactive({
        req(input$comparison_1, input$comparison_2)  # Ensure inputs exist

        df <- lifelines_df %>%
            filter(AGE_T1 >= input$age_slider[1] & AGE_T1 <= input$age_slider[2]) %>%
            select(all_of(c(input$comparison_1, input$comparison_2)))  # Select only the chosen columns

        return(df)
    })

    output$comparison_table <- renderDataTable({
        dynamic_dataframe()
    })

    # Interactive plot with a variable amount of bins.
    output$distPlot <- renderPlot({
        x    <- lifelines_df$BIRTHYEAR
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

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
        finance_neighborhood_cor(lifelines_df)


    })
    # Test using input/output.
    output$comparison_1 <- renderText({
        paste("selected:", input$comparison_1)
    })

    output$interactive_table1 <- renderDataTable(lifelines_df)

}
