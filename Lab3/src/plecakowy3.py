from eduea import EA , EAOpts , Binary
from fractions import Fraction
import random

# random.seed(5641984138)

PopulationSize = 200

ilosc_itemow = 20

max_weight = 25

class Item:
    def __init__(self, name, value, weigth):
        self.name = name
        self.value = value
        self.weigth = weigth
    def __repr__(self):
        return "{" + str(self.name) + " - " + str(self.value) + " PLN, " + str(self.weigth) + " kg}"
    def __str__(self):
        return str(self.name) + " - " + str(self.value) + " PLN, " + str(self.weigth) + " kg"



#all_items = [ Item(names, Value, weight)]
all_items = [ 
Item('Pies', 2, 12), 
Item('Narkotyki', 5, 10),      
Item('Pies', 5, 11),
Item('Kolczyk', 5, 11),
Item('Godność Człowieka', 2, 3),
Item('Krzyż', 5, 4),
Item('Krzyż', 1, 7),
Item('Cebula', 6, 3),
Item('Prochy Babci', 3, 3),
Item('Prochy Babci', 6, 1),
Item('Rozum', 1, 10),
Item('Laptop', 7, 12),
Item('Szczoteczka do zębów', 6, 7),
Item('Legitymacja Studencka', 4, 11),
Item('Rzuf', 4, 6),
Item('Kot', 7, 11),
Item('Bóg Imperator', 4, 8),
Item('Praca Inżynierska', 5, 3),
Item('Cebula', 4, 7),
Item('Telefon', 7, 1) 
 ]



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


wyniki = []

for PopulationSize in range(10, 300, 1):
    weigth = []
    value = []
    for i in range(10):
        # Ustawienia solvera 
        options = EAOpts()
        options.random_individual = Binary.random(N)
        options.decode = decode
        options.fitness = fitness
        options.pop_size = PopulationSize
        options.crossover = Binary.onePointCrossover
        options.mutation = Binary.mutation
        options.stop_generations = 20
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

        weigth.append(sum([item.weigth for item in best_items]))
        value.append(solution.best_solution.value)

    wyniki.append({"Population": PopulationSize, "Weigth": sum(weigth)/len(weigth), "Value": sum(value)/len(value) })


import csv
with open('plecakowy.csv', 'w', newline='') as csvfile:
    spamwriter = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
    spamwriter.writerow(["Population", "Weigth", "Value"])

    def localize_floats(row):
        return [
            str(el).replace('.', ',') if isinstance(el, float) else el 
            for el in row
        ]

    for wynik in wyniki:
        spamwriter.writerow(localize_floats([wynik["Population"], wynik["Weigth"], wynik["Value"]]))
