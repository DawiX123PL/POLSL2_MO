from eduea import EA , EAOpts , Binary
import random

random.seed(5641984138)


b = 1.0
a = -1.0
N = 32
mx = (1 << N ) - 1

k1 = ( b - a ) / mx
k2 = a

def decode(genotype):
    v , s = 1 , 0
    for i in genotype:
        s = s + v * i
        v = v * 2
    phenotype = k1 * s + k2
    return phenotype

# im wiekszy "fitness" tym lepszy osobnik !!!
def fitness(phenotype) :
    return - phenotype * phenotype



# Ustawienia solvera 
options = EAOpts()
options.random_individual = Binary.random(N)
options.decode = decode
options.fitness = fitness
options.pop_size = 10
options.crossover = Binary.onePointCrossover
options.mutation = Binary.mutation
options.stop_generations = 1000
# options.details = 1
# options.str_phenotype = strPhenotype
# options.str_genotype = strGenotype
# options.serialize = strGenotype


# rozwiązywanie
solution = EA(options)

# wyświetlenie wyniku
print ( " The best solution found is = %5.30f " % solution.best_solution.value )
print ( "                      for x = %5.30f " % solution.best_solution.phenotype )
