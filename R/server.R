
source(file = here("R", "utils.r"))

server <- function(input, output) {

  # Change this to allow the user to load their own data...
  lifelines_df <- load_dataset(here("Data","Lifelines Public Health dataset - 2024.csv"))


  # To-do: Turn this into a function and place into the utils.r file.
  # Subset of the dataframe depending on the user's input selection.
 dynamic_dataframe <- reactive({
  # df <- data.frame()

   comparison_var_1 <- input$comparison_1
   comparison_var_2 <- input$comparison_1


   df <- lifelines_df %>%
     # To-do: Change this into somethings useful....
     subset(x = lifelines_df, subset = c(comparison_var_1, comparison_var_2))

   output$comparison_df_filtered <- renderTable({
     dynamic_dataframe()
   })
 #   if ("Age" in in input$comparison_1) {
 #    df$Age <- lifelines_df$AGE_T1
 #  }



  })

  # Interactive plot with a variable amount of bins.
  output$distPlot <- renderPlot({

    x    <- lifelines_df$BIRTHYEAR
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    hist(x, breaks = bins, col = "#807fc3", border = "white",
         xlab = "BIRTHYEAR",
         main = "Age:")

  })
  output$distHeight <- renderPlot({
    ages <- lifelines_df$HEIGHT_T1
    hist(ages, col = "#807fc3", border = "white",
         xlab = "",
         main = "Height distribution")


  })

  output$wealth_cor <- renderPlot({
    finance_neighborhood_cor(lifelines_df)


  })
  # Test using input/output.
  output$comparison_1 <- renderText({
   paste("selected:", input$comparison_1)
  })

  output$interactive_table1 <- renderDataTable(
    lifelines_df)

}

