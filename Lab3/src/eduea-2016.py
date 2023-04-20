import random

class Binary(object):

  @staticmethod
  def _random(size):
    ind = []
    for i in range(size):
      ind.append( random.randint(0,1) )
    return ind

  @staticmethod
  def random(size):
    return lambda: Binary._random(size)

  @staticmethod
  def onePointCrossover(ind1, ind2):
    size = len(ind1)
    point = random.randint(0, size-2) + 1
    child1 = ind1[:point]
    child2 = ind2[:point]
    child1.extend(ind2[point:])
    child2.extend(ind1[point:])
    return child1, child2

  @staticmethod
  def mutation(ind):
    size = len(ind)
    point = random.randint(0, size-1)
    new_ind = ind[:]
    new_ind[point] = 1 - new_ind[point]
    return new_ind

  @staticmethod
  def _realNumber(size, k1, k2):
    v, s = 1, 0
    for i in genotype:
      s = s + v * i
      v = v * 2
    return k1 * s + k2

  @staticmethod
  def realNumber(size, min, max):

    def decode(genotype):
      v, s = 1, 0
      for i in genotype:
        s = s + v * i
        v = v * 2
      return k1 * s + k2

    mx = (1 << size) - 1
    k1 = float(max - min) / mx
    k2 = min
    
    return decode

class Permutation(object):

  @staticmethod
  def _fullSwath(genotype):
    n = len(genotype)
    p1 = random.randint(0, n-2)
    if p1 == n - 2:
      p2 = n - 1
    else:
      p2 = random.randint(p1 + 1, n - 1)
    return p1, p2

  @staticmethod
  def _swath(genotype):
    n = len(genotype)
    p1 = random.randint(0, n-2)
    if p1 == 0:
      mx = n - p1 - 2
    else:
      mx = n - p1 - 1
    if mx > 1:
      dp = random.randint(1,mx)
    else:
      dp = 1
    p2 = p1 + dp
    return p1, p2

  @staticmethod
  def mutation(genotype):
    p1, p2 = Permutation._fullSwath(genotype)
    new_genotype = genotype[:]
    new_genotype[p1], new_genotype[p2] = genotype[p2], genotype[p1]
    return new_genotype

  @staticmethod
  def random(size):

    def rnd():
      genotype = range(size)
      for i in range(size):
        genotype = Permutation.mutation(genotype)
      return genotype

    return rnd

  @staticmethod
  def crossoverOX(parent1, parent2):
    
    def oxChild(parent1, parent2, p1, p2):
      child = ['x'] * len(parent1)
      # copy the swath
      child[p1:p2] = parent1[p1:p2]
      # calculate the first missing index
      if p1 > 0:
        idx = 0
      else:
        idx = p2
      # fill the missing elements
      for i in parent2:
        if i in child:
          continue
        child[idx] = i
        idx = idx + 1
        if idx <= p2:
          if idx >= p1:
            idx = p2
      return child

    p1, p2 = Permutation._swath(parent1)
    child1 = oxChild(parent1, parent2, p1, p2)
    child2 = oxChild(parent2, parent1, p1, p2)
    return child1, child2

  @staticmethod
  def crossoverCX(parent1, parent2):

    def nextIndex(idx, parent1, parent2):
      val = parent2[idx]
      next_idx = parent1.index(val)
      return next_idx

    def cycle(idx, parent1, parent2):
      c = [idx]
      next_idx = idx
      while True:
        next_idx = nextIndex(next_idx, parent1, parent2)
        if next_idx == idx:
          break
        else:
          c.append(next_idx)
      return c

    def cycleValues(cycle, parent):
      vals = []
      for i in cycle:
        vals.append( parent[i] )
      return vals

    def setCycleValues(target, cycle, source):
      for i in cycle:
        target[i] = source[i]

    def firstIndex(vals, parent):
      for i in parent:
        if i in vals:
          continue
        return parent.index(i)

    def cycles(parent1, parent2):
      cs, vals, idx = [], [], 0
      while len(vals) < len(parent1):
        c = cycle(idx, parent1, parent2)
        vs = cycleValues(c, parent1)
        cs.append(c)
        vals.extend(vs)
        idx = firstIndex(vals, parent1)
      return cs

    def child(cycles, parent1, parent2):
      par = parent1
      ch = ['x'] * len(parent1)
      for c in cycles:
        setCycleValues(ch, c, par)
        # switch the parent
        if par == parent1:
          par = parent2
        else:
          par = parent1
      return ch

    cycs = cycles(parent1, parent2)
    child1 = child(cycs, parent1, parent2)
    child2 = child(cycs, parent2, parent1)
    return child1, child2

  @staticmethod
  def crossoverPMX(parent1, parent2):

    def indexOf(idx, parent1, parent2, p1, p2):
      idx2 = idx
      c = 0
      while (idx2 >= p1) and (idx2 < p2) and (c<10):
        val = parent1[idx2]
        idx2 = parent2.index(val)
        c = c + 1
      return idx2

    def pmxChild(parent1, parent2, p1, p2):
      # create a child
      child = ['x'] * len(parent1)

      # copy the swath
      child[p1:p2] = parent1[p1:p2]

      # copy the missing genes from the swath
      for i in range(p1,p2):
        if parent2[i] in child:
          continue
        idx = indexOf(i, parent1, parent2, p1, p2)
        child[idx] = parent2[i]
      
      # copy the missing genes from the second parent
      for i in range( len(child) ):
        if child[i] == 'x':
          child[i] = parent2[i]
      
      return child

    p1, p2 = Permutation._swath(parent1)
    child1 = pmxChild(parent1, parent2, p1, p2)
    child2 = pmxChild(parent2, parent1, p1, p2)
    return child1, child2


