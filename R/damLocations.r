# Create the data frame, Generated from ChatGPT
dams <- data.frame(
  Dam = c("Bonneville Dam", "McNary Dam", "Priest Rapids Dam", "Wanapum Dam", "Rock Island Dam",
          "Rocky Reach Dam", "Wells Dam", "Ice Harbor Dam", "Little Goose Dam",
          "Lower Monumental Dam", "Lower Granite Dam"),
  River_Km = c(235, 468, 715, 763, 824, 872, 932, 501, 586, 635, 742),
  Latitude = c(45.6381, 45.9267, 46.6447, 46.9272, 47.9249, 47.4419, 47.8562, 46.2533, 46.5874, 46.5939, 46.6604),
  Longitude = c(-121.9458, -119.3456, -119.9125, -119.9569, -119.9854, -120.2109, -120.0403, -118.9511, -118.0261, -118.3953, -117.4280)
)

#I added the parent child columns

# Save the data frame as CSV
read.csv(dams, file = "./data/dams_coordinates.csv", row.names = FALSE)
