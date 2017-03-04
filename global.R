# global
user <- 'david'
data_path <- switch(user,
                    'david' = '/home/dmasson/data/OpenDataDayZurich2016/',
                    'craig' = 'sources/data/')

source('sources/query_delays.R')

con_delay <- mongo(collection = 'fahrzeitensollist', db = 'VBZ')
linesChoice <- con_delay$distinct(key = 'linie')

