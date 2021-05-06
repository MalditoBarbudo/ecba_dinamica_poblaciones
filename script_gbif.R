
# Acceso a la base de datos GBIF ------------------------------------------------------------------------
# Primer paso es instalar los paquetes si no los tenemos instalados
install.packages('spocc')
install.packages('mapr')
install.packages('sf')

# Ahora cargamos los paquetes
library(spocc)
library(mapr)
library(sf)
library(dplyr)


# Consultar datos para una especie ----------------------------------------------------------------------
primula_gbif <- occ(query = 'Primula vulgaris', from = 'gbif', has_coords = TRUE, limit = 20000)
primula_gbif


# Plotear el mapa ---------------------------------------------------------------------------------------
map_ggplot(primula_gbif, map = "world")
map_leaflet(primula_gbif)

