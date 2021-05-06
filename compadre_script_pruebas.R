install.packages('Rcompadre')
library(Rcompadre)
library(popdemo)

compadre <- cdb_fetch("compadre")
compadre

names(compadre)

cdb_check_species(compadre, "Pinus nigra")

species_wanted <- c("Pinus nigra", "Acer saccharum")
cdb_check_species(compadre, species_wanted)


compadre_species_wanted <- cdb_check_species(compadre, species_wanted, return_db = TRUE) 

compadre_primula_spain <- subset(compadre, SpeciesAccepted == 'Primula vulgaris' & Country == 'ESP')
matrixClass(compadre_primula_spain)

primula_matA <- matA(compadre_primula_spain)

eigs(primula_matA[[1]], 'lambda')

primula_lambdas <- sapply(primula_matA, eigs, what = 'lambda')
summary(primula_lambdas)
hist(primula_lambdas)

initial_pop_matrix <- matrix(c(50, 38, 26, 80), byrow = FALSE, ncol = 1)

primula_matA[[1]] %*% initial_pop_matrix
primula_matA[[2]] %*% initial_pop_matrix
primula_matA[[3]] %*% initial_pop_matrix


final_matrix <- initial_pop_matrix
for (year in 1:50) {
  final_matrix <- cbind(
    final_matrix,
    round(primula_matA[[1]] %*% final_matrix[,year], 0)
  )
}
final_matrix

final_matrix <- initial_pop_matrix
for (year in 1:50) {
  final_matrix <- cbind(
    final_matrix,
    round(primula_matA[[2]] %*% final_matrix[,year], 0)
  )
}
final_matrix
