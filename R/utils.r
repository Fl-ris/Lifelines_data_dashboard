#' Import the dataset to be used.
#' @param dataset_path, Provide the path to the Lifelines dataset. description.
#' @return A dataframe with the provided dataset.
#' @export
load_dataset <- function(dataset_path) {
    library(shiny)
    library(shinydashboard)
    library(bslib)
    library(here)
    library(tidyverse)
    library(DT)
    library(plotly)

    # The "<<-" is to make a global variable.
    lifelines_df <<- read.csv(file = dataset_path, header = TRUE)
    lifelines_df <<- make_factors_df(lifelines_df)

    data_loaded <- TRUE
    # return(lifelines_df)
}

# Test:
filter_df <- function(df, column, keep_columns, values) {
    df <- df %>%
        if (is.null(column)) {
            select(column)
        } %>%
        filter(column > values)


}

#' Start the GUI
#' @param dataset_path, Provide the path to the Lifelines dataset. description.
#' @return A dataframe with the provided dataset.
#' @export
run_datadashboard <- function(dataset_path = here("Data", "Lifelines Public Health dataset - 2024.csv")) {
    library(shiny)
    library(shinydashboard)
    library(bslib)
    library(here)
    library(tidyverse)
    library(DT)
    library(plotly)

    here::here()
    # To-do: maybe remove the load_dataset function and add a dataset path parameter to the run_datadashboard function.

    # Source the UI object from the following file:
    source(file = here("R", "ui.R"))


    # Source the Server object from the following file:
    source(file = here("R", "server.R"))

    source(file = here("R", "utils.r"))
    lifelines_df <<- read.csv(file = dataset_path, header = TRUE)

    lifelines_df <<- make_factors_df(lifelines_df)

    shinyApp(ui = ui, server = server)
}

#' Internal function to make factors from some colums of the dataframe.
#' @param dataframe, load the dataframe to be used. description
make_factors_df <- function(dataframe) {
    lifelines_df <- lifelines_df %>%
        mutate(
            neighborhood_satisfaction = factor(
                NEIGHBOURHOOD1_T2,
                levels = 1:10,
                labels = as.character(1:10)
            ),
            neighborhood_characteristics = factor(
                NEIGHBOURHOOD2_T2,
                levels = 1:5,
                labels = as.character(1:5)
            ),
            neighborhood_unpleasantness = factor(
                NEIGHBOURHOOD3_T2,
                levels = 1:5,
                labels = c(
                    "Completely agree",
                    "Agree",
                    "Neutral",
                    "Disagree",
                    "Completely disagree"
                )
            ),
            neighborhood_moving_away = factor(
                NEIGHBOURHOOD4_T2,
                levels = 1:5,
                labels = c(
                    "Completely agree",
                    "Agree",
                    "Neutral",
                    "Disagree",
                    "Completely disagree"
                )
            ),
            neighborhood_attached = factor(
                NEIGHBOURHOOD5_T2,
                levels = 1:5,
                labels = c(
                    "Completely agree",
                    "Agree",
                    "Neutral",
                    "Disagree",
                    "Completely disagree"
                )
            ),
            neighborhood_feel_at_home = factor(
                NEIGHBOURHOOD6_T2,
                levels = 1:5,
                labels = c(
                    "Completely agree",
                    "Agree",
                    "Neutral",
                    "Disagree",
                    "Completely disagree"
                )
            ),
            FINANCE_T1 = factor(
                FINANCE_T1,
                levels = 1:10,
                labels = c(
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
                )
            ),
            LOW_QUALITY_OF_LIFE_T1 = factor(
                LOW_QUALITY_OF_LIFE_T1,
                levels = c(0L, 1L),
                labels = c("Mediocre", "False")
            ),
            LOW_QUALITY_OF_LIFE_T2 = factor(
                LOW_QUALITY_OF_LIFE_T2,
                levels = c(0L, 1L),
                labels = c("Low/Mediocre", "False")
            ),
            SMOKING = factor(
                SMOKING,
                levels = c(0L, 1L),
                labels = c("Smoking", "Non-smoking")
            ),
            GENDER =  factor(
                GENDER,
                levels = c(1:2),
                labels = c("Male", "Female")
            )
        )
    return(lifelines_df)

}


#' Plot the correlation between monthly income and the satisfaction score.
#' @param dataset, name of the dataset description
#' @return Returns a jitter graph.
finance_neighborhood_cor <- function(dataset) {
    ggplot(
        data = dataset,
        mapping = aes(x = neighborhood_satisfaction, y = FINANCE_T1)
    ) +
        geom_jitter(mapping = aes(alpha = 0.5)) +
        xlab("") +
        ylab("") +
        ggtitle("Correlation between wealth and neighborhood satisfaction") +
        theme_minimal()
}


#' Plot the gender distribution
#' @param dataset, name of the dataset description
#' @return Returns a bar graph.
gender_dist <- function(dataset) {
    ggplot(data = dataset, mapping = aes(y = GENDER)) +
        geom_bar(fill = "blue", alpha = 0.6) +
        xlab("Count: ") +
        ylab("Gender") +
        ggtitle("Participant count:") +
        theme_minimal()
}


#' Plot the amount of pregnancies per woman.
#' @param dataset, name of the dataset description
#' @return Returns a boxplot.
pregnancies_amount <- function(dataset) {
    ggplot(data = dataset, mapping = aes(y = PREGNANCIES)) +
        geom_boxplot(fill = "blue", alpha = 0.6) +
        xlab("") +
        ylab("Pregnancies:") +
        theme_minimal()
}


