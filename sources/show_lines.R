# Show VBZ lines

loadAllShp <- function(data_path,shpfiles){
  shp_kreis <- shapefile(paste0(data_path,shpfiles$Stadtkreis) )
  crs00 <-  CRS('+proj=somerc +lat_0=46.95240555555556 +lon_0=7.439583333333333 +k_0=1 +x_0=600000 +y_0=200000 +ellps=bessel +towgs84=674.374,15.056,405.346,0,0,0,0 +units=m +no_defs ')
  shp_lines <- shapefile(paste0(data_path,shpfiles$VBZ_ptways) )
  crs(shp_lines) <- crs00
  shp_stops <- shapefile(paste0(data_path,shpfiles$VBZ_stops))
  crs(shp_stops) <- crs00
  shp_points <-  shapefile(paste0(data_path,shpfiles$VBZ_points) )
  crs(shp_points) <- crs00
  return(list(
    shp_kreis = shp_kreis, 
    shp_lines = shp_lines, 
    shp_stops = shp_stops, 
    shp_points = shp_points
  ))
}
loadAllShp_MEM <- memoise(loadAllShp)

show_lines <- function(lines, this.day = ymd('2015-10-04')){
  shpfiles <- data_frame(
    Fussgaengerzone = 'shapefiles/fussgaengerzone/Fussgaengerzone.shp',
    Fahrverbotszone = 'shapefiles/fahrverbotszone/Fahrverbotszone.shp',
    Stadtkreis = 'shapefiles/stadtkreis/Stadtkreis.shp',
    VBZ_ptways = 'shapefiles/vbz/ptways_j17.ptw.shp',
    VBZ_stops = 'shapefiles/vbz/stopareas.stp.shp',
    VBZ_points = 'shapefiles/vbz/stoppingpoints.stp.shp'
  )

  res <- loadAllShp_MEM(data_path,shpfiles)
  shp_kreis <-  res$shp_kreis
  shp_lines <-  res$shp_lines
  shp_stops <-  res$shp_stops
  shp_points <- res$shp_points
  
  # Subset the shapefiles :
  line_sel <- lines %>% as.character()
  ind <- shp_lines@data$LineEFA %in% line_sel
  shp_lines_sub <- shp_lines[ind,]
  
  # Query total delays :
  dly <- query_delays(as.integer(lines), this.day) 
  stat_diva_ids <- dly$halt_diva_von %>% unique()
  shp_stops_sub <- shp_stops[shp_stops$StopID %in% stat_diva_ids, ]
  shp_stops_sub <- sp::merge(shp_stops_sub, dly, by.x = 'StopID', by.y = 'halt_diva_von')
  
  tm_shape(shp = shp_kreis, is.master = T) + 
    tm_polygons(col = 'KNAME', alpha = 0.3, legend.show = F) +
    tm_shape(shp = shp_lines_sub, is.master = F) +
    tm_lines(col = 'LineEFA', lwd = 5) +
    tm_shape(shp = shp_stops_sub, is.master = T) + 
    tm_bubbles(col = 'tot_delay', alpha = 0.5, size = 0.3)
    
}
show_lines(lines = c(10), this.day = ymd('2015-11-04'))






