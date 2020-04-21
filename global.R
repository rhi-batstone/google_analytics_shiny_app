# Load required libraries
library(leaflet)
library(lubridate)
library(shiny)
library(tidyverse)
library(tsibble)

# Read location data from a stored CSV file, written from a Google Analytics call
location_data <- read_csv("data/location-data.csv")

# UI vectors
# Define the catchment area coordinates
# Stored in a seperate R file because it is also called by the data pulling script
source("scripts/catchment-areas.R")

# Define the maximum and minimum dates in the dataset
ui_date_range <- c(
  "min" = min(location_data$date, na.rm =  TRUE),
  "max" = max(location_data$date, na.rm =  TRUE)
)

# Show the debug section of the UI in the navbar pane
debug_section_enabled <- 1L
