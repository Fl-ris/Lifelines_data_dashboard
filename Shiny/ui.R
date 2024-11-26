ui <- page_sidebar(
  # App title ----
  title = "Lifelines:",
  # Sidebar panel for inputs ----
  sidebar = sidebar(
    # Input: Slider for the number of bins ----
    sliderInput(
      inputId = "bins",
      label = "Number of bins:",
      min = 1,
      max = 50,
      value = 30
    ),
    sliderInput(
      inputId = "binss",
      label = "test2:",
      min = 1,
      max = 50,
      value = 30
    )
    
    
  ),
  plotOutput(outputId = "distPlot")
)