readRDS(file = "./data/dams.rds")

plot(dams$net)

myZoom <- zoomtoseg

zoomtoseg(seg=c(12,13,19,21,11, 18),
          rivers=dams$net,
          ylab = "Norhting (m)",
          xlab = "Easting (m)",
          xlim=c(550000,1000000)
)

riverpoints(seg=dams$dams_xy$seg,
            vert=dams$dams_xy$vert,
            rivers=dams$net,
            pch=16,
            col="blue")

text(dams$dams_utm$Longitude,
     dams$dams_utm$Latitude,
     dams$dams_utm$Abr,
     pos = 3)

