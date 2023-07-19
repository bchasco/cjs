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
#I found this is the easiest way to get the Columbia and Snake River data
columbia_river <- ne_rivers[grepl("Columbia",ne_rivers$name),]
snake_river <- ne_rivers[grepl("Snake",ne_rivers$name),]
columbia_sp <- spTransform(columbia_river, CRS="+proj=utm +zone=10")
Columbia_coord <- coordinates(columbia_sp)
snake_sp <- spTransform(snake_river, CRS="+proj=utm +zone=10")
Snake_coord <- coordinates(snake_sp)

#Now get the smaller tribs

#https://apps.nationalmap.gov/downloader/
#Downloaded and saved in LARGE_DATA folder.
#Another option is https://geo.wa.gov/datasets/wadnr::dnr-hydrography-water-bodies-forest-practices-regulation/explore?location=47.156500%2C-120.586485%2C8.00

#Yakima HUC 6-170300
#Wenatchee HUC 8-17020011
#Entiat HUC 8-17020010
#Methow HUC 8-17020008
#UPR C.R. NHD_H_1702_HU4_Shape
#MID C.R. NHD_H_1707_HU4_Shape
#LWR C.R. NHD_H_1708_HU4_Shape


UPR_CR <- st_read(dsn = "C:/large_data/rivers/UPR_CR/NHDFlowLine.shp")
UPRCR_st <- st_zm(UPR_CR[grepl("Columbia River",UPR_CR$gnis_name),])
UPRCR_sp <- spTransform(as(UPRCR_st, "Spatial"), CRS="+proj=utm +zone=10")

MID_CR <- st_read(dsn = "C:/large_data/rivers/MID_CR/NHDFlowLine.shp")
MIDCR_st <- st_zm(MID_CR[grepl("Columbia River",MID_CR$gnis_name),])
MIDCR_sp <- spTransform(as(MIDCR_st, "Spatial"), CRS="+proj=utm +zone=10")

LWR_CR <- st_read(dsn = "C:/large_data/rivers/LWR_CR/NHDFlowLine.shp")
LWRCR_st <- st_zm(LWR_CR[grepl("Columbia River",LWR_CR$gnis_name),])
LWRCR_st <- LWRCR_st[,names(LWRCR_st)%in%names(UPRCR_st)]
LWRCR_sp <- spTransform(as(LWRCR_st, "Spatial"), CRS="+proj=utm +zone=10")
# LWRCR_sp <- LWRCR_sp[,names(LWRCR_sp)%in%names(MIDCR_sp)]

# Read the shapefile using the sf package
Methow <- st_read(dsn = "C:/large_data/rivers/Methow/NHDFlowLine.shp")
Methow_st <- st_zm(Methow[grepl("Methow River",Methow$gnis_name),])
Methow_st <- Methow_st[,names(Methow_st)%in%names(UPRCR_st)]
Methow_sp <- spTransform(as(Methow_st, "Spatial"), CRS="+proj=utm +zone=10")

# Read the shapefile using the sf package
Wenatchee <- st_read(dsn = "C:/large_data/rivers/Wenatchee/NHDFlowLine.shp")
Wenatchee_st <- st_zm(Wenatchee[grepl("Wenatchee River",Wenatchee$gnis_name),])
Wenatchee_st <- Wenatchee_st[,names(Wenatchee_st)%in%names(UPRCR_st)]
Wenatchee_sp <- spTransform(as(Wenatchee_st, "Spatial"), CRS="+proj=utm +zone=10")

# Read the shapefile using the sf package
MID_SNK <- st_read(dsn = "C:/large_data/rivers/MID_SNK/NHDFlowLine.shp")
MID_SNK_st <- st_zm(MID_SNK[grepl("Snake River",MID_SNK$gnis_name),])
MID_SNK_st <- MID_SNK_st[,names(MID_SNK_st)%in%names(UPRCR_st)]
MID_SNK_sp <- spTransform(as(MID_SNK_st, "Spatial"), CRS="+proj=utm +zone=10")

