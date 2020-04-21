# Load required libraries
library(googleAnalyticsR)
library(keyring)
library(tidyverse)

# =================================================================================================================== #
# GOOGLE ANALYTICS ####
# =================================================================================================================== #

# Retrieve and set Google Analytics credentials

# Username
options(
  googleAuthR.client_id = keyring::key_get(
    service = "ga_client_id",
    keyring = "googleanalytics"
  )
)

# Password / secret
options(
  googleAuthR.client_secret = keyring::key_get(
    service = "ga_client_secret",
    keyring = "googleanalytics"
  )
)

# Reload Google Analytics
devtools::reload(
  pkg = devtools::inst("googleAnalyticsR")
)

# Pull data from Google Analytics
location_data_raw <- google_analytics(
  viewId = 102407343,
  date_range = c(
    start = "2005-01-01",
    end = "today"
  ),
  metrics = c(
    "sessions"
  ),
  dimensions = c(
    "date",
    "region",
    "city",
    "latitude",
    "longitude"
  ),
  max = -1
)


# =================================================================================================================== #
# DATA CLEANING ####
# =================================================================================================================== #

location_data_clean <- location_data_raw %>% 
  # Filter location data by Scotland only
  filter(
    region == "Scotland"
  ) %>% 
  select(
    -region
  ) %>% 
  # Change coordinates columns to numeric (double) format
  mutate(
    longitude = as.numeric(longitude),
    latitude = as.numeric(latitude)
  )


# =================================================================================================================== #
# ASSIGN CATCHMENT AREAS ####
# =================================================================================================================== #

# Define the coordinates of CodeClan's three key cities, used to define catchment areas
source("scripts/catchment-areas.R")

# Define function to calculate distance between a given point and a given catchment area
# Known problem with this implementation: The Earth is not a perfect sphere, so latitude and longitude do not have equal magnitude
# However, over the curvature of a region as small as Scotland, this does not matter
distance <- function(latitude, longitude, catchment_name){
  
  # Store point coordinates in a vector
  pos_point <- 
    c(
      latitude,
      longitude
    )
  
  # Retrieve coordinates of the given catchment area, and store them in a vector
  pos_catchment <- catchment_coordinates %>% 
    filter(
      # Filter coordinates by given catchment name
      # Force catchment name input into lowercase
      catchment == str_to_lower(catchment_name)
    ) %>% 
    select(
      latitude,
      longitude
    ) %>% 
    head(1) %>% # Sanity check, return only one result
    as.double() # Convert to a double numeric vector
  
  # Distance between points, using Pythagoras's theorem
  # sqrt[(xA-xB)^2 + (yA-yB)^2]
  output = sqrt(
    (
      # Difference in latitude
      # Each degree of laltitude is approximately 111 km apart
      (pos_point[1] - pos_catchment[1]) * 111
    )^2 + 
      (
        # Difference in longitude
        # At latitude 57 N, where most of the data lies, each degree of longitude is approximately 61 km apart
        (pos_point[2] - pos_catchment[2]) * 61
      )^2
  )
  
  return(output)
  
}

# Create tibble of Scottish cities, matched to their nearest catchment area
catchment_assign <- location_data_clean %>% 
  
  # Exclude undefined Scottish visitors
  # Undefined Scottish visitors will later be assigned a nearest catchment area of "NA"
  filter(
    city != "(not set)"
  ) %>% 
  
  # Create summary statistics columns
  group_by(
    city
  ) %>% 
  summarise(
    
    # Take the mean latitude and longitude for duplicate entries with mismatched coordinates
    avg_latitude = mean(latitude),
    avg_longitude = mean(longitude),
    
    # Create summary columns of the distance from each defined key catchment area
    distance_from_edinburgh = distance(
      latitude = avg_latitude,
      longitude = avg_longitude,
      catchment_name = "edinburgh"
    ),
    distance_from_glasgow = distance(
      latitude = avg_latitude,
      longitude = avg_longitude,
      catchment_name = "glasgow"
    ),
    distance_from_inverness = distance(
      latitude = avg_latitude,
      longitude = avg_longitude,
      catchment_name = "inverness"
    ),
    
    # Create minimum distance column
    distance_min = min(
      distance_from_edinburgh,
      distance_from_glasgow,
      distance_from_inverness
    )
    
  ) %>% 
  
  # Create column containing nearest catchment area
  mutate(
    nearest_catchment = ifelse(
      # If the point's distance from Edinburgh is less than its distance from either Glasgow or Inverness, the nearest catchment is Edinburgh
      test = distance_from_edinburgh < distance_from_glasgow & distance_from_edinburgh < distance_from_inverness,
      yes = "Edinburgh",
      no = ifelse(
        # Otherwise, if the point's distance from Glasgow is less than its distance from either Edinburgh or Inverness, the nearest catchment is Glasgow
        test = distance_from_glasgow < distance_from_edinburgh & distance_from_glasgow < distance_from_inverness,
        yes = "Glasgow",
        # Otherwise, the nearest catchment is "Inverness"
        no = "Inverness"
      )
    )
  )

# Join the catchment assignment to the dated location data
# Cities that are "(not set)" implicitly have a nearest catchment area of "NA"
location_data_catchment_assigned <- location_data_clean %>% 
  left_join(
    catchment_assign,
    by = "city"
  ) %>% 
  select(
    # Retain only the date, city name, and number of sessions from the cleaned Google Analytics pull
    date,
    city,
    sessions,
    # Retain only the nearest catchment and minimum distance from the catchment assignment tibble
    distance_min,
    nearest_catchment
  ) %>% 
  mutate(
    nearest_catchment = ifelse(
      test = is.na(nearest_catchment),
      yes = "None",
      no = nearest_catchment
    )
  )


# =================================================================================================================== #
# WRITE TO CSV ####
# =================================================================================================================== #

write_csv(
  x = location_data_catchment_assigned,
  path = "data/location-data.csv"
)
