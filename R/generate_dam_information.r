# install.packages("rnaturalearth")
# install.packages("sf")

library(rnaturalearth)
library(sf)
library(gdistance)
library(riverdist)

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

columbia_snake_rivers <- spTransform(columbia_snake_rivers, CRS="+proj=utm +zone=10")
MyRivernetwork <- line2network(sp=columbia_snake_rivers)

MyRivernetwork <- cleanup_verts(MyRivernetwork)

#This is where you clean up the connections
#This is a manual process that takes time
MyRivernetwork <- cleanup(MyRivernetwork)

#Check the network
#You should only see red dots at the endpoints
topologydots(rivers=MyRivernetwork)

dams <- read.csv("./data/dams_coordinates.csv")
dams_sp <- SpatialPointsDataFrame(coords = dams[, c("Longitude", "Latitude")],
                                         data = dams,
                                         proj4string = CRS("+proj=longlat +datum=WGS84"))
#I don't know why this is two steps, byt it is
dams_utm <- spTransform(dams_sp, CRS("+proj=utm +zone=10 +datum=WGS84")) # Transform the coordinates to UTM
dams_xy <- xy2segvert(x=dams_utm$Longitude, y=dams_utm$Latitude, rivers=MyRivernetwork)


# plot(MyRivernetwork,
#      cex.axis=1.5,
#      xlim = c(450000,900000))

zoomtoseg(seg=c(12,13,19,21,11),
          rivers=MyRivernetwork,
          ylab = "Norhting (m)",
          xlab = "Easting (m)",
          )

riverpoints(seg=dams_xy$seg,
            vert=dams_xy$vert,
            rivers=MyRivernetwork,
            pch=16,
            col="blue")

text(dams_utm$Longitude,
     dams_utm$Latitude,
     dams_utm$Abr,
     pos = 3)


text()
mat <- matrix(0,nrow(dams_xy),nrow(dams_xy))

for(i in 1:nrow(dams_xy)){
  for(j in 1:nrow(dams_xy)){
    if(i!=j){
      dist = riverdistance(startseg = dams_xy$seg[i],
                           startvert = dams_xy$vert[i],
                           endseg = dams_xy$seg[j],
                           endvert = dams_xy$vert[j],
                           rivers = MyRivernetwork)
      mat[j,i] <- mat[i,j] <- dist/10000 #10 of kms
    }
  }
}

dams <- list(net = MyRivernetwork,
             dams_sp = dams_sp,
             dams_xy = dams_xy,
             dmat = mat,
             dist = dist)

saveRDS(dams, file = "./data/dams.rds")

plot(MyRivernetwork)
