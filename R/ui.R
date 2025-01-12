library(shiny)
library(shinydashboard)
library(bslib)
library(here)
library(tidyverse)
library(DT)
library(plotly)


ui <- page_sidebar(
    titlePanel("Lifelines Visualizer:"),
    theme = bs_theme(preset = "flatly"),


    mainPanel(
        tabsetPanel(
            tabPanel("Correlations",
                     tabsetPanel(
                         tabPanel("Graphs",
                                  p("..."),
                                  #plotOutput(outputId = "distHeight"),
                               #   print(output$comparison_table)

                           #    plotOutput("comparison_plot")
                         ),
                         tabPanel("Progression over time",
                                  # Plot the average change for all the measurements like changes in weight for T1, T2 and T3.
                                  h3("Plots here....")))

            ),

            tabPanel("General statistics",
                     card(h4("Explore the interactive data table below:"),
                          p("To-do: Add tooltips for options?")

                     ),
                     tabsetPanel(
                         tabPanel("Whole dataset",
                                  p("The dataset in its entirety:"),

                                  # Use the DT library to show an interactive table:
                                  DTOutput("interactive_table1")


                         ),
                         tabPanel("Stats",

                                  p("First, select the parameters you would like to use with the sidepanel on the left."))),

                     # To-do: add filter in server.R
                     # To-do: add table with general stats like avg. height for men/women etc.

            ),

            tabPanel("About",
                     # p("To-do: ...."),
                     tabsetPanel(
                         tabPanel("Interpretation",
                                  h3("To-do: write about the project and interpretation of the data.")

                         ),
                         tabPanel("Test:",
                                  h3("To-do: "))

                     ),

                     tabPanel("Origin of the data",
                              h3("To-do: Explain how the data was acquired"))

            ),


        ),
    ),


    sidebar = sidebar(

        card(
            p("What to compare?"),


        ),
       # card(
            selectInput(
                inputId="comparison_1",
                label="Variable one",
                choices=list(`cat1` = list("Age group", "Province", "Gender", "Smoking status", "Education group"),
                             `Body characteristics` = list("Height group", "Weight group", "other.."),
                             `Socioeconomic status` = list("Income class", "other", "other")),
                selected = NULL,
                multiple = FALSE,
                selectize = TRUE,
                width = NULL,
                size = NULL
          #  ),
        ),
      #  card(
            selectInput(
                inputId="comparison_2",
                label="Variable two",
                choices=list(`cat1` = list("Age group", "Province", "Gender", "Smoking status", "Education group"),
                             `Body characteristics` = list("Height group", "Weight group", "other.."),
                             `Socioeconomic status` = list("Income class", "other", "other")),
                selected = NULL,
                multiple = FALSE,
                selectize = TRUE,
                width = NULL,
                size = NULL

          #  ),



        ),


        card(
            p("Filter the displayed data using the following parameters:"),
            sliderInput(
                inputId = "age_slider",
                label = "Participant age:",
                min = min(lifelines_df$AGE_T1),
                max = max(lifelines_df$AGE_T1),
                value = c(min(lifelines_df$AGE_T1), max(lifelines_df$AGE_T1))
            ),

            sliderInput(
                inputId = "height_slider",
                label = "Participant height: (cm)",
                min = min(lifelines_df$HEIGHT_T1),
                max = max(lifelines_df$HEIGHT_T1),
                value = c(min(lifelines_df$HEIGHT_T1), max(lifelines_df$HEIGHT_T1))
            ),

            sliderInput(
                inputId = "weight_slider",
                label = "Participant weight: (kg)",
                min = min(lifelines_df$WEIGHT_T1),
                max = max(lifelines_df$WEIGHT_T1),
                value = c(min(lifelines_df$WEIGHT_T1), max(lifelines_df$WEIGHT_T1))
            ),

        ),

        selectInput(
            inputId="facet_wrap_cat",
            label="Facet_wrap category:",
            choices=list("Gender", "Age group", "Income class"),
            selected = NULL,
            multiple = FALSE,
            selectize = TRUE,
            width = NULL,
            size = NULL
        ),
        nav_item(
            input_dark_mode(id = "dark_mode", mode = "light")),
    ),


    # mainPanel(
    #  card(
     plotOutput(outputId = "weight_dist"),
    #  plotOutput(outputId = "distHeight"),
    #plotOutput(outputId = "wealth_cor"),

   # textOutput(outputId = "selected_values"),




    #  )
    #)

)
