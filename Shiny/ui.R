ui <- page_sidebar(
 titlePanel("Lifelines Visualizer:"),
 theme = bs_theme(preset = "flatly"),
 
  mainPanel(
    tabsetPanel(
      tabPanel("Correlations", 
                        tabsetPanel(
                        tabPanel("tab 1",
                                   h3("aaaa")
                                 
                                 ),
                        tabPanel("tab 2",
                                 h3("bbbb")))
                        
                                  ),
      
      tabPanel("General statistics",
               card(h4("Explore the interactive data table below:"),
                    p("test")
                    
                    ),
               tabsetPanel(
                 tabPanel("Whole dataset",
                          h3("aaaa"),
                          DTOutput("interactive_table1")
                      
                          
                 ),
                 tabPanel("Filterd dataset",
                          p("First, select the parameters you would like to use with the sidepanel on the left."))),
                          DTOutput("interactive_table1")
               # Use the DT library to show an interactive table:
               
            
               ),
      
      tabPanel("About",
               p("To-do: write about the project and interpretation of the data.")
               ),
          
    )
  ),


  sidebar = sidebar(
    card(
    selectInput(
      inputId="comparison_1",
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

 
# mainPanel(
#  card( 
#  plotOutput(outputId = "distPlot"),
#  plotOutput(outputId = "distHeight"),
#  plotOutput(outputId = "wealth_cor"),
#  textOutput(outputId = "comparison_1"),
  
 
  
#  )
#)


)