#' Plot the weight distribution for all the people.
#' @param dataset, name of the dataset description
#' @param x_comp, the variable that should be put on the x-axis.
#' @param y_comp, the variable that should be put on the y-axis.
#' @return Returns a boxplot.
weight_dist <- function(dataset, x_comp, y_comp) {
    #   x_axis <-


    ggplot(data = dataset, mapping = aes(y = WEIGHT_T1)) +
        geom_boxplot(fill = "green", alpha = 0.5) +
        xlab("Count: ") +
        ylab("Weight") +
        ggtitle("Participant weight:") +
        facet_wrap(~ GENDER) +
        theme_minimal()
}

#' Plot the the two selected variables.
#' @param dataset, name of the dataset description
#' @param x_comp, the variable that should be put on the x-axis.
#' @param y_comp, the variable that should be put on the y-axis.
#' @return Returns a graph.
comparison_graph <- function(dataset, x_comp, y_comp, count_var, color_theme, graph_type, alpha_value) {

    if (count_var) {
        # If the user wants to count occurrences of only one variable:
        base_plot <- ggplot(data = dataset, mapping = aes(y = .data[[y_comp]]))
    } else {
        # If the user wants to compare two variables:
        base_plot <- ggplot(data = dataset, mapping = aes(x = .data[[x_comp]], y = .data[[y_comp]]))
    }

    if (graph_type == "boxplot") {
        base_plot +
            geom_boxplot(fill = color_theme, alpha = alpha_value) +
            xlab(x_comp) +
            ylab(y_comp) +
            ggtitle(paste("Comparison of", x_comp, "and", y_comp)) +
            facet_wrap(~ GENDER) +
            theme_minimal()
    } else if (graph_type == "scatterplot") {
        base_plot +
            geom_point(color = color_theme, alpha = alpha_value) +
            xlab(x_comp) +
            ylab(y_comp) +
            ggtitle(paste("Comparison of", x_comp, "and", y_comp)) +
            facet_wrap(~ GENDER) +
            theme_minimal()
    } else if (graph_type == "barplot") {
        base_plot +
            geom_bar(stat = "identity", fill = color_theme, alpha = alpha_value) +
            xlab(x_comp) +
            ylab(y_comp) +
            ggtitle(paste("Comparison of", x_comp, "and", y_comp)) +
            facet_wrap(~ GENDER) +
            theme_minimal()
    } else if (graph_type == "violin") {
        base_plot +
            geom_violin(fill = color_theme, alpha = alpha_value) +
            xlab(x_comp) +
            ylab(y_comp) +
            ggtitle(paste("Comparison of", x_comp, "and", y_comp)) +
            facet_wrap(~ GENDER) +
            theme_minimal()
    } else if (graph_type == "lineplot") {
        base_plot +
            geom_line(color = color_theme, alpha = alpha_value) +
            xlab(x_comp) +
            ylab(y_comp) +
            ggtitle(paste("Comparison of", x_comp, "and", y_comp)) +
            facet_wrap(~ GENDER) +
            theme_minimal()
    }
}



longer_df <- function(dataframe) {
    df <- df %>%
        pivot_longer(
            cols = c("AGE_T1", "AGE_T2", "AGE_T3"),
            names_to = "time",
            values_to = "value"
        )
    return(df)
}


#' Plot the the two selected variables over time (T1, T2 and T3)
#' @param dataset, name of the dataset description
#' @param x_comp, the variable that should be put on the x-axis.
#' @param y_comp, the variable that should be put on the y-axis.
#' @return Returns a graph.
progression_graph <- function(dataset, x_comp, y_comp, count_var, color_theme) {
    long_df <- longer_df(dataset)

    if (count_var) { # If the user wanted to only display the amount of occurrences for one of the variables:
        ggplot(data = long_df, aes(x = time, y = value, group = 1)) +
            geom_line() +
            geom_point() +
            theme_minimal() +
            labs(x = "Time", y = "Value")

}}


# To-do: write docstrings for all functions below:

sig_calculator <- function(dataset, column_name, given_value) {
    column_data <- dataset[[column_name]]

    if (!is.numeric(column_data)) {
        return("Please select a numeric variable!")
    }

    # Calculate Cohen's d
    cohens_d <- abs(mean(column_data, na.rm = TRUE) - given_value) / sd(column_data, na.rm = TRUE)

    interpretation <- case_when(
        cohens_d < 0.2 ~ "Very small difference",
        cohens_d < 0.5 ~ "small difference",
        cohens_d < 0.8 ~ "medium difference",
        cohens_d >= 0.8 ~  "large difference"
    )

    result_table <- data.frame(
        Metric = c("Given Value", "Column Name", "Column Mean", "Column SD", "Cohen's d", "Interpretation"),
        Value = c(
            given_value,
            column_name,
            round(mean(column_data, na.rm = TRUE), 2),
            round(sd(column_data, na.rm = TRUE), 2),
            round(cohens_d, 3),
            interpretation
        )
    )

    return(result_table)
}

stat_viewer <- function(dataset, comparison_var1, comparison_var2) {
    a <- comparison_var1
    b <- comparison_var2

    stat_data <- summary(lifelines_df[c(a, b)])

    return(stat_data)

}

sig_comparison <- function(dataset, comparison_var1, comparison_number) {

    data_table <- sig_calculator(dataset, comparison_var1, comparison_number)

    return(data_table)
}



