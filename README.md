# CodeClan Aggregate User Data by Location

## Project Brief
### Regional Performance

The client wanted the ability to analyse website performance as Google Analystics is too restrictive.
- Limited or no ability to compare site performance two or three locations in a single view
- Overview of a single city’s performance is complicated because of Google Analytics’ use of multiple small towns around a given city
- We would like to be able to compare high-level site performance in a defined Edinburgh and a Glasgow catchment, and also attach high level targets per catchment, including Inverness

## Tools

The data was pulled from the google_analytics API and then synthesized for demonstration purposes. 

The dashboard was created shinydashboard with the following libraries: 
- library(leaflet)
- library(lubridate)
- library(shiny)
- library(tidyverse)
- library(tsibble)

## Creating synthetic data
In order to demonstrate this dashboard publicly, the data from Google Analytics was synthesised. 
Calls were made to the GoogleAnalytics API to extract the metrics and dimension of interest. The output data was put through the synthpop library in R.

The date range in this public dashboard is limited to a year to match the dates of the synthetic data.


## Dashboard
### Overview Tab
In an attempt to not overcomplicate the dashboard and ensure we answered the brief the dashboard was limited to one interactive tab. The user can select a desired date range, set a circular catchment area for Edinburgh, Glasgow and Inverness in kilometers and select between the catchment areas displayed on the plots. 

- The top left plot shows a visual map of the user defined catchment areas
- Top right plot shows the number of sessions daily per catchment area within the user defined filters
- Bottom left displays numeric data relating to the cities in the user defined ranges
- Bottom right shows the total sessions for the chosen catchment areas in the defined date range and catchment radius

![](/www/screenshot_main_page.png)

### Raw Data Tab
This tab shows the raw data which changes in reaction to the user inputs. Kept in incase the user wants to understand the changes behind the scene or to debug.

![](/www/screenshot_debug_menu.png)

## Authors
Rhi Batstone, Miles Drake, and Jonathan "Johnny" Lau.

