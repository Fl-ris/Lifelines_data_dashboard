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


    mainPanel(tabsetPanel(
        tabPanel("Correlations", tabsetPanel(
            tabPanel(
                "Graphs",
                textOutput("data_points"),
                plotOutput(outputId = "comparison_graph"),

            ),
            tabPanel(
                "Progression over time",
                # Plot the average change for all the measurements like changes in weight for T1, T2 and T3.
                plotOutput(outputId = "progression_graph"),


            )
        ), ),

        tabPanel("Statistics", card(), tabsetPanel(
            tabPanel(
                "Significance calculator",
                # Use the DT library to show an interactive table:
                h5(
                    "Compare a number of your choosing, like age,height or weight to the dataset mean."
                ),
                p("First select a numerical variable from the 'Variable one' menu."),
                p("Use the input field below to input a number."),
                numericInput(
                    "sig_input_field",
                    "",
                    value = 30,
                    min = 0,
                    max = 9999
                ),
                DTOutput("sig_comparison")
            ),

            tabPanel(
                "Stats",

                p(
                    "First, select the parameters you would like to use with the sidepanel on the left."
                ),
                tableOutput("stats")

            )
        ), ),
        tabPanel(
            "Raw data",
            p("Use the table below to explore the entire dataset."),
            tabsetPanel(
                tabPanel(
                    "Entire dataset",
                    p("The unfiltered dataset in its entirety:"),

                    # Use the DT library to show an interactive table:
                    DTOutput("interactive_table1"),
                ),
                tabPanel(
                    "Filtered dataset:",
                    h3("Explore the filterd dataset using the parameters on the left."),
                    DTOutput("interactive_table_filterd")
                ),
            ),

        ),

        tabPanel(
            "About",
            tabsetPanel(tabPanel(
                "Interpretation",
                h3("")

            ), tabPanel(
                "Lifelines",
                h4("About the project:"),
                p(
                    "
                    Lifelines is a large, multigenerational cohort study that includes over 167,000 participants (10%) from the northern population of the Netherlands. Included are participants from three generations, who are followed with a lifespan perspective,
                    to obtain insight into healthy ageing."),
                    p("
                    The aim of Lifelines is to be a resource for the national and international scientific community.

                    To facilitare research we collect data and biosamples, using questionnaires, physical measurements and sampling, since 2006. "),
                    p("Every 1.5 years participants complete a questionnaire and once every 5 years participants visit a Lifelines location where biosamples are collected and several measurements and tests are conducted.
                    "),
            )),

        ),


    ), ),


    sidebar = sidebar(
        card(p("What to compare?"), ),
        selectizeInput(
            inputId = "comparison_1",
            label = "Variable one",
            choices = list(
                `Count:` = list("Count"),
                `Body measurements:` = list(
                    "GENDER",
                    "AGE_T1",
                    "HEIGHT_T1",
                    "WEIGHT_T1",
                    "BMI_T1",
                    "WAIST_T1",
                    "PREGNANCIES"
                ),
                `Socioeconomic status` = list("FINANCE_T1", "EDUCATION_LOWER_T1", "LOW_QUALITY_OF_LIFE_T1"),
                `Medical stats:` = list("DBP_T1", "SBP_T1", "HBF_T1", "CHO_T1", "GLU_T1"),
                `Opinions and mental issues:` = list(
                    "MENTAL_DISORDER_T1",
                    "LTE_SUM_T1",
                    "LDI_SUM_T1",
                    "DEPRESSION_T1"
                ),
                `Personality:` = list(
                    "C_SUM_T1",
                    "A_SUM_T1",
                    "SC_SUM_T1",
                    "I_SUM_T1",
                    "E_SUM_T1",
                    "SD_SUM_T1",
                    "V_SUM_T1",
                    "D_SUM_T1"
                )
            ),
            selected = "Count",

        ),
        selectizeInput(
            inputId = "comparison_2",
            label = "Variable two",
            choices = list(
                `Count:` = list("Count"),
                `Body measurements:` = list(
                    "GENDER",
                    "AGE_T1",
                    "HEIGHT_T1",
                    "WEIGHT_T1",
                    "BMI_T1",
                    "WAIST_T1",
                    "PREGNANCIES"
                ),
                `Socioeconomic status` = list("FINANCE_T1", "EDUCATION_LOWER_T1", "LOW_QUALITY_OF_LIFE_T1"),
                `Medical stats:` = list("DBP_T1", "SBP_T1", "HBF_T1", "CHO_T1", "GLU_T1"),
                `Opinions and mental issues:` = list(
                    "MENTAL_DISORDER_T1",
                    "LTE_SUM_T1",
                    "LDI_SUM_T1",
                    "DEPRESSION_T1"
                ),
                `Personality:` = list(
                    "C_SUM_T1",
                    "A_SUM_T1",
                    "SC_SUM_T1",
                    "I_SUM_T1",
                    "E_SUM_T1",
                    "SD_SUM_T1",
                    "V_SUM_T1",
                    "D_SUM_T1"
                )
            ),
            selected = "Count",
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


            sliderTextInput(
                inputId = "salary_slider",
                label = "Monthly salary (Eur):",
                choices = c(
                    "I do not know",
                    "I don't want to answer",
                    "Less than 750",
                    "750 - 1000",
                    "1000 - 1500",
                    "1500 - 2000",
                    "2000 - 2500",
                    "2500 - 3000",
                    "3000 - 3500",
                    "More than 3500"
                ),
                selected = c("I do not know", "More than 3500")

            ),
            checkboxGroupInput(
                "education_checkbox",
                "Level of education ",
                c("Lower education" = "a", "Higher educated" = "b"),
                selected = c("a", "b")
            ),

        ),
        card(
        selectInput(
            inputId = "color_theme",
            label = "Color scheme:",
            choices = list("Green", "Blue", "Red", "Orange", "Black", "Forestgreen"),
            selected = "Red",
            multiple = FALSE,
            selectize = TRUE,
            width = NULL,
            size = NULL
        ),

        selectInput(
            inputId = "graph_selector",
            label = "Graph type:",
            choices = list("violin", "barplot", "boxplot", "lineplot", "scatterplot"),
            selected = "boxplot",
            multiple = FALSE,
            selectize = TRUE,
            width = NULL,
            size = NULL
        ),

        sliderInput(
            "alpha_slider", "Alpha",
            min = 0, max = 1,
            value = 0.5
        ),


        nav_item(input_dark_mode(id = "dark_mode", mode = "light")),
    ),
),


)
