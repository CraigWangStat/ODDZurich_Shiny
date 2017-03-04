# vbz-fahrzeiten to MongoDB
# R CMD BATCH --no-save --no-restore /home/dmasson/CloudStation/code/OpenDataDayZurich2016/vbz-fahrzeiten_to_MongoDB.R /home/dmasson/data/OpenDataDayZurich2016/vbz-fahrzeiten_to_MongoDB.Rlog &    

library(tidyverse)
library(mongolite)
library(lubridate)
library(parallel)

detectCores(all.tests = FALSE, logical = TRUE)
numCores <- 3

# Sys.setlocale('LC_ALL','C') 

office <- c('Gramophone', 'Walkman')[2]
data_path <- switch(office,
                    'Gramophone' = '/home/dmasson/data/OpenDataDayZurich2016/',
                    'Walkman' = '/home/dmasson/data/OpenDataDayZurich2016/')

files <- list.files(path = paste0(data_path,'data/delay_data'))
fahrzeiten.files <- files[grep(pattern = 'fahrzeitensollist', files)]

insert2mongo <- function(i){
  paste0('--- Inserting ',i, '/', length(fahrzeiten.files)) %>% writeLines()
  this.file <- fahrzeiten.files[i]
  df0 <- read_csv(file = paste0(data_path,'data/delay_data/',this.file) )
  colnames(df0) <- sub("\uFEFF","", names(df0)) 
  
  df <- df0 %>% mutate(betriebsdatum = dmy(betriebsdatum),
                       datum_von = dmy(datum_von),
                       datum_nach = dmy(datum_nach)
                       )
  
  # Insert in mongodb
  con <- mongo(collection = 'fahrzeitensollist', db = 'VBZ')
  # fo <- con$find(limit = 4) %>% as_data_frame()
  con$insert(data = df)
  # con$drop()
  # con$count()
}

# insert2mongo(i = 1) # done : 1,2,3,4
res <- mcmapply(FUN = insert2mongo, 
                1:length(fahrzeiten.files), 
                mc.cores = numCores)

paste(Sys.time(), 'Ingestion done') %>% writeLines()

# Indexing
doIndexing <- F
if(doIndexing){
  fo <- con$find(limit = 1)
  con$index()
  indexed <- con$index(add = '{"linie" : 1, "betriebsdatum" : 1}')
}