# Read the shapefile using the sf package
MID_CR_LWR_SNK <- st_read(dsn = "C:/large_data/rivers/MID_CR_LWR_SNK/NHDFlowLine.shp")
MID_CR_LWR_SNK_st <- st_zm(MID_CR_LWR_SNK[grepl(c("Columbia River"),MID_CR_LWR_SNK$gnis_name),])
MID_CR_LWR_SNK_st <- MID_CR_LWR_SNK_st[,names(MID_CR_LWR_SNK_st)%in%names(UPRCR_st)]
MID_CR_LWR_SNK_sp <- spTransform(as(MID_CR_LWR_SNK_st, "Spatial"), CRS="+proj=utm +zone=10")

# Read the shapefile using the sf package
MID_UPR_CR <- st_read(dsn = "C:/large_data/rivers/MID_UPR_CR/NHDFlowLine.shp")
MID_UPR_CR_st <- st_zm(MID_UPR_CR[grep(c("Columbia River"),MID_UPR_CR$gnis_name),])
MID_UPR_CR_st <- MID_UPR_CR_st[,names(MID_UPR_CR_st)%in%names(UPRCR_st)]
MID_UPR_CR_sp <- spTransform(as(MID_UPR_CR_st, "Spatial"), CRS="+proj=utm +zone=10")

UPR_CR <- st_read(dsn = "C:/large_data/rivers/UPR_CR/NHDFlowLine.shp")
UPR_CR_st <- st_zm(UPR_CR[grep(c("Columbia River"),UPR_CR$gnis_name),])
UPR_CR_st <- UPR_CR_st[,names(UPR_CR_st)%in%names(UPRCR_st)]
UPR_CR_sp <- spTransform(as(UPR_CR_st, "Spatial"), CRS="+proj=utm +zone=10")

LWR_SNK <- st_read(dsn = "C:/large_data/rivers/LWR_SNK/NHDFlowLine.shp")
LWR_SNK_st <- st_zm(LWR_SNK[grep(c("Snake River"),LWR_SNK$gnis_name),])
LWR_SNK_st <- LWR_SNK_st[,names(LWR_SNK_st)%in%names(UPRCR_st)]
LWR_SNK_sp <- spTransform(as(LWR_SNK_st, "Spatial"), CRS="+proj=utm +zone=10")

#Combine the lines
net <- rbind.SpatialLinesDataFrame(Wenatchee_sp
                                   ,Methow_sp
                          ,Entiat_sp
                          ,UPR_CR_sp
                          ,MID_UPR_CR_sp
                          ,MID_CR_LWR_SNK_sp
                          ,MID_SNK_sp
                          ,LWR_SNK_sp
                          ,MIDCR_sp
                          ,LWRCR_sp
                          )

# Thinning factor (higher values retain more points, lower values thin more)
thinning_factor <- 0.01

# Thinning the SpatialLines object
net <- rmapshaper::ms_simplify(net, keep = thinning_factor)
net <- cleanup(net)
topologydots(rivers=net)


dams <- read.csv("./data/dams_coordinates.csv")
dams_sp <- SpatialPointsDataFrame(coords = dams[, c("Longitude", "Latitude")],
                                  data = dams,
                                  proj4string = CRS("+proj=longlat +datum=WGS84"))
#I don't know why this is two steps, byt it is
dams_utm <- spTransform(dams_sp, CRS("+proj=utm +zone=10 +datum=WGS84")) # Transform the coordinates to UTM
dams_xy <- xy2segvert(x=dams_utm$Longitude, y=dams_utm$Latitude, rivers=net)

mat <- matrix(0,nrow(dams_xy),nrow(dams_xy))

for(i in 1:nrow(dams_xy)){
  for(j in 1:nrow(dams_xy)){
    if(i!=j){
      dist = riverdistance(startseg = dams_xy$seg[i],
                           startvert = dams_xy$vert[i],
                           endseg = dams_xy$seg[j],
                           endvert = dams_xy$vert[j],
                           rivers = net)
      mat[j,i] <- mat[i,j] <- dist/1000 #kms
    }
  }
}


dams <- list(net = net,
             dams_sp = dams_sp,
             dams_utm = dams_utm,
             dams_xy = dams_xy,
             dmat = mat,
             dist = dist)

# saveRDS(dams, file = "./data/dams.rds")
