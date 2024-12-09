ui <- page_sidebar(
 titlePanel("Lifelines Visualizer:"),
 
  mainPanel(
    tabsetPanel(
      tabPanel("Correlations", plotOutput("plot")),
      tabPanel("General statistics", verbatimTextOutput("summary")),
      tabPanel("Test", tableOutput("table"))
    )
  ),


  sidebar = sidebar(
    card(
    selectInput(
      inputId="input_1",
      label="What to compare?",
      choices=list(`cat1` = list("Participant", "Province", "CT"),
           `cat2` = list("aa", "bb", "cc"),
           `cat3` = list("aa", "aa", "a")),
      selected = NULL,
      multiple = FALSE,
      selectize = TRUE,
      width = NULL,
      size = NULL
     
    ),
    
  ),

  card(
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
    ),
),
    selectInput(
      inputId="input_2",
      label="Plot type to visualize:",
      choices=list("Automatic", "Scatter plot", "blablabla"),
      selected = NULL,
      multiple = FALSE,
      selectize = TRUE,
      width = NULL,
      size = NULL
      )
    ),

 
 mainPanel(
  card( 
  plotOutput(outputId = "distPlot"),
  plotOutput(outputId = "distHeight")
  )
)

)