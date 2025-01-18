library(shiny)
library(shinydashboard)
library(bslib)
library(here)
library(tidyverse)
library(DT)
library(plotly)
library(shinyWidgets)
library(markdown)


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
                plotlyOutput(outputId = "progression_graph"),


            )
        ), ),

        tabPanel("Statistics", tabsetPanel(
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
                DTOutput("sig_comparison"),


                plotlyOutput("sd_viewer")
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
                    p("Explore the filterd dataset using the parameters on the left."),
                    card(
                        p("Download filtered dataframe:"),
                        downloadButton("downloadData", "Download"),
                    ),
                    DTOutput("interactive_table_filterd"),

                ),
            ),

        ),

        tabPanel(
            "About",
            tabsetPanel(tabPanel(
                "Interpretation",
                h4("The meaning of the dataset columns:"),
                uiOutput("column_text"),

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

        card(
            h5("Graph settings"),
            selectInput(
                inputId = "graph_selector",
                label = "Graph type:",
                choices = list("violin", "barplot", "boxplot", "lineplot", "scatterplot"),
                selected = "violin",
                multiple = FALSE,
                selectize = TRUE,
                width = NULL,
                size = NULL
            ),

            selectInput(
                inputId = "color_theme",
                label = "Color scheme:",
                choices = list("Green", "Blue", "Red", "Orange", "Black", "Forestgreen", "darkorchid2", "deeppink", "aquamarine","cyan", "cornsilk"),
                selected = "Blue",
                multiple = FALSE,
                selectize = TRUE,
                width = NULL,
                size = NULL
            ),



            sliderInput(
                "alpha_slider", "Alpha",
                min = 0, max = 1,
                value = 0.45
            ),

            checkboxInput(
                "comp_one_var", "Compare count", FALSE
            ),
        ),

        p("What to compare?"),
        selectizeInput(
            inputId = "comparison_1",
            label = "X-Variable",
            choices = list(
                `Count:` = list("Count"),
                `Body measurements:` = list(
                    "Gender",
                    "Age",
                    "Height",
                    "Weight",
                    "BMI",
                    "Waist Circumference",
                    "Number of Pregnancies"
                ),
                `Socioeconomic status` = list(
                    "Financial Status",
                    "Lower Education Level",
                    "Low Quality of Life"
                ),
                `Medical stats:` = list(
                    "Diastolic Blood Pressure",
                    "Systolic Blood Pressure",
                    "Pulse rate baseline",
                    "Cholesterol Level",
                    "Glucose Level"
                ),
                `Opinions and mental issues:` = list(
                    "Mental Disorder",
                    "Stressful Life Events pased year",
                    "Total amount of stess",
                    "Depression at baseline"
                ),
                `Personality:` = list(
                    "Competence Score",
                    "Anger-hostility Score",
                    "Self-consciousness Score",
                    "Impulsivity Score",
                    "Extraversion Score",
                    "Self-discipline",
                    "Vulnerability Score",
                    "Deliberation Score"
                )
            ),
            selected = "Height",  # Default selected value


        ),

        # If the "compare count" checkbox is chosen:
        conditionalPanel(
            condition = "input.comp_one_var == false",

            selectizeInput(
                inputId = "comparison_2",
                label = "Y-Variable",
                choices = list(
                    `Count:` = list("Count"),
                    `Body measurements:` = list(
                        "Gender",
                        "Age",
                        "Height",
                        "Weight",
                        "BMI",
                        "Waist Circumference",
                        "Number of Pregnancies"
                    ),
                    `Socioeconomic status` = list(
                        "Financial Status",
                        "Lower Education Level",
                        "Low Quality of Life"
                    ),
                    `Medical stats:` = list(
                        "Diastolic Blood Pressure",
                        "Systolic Blood Pressure",
                        "Pulse rate baseline",
                        "Cholesterol Level",
                        "Glucose Level"
                    ),
                    `Opinions and mental issues:` = list(
                        "Mental Disorder",
                        "Stressful Life Events pased year",
                        "Total amount of stess",
                        "Depression at baseline"
                    ),
                    `Personality:` = list(
                        "Competence Score",
                        "Anger-hostility Score",
                        "Self-consciousness Score",
                        "Impulsivity Score",
                        "Extraversion Score",
                        "Self-discipline",
                        "Vulnerability Score",
                        "Deliberation Score"
                    )
                ),
                selected = "Age",  # Default selected value


            )),

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
                c("Lower education" = "lower_edu", "Higher educated" = "higher_edu"),
                selected = c("lower_edu", "higher_edu")
            ),

        ),

        nav_item(input_dark_mode(id = "dark_mode", mode = "light")),

    ),


)
