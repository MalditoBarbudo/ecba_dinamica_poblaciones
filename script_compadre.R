
# Acceso a la base de datos compadre --------------------------------------------------------------------
# Primer paso es instalar los paquetes si no los tenemos instalados
install.packages('Rcompadre')
install.packages('dplyr')
install.packages('ggplot2')

# Ahora cargamos los paquetes
library(Rcompadre)
library(popdemo)
library(dplyr)
library(ggplot2)

# Obtener la última versión de compadre -----------------------------------------------------------------
# guardar la bd
compadre_db <- cdb_fetch('compadre')
# comprobar que tenemos lo que queremos
compadre_db
names(compadre_db)

# Comprobar especies ------------------------------------------------------------------------------------
# Podemos comprobar si nuestras especies de interes están presentes
species_wanted <- c("Pinus nigra", "Acer saccharum")
cdb_check_species(compadre_db, species_wanted)

# Podemos comprobar y a la vez sacar los datos para esas especies
compadre_species_wanted <- cdb_check_species(compadre_db, species_wanted, return_db = TRUE) 
compadre_species_wanted

# Más específico, Primula vulgaros solamente en España
compadre_primula_spain <- subset(
  compadre_db,
  SpeciesAccepted == 'Primula vulgaris' & Country == 'ESP'
)
# comprobamos que, efectivamente, solo tenemos datos para Primula en España
compadre_primula_spain$SpeciesAccepted
compadre_primula_spain$Country


# Extraer matrices --------------------------------------------------------------------------------------
# Podemos sacar matrices de población
primula_matA <- matA(compadre_primula_spain)

# Para saber a que corresponden los estadíos (A1, A2...)
matrixClass(compadre_primula_spain)

# Podemos obtener diferentes parámetros, como lambda, para cada una de las matrices:
# individualmente:
eigs(primula_matA[[1]], what = 'lambda')
# todas a la vez:
primula_lambdas <- sapply(primula_matA, eigs, what = 'lambda')
summary(primula_lambdas)
hist(primula_lambdas)

# Calcular dinámicas a partir de una población inicial --------------------------------------------------
# Creamos la matriz de población inicial a partir de los datos que hemos obtenido:
initial_pop_matrix <- matrix(c(50, 38, 26, 80), byrow = FALSE, ncol = 1)

# ahora podemos saber que población tendremos en el siguiente ciclo reproductivo
primula_matA[[1]] %*% initial_pop_matrix
primula_matA[[2]] %*% initial_pop_matrix
primula_matA[[3]] %*% initial_pop_matrix

# O hacer un bucle (loop) para tener los próximos 25 ciclos
dinamica_primula_25 <- initial_pop_matrix
for (year in 1:25) {
  dinamica_primula_25 <- cbind(
    dinamica_primula_25,
    round(primula_matA[[1]] %*% dinamica_primula_25[,year], 0)
  )
}
dinamica_primula_25

# Y con esto hacer una gráfica con la tendencia
transposed_data <- as.data.frame(t(dinamica_primula_25))
transposed_data$cycle <- 0:25

plot(transposed_data$cycle, transposed_data$A1, col = 'blue', type = 'l', ylim = c(0,180))
lines(transposed_data$cycle, transposed_data$A2, col = 'red', type = 'l')
lines(transposed_data$cycle, transposed_data$A3, col = 'yellow', type = 'l')
lines(transposed_data$cycle, transposed_data$A4, col = 'green', type = 'l')

# Otra forma
transposed_data %>% 
  tidyr::pivot_longer(cols = A1:A4, 'Estadío') %>%
  ggplot(aes(x = cycle, y = value, color = Estadío)) +
  geom_line()
