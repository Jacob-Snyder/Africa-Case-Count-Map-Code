#load shapefile for world borders
download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" , destfile="world_shape_file.zip")

#unzipping shapefile
system("unzip world_shape_file.zip")

#used raster package to load world borders shape file
library(raster)
world_spdf <- shapefile("TM_WORLD_BORDERS_SIMPL-0.3.shp")

#cleaning data
#creating spatial polygon data frame
library(dplyr)
world_spdf@data$POP2005[ which(world_spdf@data$POP2005 == 0)] = NA
world_spdf@data$POP2005 <- as.numeric(as.character(world_spdf@data$POP2005)) / 1000000 %>% round(2)

#creating a color paletter for the map
library(leaflet)
mypalette <- colorNumeric(palette = "viridis", domain = world_spdf@data$POP2005, na.color = "transparent")
mypalette(c(45,43))

