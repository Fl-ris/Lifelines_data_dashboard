library(shiny)
library(shinydashboard)
library(bslib)
library(here)
library(tidyverse)
library(DT)
library(plotly)

here::here()


# Source the UI object from the following file:
source(file = here("Shiny", "ui.R"))


# Source the Server object from the following file:
source(file = here("Shiny", "server.R"))


shinyApp(ui = ui, server = server)
