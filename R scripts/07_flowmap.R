# devtools::install_github('FlowmapBlue/flowmapblue.R')

library(flowmapblue)
library(dplyr)
library(sf)
library(lubridate)
library(stringr)
library(htmlwidgets)

mapbox_token <- 'pk.eyJ1IjoiYm9vbHlhbmljaCIsImEiOiJja2pjMDNzOHAwcTBuMnVzY3lqb3A2Nm9zIn0.t_7kw_Tm2GZPGPyYESlQJg'

locations <- stations_sf %>% 
  mutate(lat = st_coordinates(.)[,2],
         lon = st_coordinates(.)[,1]) %>% 
  select(id, name, lat, lon) %>% 
  st_drop_geometry()

flows <- data_clean %>% 
  filter(year(date) == '2020') %>%
  group_by(org, dst, date) %>% 
  summarise(ton = sum(ton)) %>% 
  select(origin=org, dest=dst, count=ton)
  
(f_map <- flowmapblue(locations, flows, mapbox_token, clustering=TRUE, 
                      darkMode=FALSE, animation=FALSE))


flowmapblue_m(locations, flows, mapbox_token, clustering=TRUE, 
            darkMode=FALSE, animation=FALSE, 
            mapbox.mapStyle = "mapbox://styles/boolyanich/ckb0hooy40rjw1ililt5zttmk")
