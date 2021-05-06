install.packages('spocc')
install.packages('mapr')
# library(rgbif)
library(spocc)
library(mapr)

name_lookup(query = 'Primula vulgaris', rank="species")

key <- name_suggest(q='Primula vulgaris', rank='species')$data$key[1]
primula_ocurrences <- occ_search(taxonKey=key)

# x <- map_fetch(taxonKey = key, year = 2000:2020)
# library(raster)
# plot(x)

library(sf)
library(dplyr)
primula_spatial <- primula_ocurrences$data %>%
  filter(!is.na(decimalLongitude) & !is.na(decimalLatitude)) %>%
  st_as_sf(coords = c('decimalLongitude', 'decimalLatitude'))
plot(primula_spatial, axes = TRUE)

mapr::map_ggplot(primula_ocurrences, map = "world")

dat <- occ(query = 'Primula vulgaris', from = 'gbif', has_coords = TRUE, limit = 1000)
map_ggplot(dat, map = "world")
map_leaflet(dat)
