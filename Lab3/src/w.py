import random

names = ["Naszyjnik", "Laptop", "Telefon", "Kolczyk",\
         "Pies", "Dziecko", "Kot", "Narkotyki", \
         "Prochy Babci", "Rozum", "Godność Człowieka", "Krzyż", \
         "Biblia", "Legitymacja Studencka", "Student", "Twoja Stara" \
         "Chat GPT", "Cebula", "Teściowa", "Rzuf", \
         "Dyplom Inżyniera", "Praca Inżynierska", "Szczoteczka do zębów", "Okoń" \
         "Sprzedam Opla", "Ciemność", "Bóg Imperator"]

for i in range(20):
    print( "Item(" + str(random.choice(names)) + ", " + str(random.randint(1,7)) + ", " +  str(random.randint(1,12)) + ") \ " )
