library(shiny)
library(shinydashboard)
library(bslib)
library(here)
library(tidyverse)
library(DT)
library(plotly)
library(shinyWidgets)

ui <- page_sidebar(
    titlePanel("Lifelines Visualizer:"),
    theme = bs_theme(preset = "flatly"),


    mainPanel(
        tabsetPanel(
            tabPanel("Correlations",
                     tabsetPanel(
                         tabPanel("Graphs",
                                  textOutput("data_points"),
                               plotOutput(outputId = "comparison_graph"),

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
                choices=list(`cat1` = list("AGE_T1", "GENDER", "Count", "Smoking status", "Education group"),
                             `Body characteristics` = list("Height group", "Weight group", "other.."),
                             `Socioeconomic status` = list("Income class", "other", "other"),
                             `Medical stats:` = list("DBP_T1", "SBP_T1")),
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
                choices=list(`Count:` = list("Count"),
                             `Body measurements:` = list("GENDER", "AGE_T1", "HEIGHT_T1", "WEIGHT_T1", "BMI_T1", "WAIST_T1", "", "" ),
                             `Socioeconomic status` = list("FINANCE_T1", "EDUCATION_LOWER_T1", "LOW_QUALITY_OF_LIFE_T1", ""),
                             `Medical stats:` = list("DBP_T1", "SBP_T1", "HBF_T1", "CHO_T1", "GLU_T1")),
                selected = NULL,
                multiple = FALSE,
                selectize = TRUE,
                width = NULL,
                size = NULL

          #  ),



        ),


        card(
            p("Filter the displayed data using the following parameters:"),

            selectInput(
                "gender_selector",
                "Participant gender:",
                list("Men" = "1A", "Women" = "1B"),
                multiple = TRUE
            ),


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


            sliderTextInput(
                inputId = "salary_slider",
                label = "Monthly salary (Eur):",
                choices = c("I do not know", "I don't want to answer", "Less than 750", "750 - 1000", "1000 - 1500", "1500 - 2000", "2000 - 2500", "2500 - 3000", "3000 - 3500", "More than 3500"),
                selected = c("I do not know", "More than 3500")

            ),
            checkboxGroupInput(
                "education_checkbox",
                "Level of education ",
                c(
                    "Lower education" = "a",
                    "Higher educated" = "b"
                ),selected = c("a","b")
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

    #  plotOutput(outputId = "distHeight"),
    #plotOutput(outputId = "wealth_cor"),

   # textOutput(outputId = "selected_values"),




    #  )
    #)

)
