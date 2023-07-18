# install.packages("rnaturalearth")
# install.packages("sf")

library(rnaturalearth)
library(sf)
ne_rivers <- ne_download(category = "physical",
                         type = "rivers_lake_centerlines",
                         scale = 10,
                         returnclass = 'sp',
                         # extent = c(-122, 43, -116, 49)
                         )

columbia_river <- ne_rivers[grepl("Columbia",ne_rivers$name),]
snake_river <- ne_rivers[grepl("Snake",ne_rivers$name),]
columbia_snake_rivers <- rbind(columbia_river,
                               snake_river)

transformed_shape <- spTransform(columbia_snake_rivers, CRS="+proj=utm +zone=10")
rgdal::writeOGR(transformed_shape, dsn="./data/exported_shapefile.shp", layer="exported_shapefile", driver="ESRI Shapefile")


if(!file.exists("./data/columbia_snake_rivers.shp")){
  write_sf(columbia_snake_rivers, "./data/columbia_snake_rivers.shp")
}

MyRivernetwork <- line2network(sp=transformed_shape)
plot(MyRivernetwork)
cleanup(MyRivernetwork
     )

dams <- read.csv("./data/dams_coordinates.csv")

fakefish_riv <- xy2segvert(x=dams$Longitude, y=dams$Latitude, rivers=MyRivernetwork)
library(sf)
library(gdistance)
dam_loc <- st_as_sf(dams, coords = c("Longitude", "Latitude"), crs = st_crs(columbia_snake_rivers))

stream_distances <- sf::costDistance(columbia_snake_rivers, dam_loc)

library(ggplot2)

# Set latitude and longitude limits
lat_min <- 43
lat_max <- 49
lon_min <- -122
lon_max <- -116


# Plot the shapefile
ggplot() +
  geom_sf(data = columbia_snake_rivers, color = "blue") +
  labs(title = "Columbia River and Snake River") +
  theme_minimal() +
  geom_point(data = dams, aes(x = Longitude, y =  Latitude), inherit.aes = FALSE) #+
  # coord_cartesian(ylim = c(45,48))
