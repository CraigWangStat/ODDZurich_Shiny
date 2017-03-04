# Show VBZ lines
library(raster)
library(tidyverse)
library(tmap)
library(ggmap)
library(mongolite)
library(lubridate)
library(jsonlite)
library(memoise)

show_lines <- function(lines){
  user <- 'david'
  data_path <- switch(user,
                      'david' = '/home/dmasson/data/OpenDataDayZurich2016/')
  
  shpfiles <- data_frame(
    Fussgaengerzone = 'shapefiles/fussgaengerzone/Fussgaengerzone.shp',
    Fahrverbotszone = 'shapefiles/fahrverbotszone/Fahrverbotszone.shp',
    Stadtkreis = 'shapefiles/stadtkreis/Stadtkreis.shp',
    VBZ_ptways = 'shapefiles/vbz/ptways_j17.ptw.shp',
    VBZ_stops = 'shapefiles/vbz/stopareas.stp.shp',
    VBZ_points = 'shapefiles/vbz/stoppingpoints.stp.shp'
  )
  shp_kreis <- shapefile(paste0(data_path, shpfiles$Stadtkreis) )
  crs00 <-  CRS('+proj=somerc +lat_0=46.95240555555556 +lon_0=7.439583333333333 +k_0=1 +x_0=600000 +y_0=200000 +ellps=bessel +towgs84=674.374,15.056,405.346,0,0,0,0 +units=m +no_defs ')
  shp_lines <- shapefile(paste0(data_path, shpfiles$VBZ_ptways) )
  crs(shp_lines) <- crs00
  shp_stops <- shapefile(paste0(data_path, shpfiles$VBZ_stops))
  crs(shp_stops) <- crs00
  shp_points <-  shapefile(paste0(data_path, shpfiles$VBZ_points) )
  crs(shp_points) <- crs00
  
  # str(shp_points@data, max.level = 2)
  
  # Subset the file :
  # line_sel <- c(7, 9) %>% as.character()
  line_sel <- lines %>% as.character()
  ind <- shp_lines@data$LineEFA %in% line_sel
  shp_lines_sub <- shp_lines[ind,]
  # str(shp_stops@data, max.level = 2)
  
  tm_shape(shp = shp_kreis, is.master = T) + 
    tm_polygons(col = 'KNAME', alpha = 0.3, legend.show = F) +
    tm_shape(shp = shp_lines_sub, is.master = F) +
    tm_lines(col = 'LineEFA', lwd = 5)
    # tm_shape(shp = shp_stops, is.master = T) + tm_dots () 
}
show_lines_mem <- memoise(show_lines)

show_lines_mem(lines = c(7,9))






