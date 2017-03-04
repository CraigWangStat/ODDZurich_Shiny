# global
user <- 'craig'
data_path <- switch(user,
                    'david' = '/home/dmasson/data/OpenDataDayZurich2016/',
                    'craig' = 'sources/data/')

source('sources/query_delays.R')
