# Wesbite Regional Performance

## Authors
Rhi Batstone, Miles Drake, and Jonathan "Johnny" Lau.

## Project Brief
### Regional Performance

The client wanted the ability to analyse website performance as Google Analystics is too restrictive.
- Limited or no ability to compare site performance between their three locations
- Overview of a single city’s performance including surrounding towns
- Compare site performance in a defined Edinburgh, Glasgow and Inverness catchment

## Tools

The data was called from the google_analytics API.

The dashboard was created shinydashboard with the following libraries: 
- `library(leaflet)`
- `library(lubridate)`
- `library(shiny)`
- `library(tidyverse)`
- `library(tsibble)`

## Synthesising the data
For public demonstrations of this dashboard the data was synthesised in R using `library(synthpop)`. 
Calls were made to the GoogleAnalytics API to extract the metrics and dimension of interest. The output data was put through the synthpop library in R.

## Dashboard
### Overview Tab
In an attempt to not overcomplicate the dashboard and ensure we answered the brief the dashboard was limited to one interactive tab. The user can select a desired date range, set a circular catchment area for Edinburgh, Glasgow and Inverness in kilometers and select between the catchment areas displayed on the plots. 

- The top left plot shows a visual map of the user defined catchment areas
- Top right plot shows the number of sessions daily per catchment area within the user defined filters
- Bottom left displays numeric data relating to the cities in the user defined ranges
- Bottom right shows the total sessions for the chosen catchment areas in the defined date range and catchment radius

#### Defining the catchments
Pythagoras? 🤷🏼‍♀️

![](/www/screenshot_overview.png)

### Raw Data Tab
This tab shows the raw data which changes in reaction to the user inputs. Kept in incase the user wants to understand the changes behind the scene or to debug.

![](/www/screenshot_rawdata_menu.png)

