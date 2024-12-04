library(shiny)
library(shinydashboard)
library(bslib)
library(here)
library(tidyverse)

library(plotly)

bslib::page_sidebar(...)

# Source the UI object from the following file:
source(file = "/home/floris/Documents/git_repo/Lifelines_data_dashboard/Shiny/ui.R")


#source(here::here('ui.R'))

# Source the Server object from the following file:
source(file = "/home/floris/Documents/git_repo/Lifelines_data_dashboard/Shiny/server.R")


shinyApp(ui = ui, server = server)