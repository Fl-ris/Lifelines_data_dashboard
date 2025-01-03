#' Import the dataset to be used.
#' @param dataset_path, Provide the path to the Lifelines dataset. description.
#' @return A dataframe with the provided dataset.
load_dataset <- function(dataset_path) {
    lifelines_df <- read.csv(file = dataset_path, header = TRUE)

}

#' Plot the correlation between montly income and the satisfaction score.
#' @param dataset, name of the dataset description
#' @return Jitter graph.
finance_neighborhood_cor <- function(dataset) {
  ggplot(data = dataset, mapping = aes(x = neighborhood_satisfaction, y = FINANCE_T1)) +
    geom_jitter(mapping = aes(alpha = 0.5)) +
    xlab("") +
    ylab("") +
    ggtitle("Correlation between wealth and neighborhood satisfaction") +
    theme_minimal()

}

#' Plot the gender distribution
#' @param dataset, name of the dataset description
#' @return Bar graph.
gender_dist <- function(dataset) {
  ggplot(data = dataset, mapping = aes(y = GENDER) ) +
    geom_bar(fill = "blue", alpha = 0.6) +
    xlab("Count: ") +
    ylab("Gender") +
    ggtitle("Participant count:") +
    theme_minimal()
}


pregnancies_amount <- function(dataset) {
  ggplot(data = dataset, mapping = aes(y = PREGNANCIES)) +
    geom_boxplot(fill = "blue", alpha=0.6) +
    xlab("") +
    ylab("Pregnancies:") +
    theme_minimal()
}

weight_dist <- function(dataset) {
  ggplot(data = dataset, mapping = aes(y = WEIGHT_T1) ) +
    geom_boxplot(fill = "green", alpha = 0.5) +
    xlab("Count: ") +
    ylab("Weight") +
    ggtitle("Participant weight:") +
    facet_wrap(~GENDER) +
    theme_minimal()

}
