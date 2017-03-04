# Data Exploration
library(raster)
library(tidyverse)
library(tmap)
library(ggmap)
library(mongolite)
library(lubridate)
library(jsonlite)

office <- c('Gramophone', 'Walkman')[2]
data_path <- switch(office,
                    'Gramophone' = '/home/dmasson/data/OpenDataDayZurich2016/',
                    'Walkman' = '/home/dmasson/data/OpenDataDayZurich2016/')


# ggmap
zlon <- 8+33/60
zlat <- 47+22/60
zurich_map <- get_map(location = c(lon = zlon, lat = zlat), zoom = 13, scale = 1,
                      maptype = 'toner')
ggmap(zurich_map)

# tmap
shpfiles <- data_frame(
  Fussgaengerzone = 'shapefiles/fussgaengerzone/Fussgaengerzone.shp',
  Fahrverbotszone = 'shapefiles/fahrverbotszone/Fahrverbotszone.shp',
  Stadtkreis = 'shapefiles/stadtkreis/Stadtkreis.shp',
  VBZ = 'shapefiles/vbz/ptways_j17.ptw.shp'
  )
shp <- shapefile(paste0(data_path, 
                        # shpfiles$Fussgaengerzone
                        # shpfiles$Stadtkreis
                        shpfiles$VBZ
                        ))


crs(shp) <- CRS("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs")


str(shp@data, max.level = 2)
tm_shape(shp = shp, is.master = T) + tm_polygons(
  # col = 'ZONENNAME'
  # col = 'KNAME'
  col = 'LineEFA'
  )

# Plot lines
tm_shape(shp = shp, is.master = T) + tm_lines(col = 'LineEFA')

# VBZ data
f1 <- paste0(data_path,'data/delay_data/fahrzeitensollist2015092020150926.csv')
df1 <- read_csv(file = f1)
times <- df1$betriebsdatum %>% unique()

# Topographic SRTM data
fl <- paste0(data_path,'srtm_38_03/srtm_38_03.tif')
rtopo <- raster(fl)
b <- as(extent(zlon-0.03, zlon+0.03, zlat-0.02, zlat+0.02), 'SpatialPolygons')
crs(b) <- crs(rtopo)
rtzh <- rtopo %>% crop(b)
plot(rtzh)

# Station data
con.stations <- mongo(collection = 'stations', db = 'VBZ')
qry <- list(year = 2017) %>% toJSON(auto_unbox=T)
fo <- con.stations$find(query = qry, limit = 4)
# Delay fata
con_delay <- mongo(collection = 'fahrzeitensollist', db = 'VBZ')
con_delay$count()
infos <- con_delay$info() %>% .$stats
fo <- con_delay$find(limit = 1)
qry <- list(linie = 10,
            betriebsdatum = '2015-10-04' %>% ymd()) %>% 
  toJSON(auto_unbox=T, POSIXt = "mongo")
res <- con_delay$find(query = qry)
stat_diva_ids <- res$halt_diva_von %>% unique()

stops <- shp_stops@data %>% filter(StopID %in% stat_diva_ids)


shp_stops_sub <- shp_stops[shp_stops$StopID %in% stat_diva_ids, ]
plot(shp_stops_sub)


source('sources/show_lines.R')
res <- loadAllShp_MEM(data_path,shpfiles)
shp_kreis <-  res$shp_kreis
shp_lines <-  res$shp_lines
shp_stops <-  res$shp_stops
shp_points <- res$shp_points

View(shp_points@data)
View(shp_lines@data)

intersect(names(shp_points@data), names(shp_lines@data) )

shp_lines@data$DrawClass %>% unique()

intersect(names(shp_lines@data), names(res))

names(shp_lines@data)
names(shp_points@data)
View(shp_stops@data)

shp_stops@data$StopID %>% unique()


