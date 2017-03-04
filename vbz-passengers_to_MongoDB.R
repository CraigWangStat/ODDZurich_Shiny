# vbz-passengers data to MongoDB
# R CMD BATCH --no-save --no-restore /home/dmasson/CloudStation/code/OpenDataDayZurich2016/vbz-fahrzeiten_to_MongoDB.R /home/dmasson/data/OpenDataDayZurich2016/vbz-fahrzeiten_to_MongoDB.Rlog &    

library(tidyverse)
library(mongolite)
library(lubridate)
library(parallel)
library(stringr)

detectCores(all.tests = FALSE, logical = TRUE)
numCores <- 3

user <- 'david'
data_path <- switch(user,
                    'david' = '/home/dmasson/data/OpenDataDayZurich2016/')

files <- list.files(path = paste0(data_path,'data/passenger_counts'))
stations.files <- files[grep(pattern = 'stations_', files)]

insert2mongo <- function(i){
  paste0('--- Inserting ',i, '/', length(stations.files)) %>% writeLines()
  this.file <- stations.files[i]
  this.year <- str_sub(this.file, start = -8, -5) %>% as.integer()
  df0 <- read_csv(file = paste0(data_path,'data/delay_data/',this.file) )
  df <- df0 %>% mutate(year = this.year)
  
  # Insert in mongodb
  con <- mongo(collection = 'stations', db = 'VBZ')
  # fo <- con$find(limit = 4) %>% as_data_frame()
  con$insert(data = df)
  # con$drop()
  # con$count()
}

# insert2mongo(i = 1) # done : 1,2,3,4
res <- mcmapply(FUN = insert2mongo, 
                1:length(stations.files), 
                mc.cores = 1)

paste(Sys.time(), 'Ingestion done') %>% writeLines()

# Indexing
doIndexing <- F
if(doIndexing){
  fo <- con$find(limit = 1)
  con$index()
  indexed <- con$index(add = '{"linie" : 1, "betriebsdatum" : 1}')
}
