# Query delays
query_delays <- function(
  lines = 7,
  this.day = ymd('2014-01-01')
){
  con_delay <- mongo(collection = 'fahrzeitensollist', db = 'VBZ')
  qry <- list(linie = lines,
              betriebsdatum = '2015-10-04' %>% ymd()
  ) %>% 
    toJSON(auto_unbox = T, POSIXt = "mongo")
  res <- con_delay$find(query = qry) %>% as_data_frame() %>% 
    group_by(halt_diva_von) %>% 
    summarise(tot_delay = sum(ist_an_von - soll_an_von))
  return(res)  
}
