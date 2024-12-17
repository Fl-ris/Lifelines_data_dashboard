
source(file = "/home/floris/Documenten/git_repo/Lifelines_data_dashboard/Scripts/utils.r")

server <- function(input, output) {
  
 # dynamic_dataframe <- reactive({
#    df <- data.frame()
    
    
#    if ("Age" in %in% input$comparison_1) {
#      df$Age <- lifelines_df$AGE_T1
 #   }
    
      
      
#    return(df)
#  })
  
  
  output$distPlot <- renderPlot({
    
    x    <- lifelines_df$BIRTHYEAR
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#807fc3", border = "white",
         xlab = "BIRTHYEAR",
         main = "b")
    
  })
  output$distHeight <- renderPlot({
    ages <- lifelines_df$HEIGHT_T1
    hist(ages, col = "#807fc3", border = "white",
         xlab = "aa",
         main = "a")
    
    
  })
  
  output$wealth_cor <- renderPlot({
    finance_neighborhood_cor(lifelines_df)
    
    
  })
  
  output$comparison_1 <- renderText({
   paste("selected:", input$comparison_1)
  })
  
  output$interactive_table1 <- renderDataTable(
    lifelines_df) 
  
}

