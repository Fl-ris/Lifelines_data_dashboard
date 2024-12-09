server <- function(input, output) {
  
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
}