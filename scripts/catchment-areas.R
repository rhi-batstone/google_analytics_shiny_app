# This file contains the coordinates of CodeClan's three catchment areas (Edinburgh, Glasgow, and Inverness)
# It is used to define catchment areas
catchment_coordinates <- tibble::tibble(
  catchment = c(
    "edinburgh",
    "glasgow",
    "inverness"
  ),
  latitude = c(
    55.9533, # Ed
    55.8642, # Gl
    57.4778  # In
  ),
  longitude = c(
    -3.1883, # Ed
    -4.2518, # Gl
    -4.2247  # In
  )
)
