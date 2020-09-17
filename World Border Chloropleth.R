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
world_spdf@data$casecount[ which(world_spdf@data$casecount == 0)] = NA
world_spdf@data$casecount <- as.numeric(as.character(world_spdf@data$casecount)) / 1000000 %>% round(2)

#creating a color paletter for the map
library(leaflet)
mypalette <- colorNumeric(palette = "viridis", domain = world_spdf@data$casecount, na.color = "transparent")
mypalette(c(45,43))

# Basic choropleth with leaflet?
m <- leaflet(world_spdf) %>% 
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( fillColor = ~mypalette(casecount), stroke=FALSE )

m

#adding "data" to world_spdf
world_spdf$casecount <- "Modified Africa Case Count Data"

#using a histogram to check distribution of variable 
#and understand which color scale should be used

# load ggplot2
library(ggplot2)

# Checking the distribution of the casecount dataset
#to understand what color scale I should use
world_spdf@data %>% 
  ggplot( aes(x=as.numeric(casecount))) + 
  geom_histogram(bins=20, fill='#69b3a2', color='white') +
  xlab("Case Count") + 
  theme_bw()

#coloring according to bins (as opposed to quantiles or
#Numeric palettes)
# Bin
m <- leaflet(world_spdf)%>% 
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5, color = ~colorBin("YlOrRd", casecount)(casecount) )
m
