from eduea import EA , EAOpts , Binary
from fractions import Fraction
import random

# random.seed(5641984138)



class Item:
    def __init__(self, name, value, weigth):
        self.name = name
        self.value = value
        self.weigth = weigth
    def __repr__(self):
        return "{" + str(self.name) + " - " + str(self.value) + " PLN, " + str(self.weigth) + " kg}"
    def __str__(self):
        return str(self.name) + " - " + str(self.value) + " PLN, " + str(self.weigth) + " kg"

 

all_items = [ \
    Item("Naszyjnik", 7, 5),\
    Item("Laptop", 7, 12),\
    Item("Telefon", 4, 1),\
    Item("Kolczyki", 3, 0.5),\
    Item("pieniadze", 7, 1),\
    Item("telewizor", 7, 12),\
    Item("pierscionek", 6, 1),\
    Item("Obraz", 3, 7),\
    Item("złoto", 7, 12),\
    Item("playstation", 7, 7),\
    Item("pistolet", 4, 1),\
    Item("cos", 3, 0.5),\
    ]

max_weight = 25
N = len(all_items)

print( str(N) + " items: ")
for item in all_items:
    print("\t" + str(item))
print("")


def decode(genotype):
    selected_items = [all_items[i] for i in range(len(genotype)) if genotype[i]]
    return selected_items



# im wiekszy "fitness" tym lepszy osobnik !!!
def fitness(phenotype):
    selected_items = phenotype
    total_weight = sum([item.weigth for item in selected_items])
    total_value = sum([item.value for item in selected_items])
    if total_weight > max_weight:
        return -1
    else:
        return total_value



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
best_items = solution.best_solution.phenotype
print ( " The best solution found is = %5.2f " % solution.best_solution.value )
print ( "                  for items : ")
for item in best_items:
    print("\t" + str(item))