from eduea import EA , EAOpts , Binary
import random

# random.seed(5641984138)

# f(x) = a3*x^3 + a2*x^2 + a1*x + a0
a3 = 1
a2 = 2
a1 = 0
a0 = 10

#  x1 <= x <= x2
x1 = 0.0
x2 = 15.0

N = 20


mx = (1 << N ) - 1

k1 = ( x2 - x1 ) / mx
k2 = x1

def decode(genotype):
    v , s = 1 , 0
    for i in genotype:
        s = s + v * i
        v = v * 2
    phenotype = k1 * s + k2
    return phenotype

# im wiekszy "fitness" tym lepszy osobnik !!!
def fitness(phenotype) :
    x = phenotype
    y = a3*x**3 + a2*x**2 + a1*x + a0
    return y



wyniki = []

def strPhenotype(pehontype):
    return pehontype

def strGenotype(genotype):
    return genotype


for population in [i for i in range(10,150)]:
    solutions = []
    for proby in range(10):
        try:
            # Ustawienia solvera 
            options = EAOpts()
            options.random_individual = Binary.random(N)
            options.decode = decode
            options.fitness = fitness
            options.pop_size = population
            options.crossover = Binary.onePointCrossover
            options.mutation = Binary.mutation
            options.stop_generations = 20
            # options.details = "individuals"
            # options.str_phenotype = strPhenotype
            # options.str_genotype = strGenotype
            # options.serialize = strGenotype

            # rozwiązywanie
            solution = EA(options)

            # wyświetlenie wyniku
            print ( " The best solution found is = %5.30f " % solution.best_solution.value )
            print ( "                      for x = %5.30f " % solution.best_solution.phenotype )

            solutions.append(solution)

        except:
            pass
    solutions1 = [s.best_solution.phenotype for s in solutions]
    best = None
    if len(solutions1):
        best =  sum(solutions1)/len(solutions1)
    wyniki.append( {"Population": population, "Best": best, "Solutions": solutions1} )

print(wyniki)

import csv
with open('kwadratowa.csv', 'w', newline='') as csvfile:
    spamwriter = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
    spamwriter.writerow(["Population", "Best"])
    
    def localize_floats(row):
        return [
            str(el).replace('.', ',') if isinstance(el, float) else el 
            for el in row
        ]

    for wynik in wyniki:
        spamwriter.writerow(localize_floats([wynik["Population"], wynik["Best"]]))