class Solution(object):
  pass

class Individual(object):
  pass

class EAOpts(object):

  def __init__(self):
    self.pop_size = 20
    self.crossover_rate = 0.8
    self.mutation_rate = 0.1
    self.random_seed = random.randint(0,1000000)
    self.tournament_size = 4
    self.stop_generations = 20

class EA(object):

  def __init__(self, opts):
    self.opts = opts
    random.seed( opts.random_seed )
    self.solution()

  def reportInfo(self):
    print( '%d individuals in population' % self.opts.pop_size )
    s, c = self.crossoverNumbers()
    print( '%d new individuals created by crossover' % s )
    print( '%d best individuals copied' % c )
    m = int( self.opts.mutation_rate * self.opts.pop_size )
    print( '%d individuals mutated' % m )

  def reportFinish(self):
    print( 'Computations completed.' )
    print( 'The best solution obtained (generation %d): %4.2f' % (self.best_solution.generation, self.best_solution.value) )
    if hasattr(self.opts, 'serialize'):
      print( '%d individuals were checked.' % len(self.serialized) )

  def randomIndividual(self):
    ind = Individual()
    ind.genotype = self.opts.random_individual()
    return ind
  
  def initialPopulation(self):
    pop = []
    for i in range(self.opts.pop_size):
      pop.append( self.randomIndividual() )
    return pop

  def decode(self, genotype):
    return self.opts.decode(genotype)

  def evaluate(self, phenotype):
    return self.opts.fitness(phenotype)
  
  def evaluatedPopulation(self, pop):
    ev_pop = []
    for ind in pop:
      new_ind = Individual()
      new_ind.genotype = ind.genotype
      new_ind.phenotype = self.decode(ind.genotype)
      new_ind.fitness = self.evaluate(new_ind.phenotype)
      ev_pop.append(new_ind)

    return ev_pop

  def saveSolution(self, individual, gen_num):
    s = Solution()
    s.phenotype = individual.phenotype
    s.value = individual.fitness
    s.generation = gen_num
    self.best_solution = s

  def updateSolution(self, pop, gen_num):
    pop_sorted = sorted(pop, key = lambda x: x.fitness, reverse = True)
    if self.best_solution == None:
      self.saveSolution( pop_sorted[0], gen_num )
    else:
      if self.best_solution.value < pop_sorted[0].fitness:
        self.saveSolution( pop_sorted[0], gen_num )

  def crossoverNumbers(self):
    n = self.opts.pop_size
    s = int(round(n * self.opts.crossover_rate))
    if s % 2 == 1:
      s = s - 1
    c = n - s
    return s, c

  def selectTournament(self, pop):
    # select the tournament patricipants
    tournament_pop = []
    for i in range(self.opts.tournament_size):
      idx = random.randint(0, self.opts.pop_size-1)
      tournament_pop.append( pop[idx] )
    
    # find the winner
    tournament_pop.sort( key = lambda ind: ind.fitness, reverse = True )

    return tournament_pop[0]

  def select(self, pop):
    # the tournament selection
    return self.selectTournament(pop)
  
  def selectedPopulation(self, pop):
    new_pop = []
    s, c = self.crossoverNumbers()
    
    # selection
    for i in range(s):
      ind = self.select(pop)
      new_pop.append( ind )
    
    # copying
    std = sorted(pop, key = lambda x: x.fitness, reverse = True)
    for i in range(c):
      new_pop.append( std[i] )
    
    return new_pop

  def crossover(self, parent1, parent2):
    child1, child2 = Individual(), Individual()
    child1.genotype, child2.genotype = self.opts.crossover(parent1.genotype, parent2.genotype)
    return child1, child2

  def newPopulation(self, pop):
    s, c = self.crossoverNumbers()
    new_pop = []
    par1, par2 = None, None

    # crossover idividuals
    for i in range(self.opts.pop_size):
      if i < s:
        # prepare the parent individuals for crossover
        if par1 == None:
          par1 = pop[i]
        else:
          par2 = pop[i]

          # crossover the parents
          child1, child2 = self.crossover(par1, par2)

          new_pop.append( child1 )
          new_pop.append( child2 )
          
          par1, par2 = None, None
      else:
        # copy the individual from the old population
        new_pop.append( pop[i] )
    
    return new_pop

  def mutated(self, individual):
    individual.genotype = self.opts.mutation( individual.genotype )
    return individual

  def mutatedPopulation(self, pop):
    new_pop = []
    num = int(self.opts.pop_size * self.opts.mutation_rate)
    indices = range(self.opts.pop_size)
    random.shuffle(indices)
    indices = sorted(indices[:num], reverse = True)
    next_i = indices.pop()
    for ind, i in zip(pop, range(self.opts.pop_size)):
      if i == next_i:
        new_ind = self.mutated(ind)
      else:
        new_ind = ind
      new_pop.append(new_ind)
    return new_pop

  def stopCondition(self, pop, generation_number):
    # maximal number of generations
    if self.opts.stop_generations == generation_number:
      return True

    # no better solution found for a long time
    if hasattr(self.opts, 'stop_stagnation'):
      diff = generation_number - self.best_solution.generation
      if diff > self.opts.stop_stagnation:
        return True

    return False

  def reportBestSolution(self):
    if self.best_solution == None:
      print( "No best solution found so far." )
      return
    print( "Best solution found so far:" )
    print( "  Value: %4.2f" % self.best_solution.value )
    print( "  Generation: %d" % self.best_solution.generation )

  def reportPopulation(self, pop, gen_num):
    if not hasattr(self.opts, 'details'):
      return
    
    print( 'Generation %d' % gen_num )
    
    if self.opts.details == 'individuals':
      print( 'Individuals:' )
      for i in pop:
        gen = self.opts.str_genotype(i.genotype)
        ph  = self.opts.str_phenotype(i.phenotype)
        print( '  %s (%s) -> %4.2f' % (gen, ph, i.fitness) )
    
    self.reportBestSolution()

  def initSerialize(self):
    if hasattr(self.opts, 'serialize'):
      self.serialized = []

  def checkSerialized(self, pop):
    if not hasattr(self.opts, 'serialize'):
      return
    for ind in pop:
      serialized = self.opts.serialize(ind.genotype)
      if serialized not in self.serialized:
        self.serialized.append(serialized)

  def solution(self):
    self.initSerialize()
    pop = self.initialPopulation()
    gen_num = 0
    stop = False
    self.best_solution = None
    self.reportInfo()
    
    while not stop:
    
      gen_num += 1
    
      # evaluation
      pop = self.evaluatedPopulation(pop)
      self.checkSerialized(pop)

      # update the best solution
      self.updateSolution(pop, gen_num)

      self.reportPopulation(pop, gen_num)

      # stop conditions
      stop = self.stopCondition(pop, gen_num)
      if stop: break
    
      # selection
      pop = self.selectedPopulation(pop)
    
      # crossover
      pop = self.newPopulation(pop)
    
      # mutation
      pop = self.mutatedPopulation(pop)
    
    self.reportFinish()

