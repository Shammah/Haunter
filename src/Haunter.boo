# Our main genetic algorithm class
import System
import System.Collections.Generic

class Haunter:
	# Configuration of our genetic algorithm class with the help of a dedicated settings class
	Settings as HaunterSettings:
		get:
			return _settings

	Fitness as FitnessFunction:
		get:
			return _fitness

		set:
			raise ArgumentNullException("Fitness function is null?") if value is null
			_fitness = value

	Population as (IChromosome):
		get:
			return _population

	LastGeneration as Generation:
		get:
			raise Exception("You're asking for a last generation while the algorithm hasn't even run yet!") if _generations is null and _generations.Count > 0
			return _generations[_generations.Count - 1]

	def constructor(settings as HaunterSettings, fitness as FitnessFunction):
		raise ArgumentNullException("Haunter Settings") if settings is null
		raise ArgumentNullException("Haunter Fitness Function") if fitness is null

		_settings = settings
		Fitness = fitness

	callable FitnessFunction(cr as IChromosome) as double
	private _settings as HaunterSettings
	private _fitness as FitnessFunction
	private _population as (IChromosome)
	private _populationRanked as (KeyValuePair[of IChromosome, double])
	private _random as System.Random = System.Random()
	private _generations as List[of Generation]
	private _debug as bool = false

	def RunDebug():
		_debug = true
		Run()
		_debug = false

	def Run():
		# Create initial (random) population to start with
		CreatePopulation();
		
		for i in range(Settings.Generations):
			RankAndSort()

			# Save the elites
			elites as (IChromosome) = array(IChromosome, Settings.NumberOfElites)
			for i in range(Settings.NumberOfElites):
				elites[i] = _populationRanked[i].Key

			Generate()

			# Restore elites
			j as int = 0
			for i in range(Settings.Population - Settings.NumberOfElites, Settings.Population):
				_population[i] = elites[j]
				j++

		RankAndSort()

		if _debug:
			print "Done!"
			
	# Generate a population of random chromosomes
	private def CreatePopulation():
		# Reset our list that keeps track of our generations
		_generations = List[of Generation]()

		# Create population and set random function arguments
		_population = array(IChromosome, Settings.Population)
		randomArgs as (object) = array(object, 1)
		randomArgs[0] = Settings.ChromosomeLength

		# We have to find our random generation method!
		methods as (System.Reflection.MethodInfo) = Settings.ChromosomeType.GetMethods()
		method as System.Reflection.MethodInfo

		for func in methods:
			method = func if func.ToString() == "IChromosome Random(Int32)"

		# Generate a random chromosome with the random function we've just found to fill our starting population
		raise Exception("No static Random(Int32) function could be found for the ChromosomeType: " + Settings.ChromosomeType.ToString()) if method is null

		if _debug:
			print "Generating " + Settings.Population + " random chromosomes of type " + Settings.ChromosomeType.ToString() + " with length " + Settings.ChromosomeLength + ":"
			print "-----------------------------------------------"
		
		for chromosome in _population:
			chromosome = method.Invoke(null, randomArgs)
			print chromosome.ToString() if _debug
		
		print "-----------------------------------------------" if _debug

	# Rank all chromosomes by their fitness level in descending order
	# (IChromosome, FitnessLevel)
	private def RankAndSort():
		_populationRanked = array(KeyValuePair[of IChromosome, double], Settings.Population)

		counter as int = 0;
		for chromosome in _population:
			_populationRanked[counter] = KeyValuePair[of IChromosome, double](chromosome, Fitness(chromosome))
			counter++

		# Sort our ranked population by descending order of the fitness level
		Array.Sort(_populationRanked, { cr1, cr2 | return -cr1.Value.CompareTo(cr2.Value) })

		# Calculate the total fitness
		totalFitness as double = 0
		for chromosome in _populationRanked:
			totalFitness += chromosome.Value

		# Calculate the average fitness
		averageFitness as double = totalFitness / Settings.Population

		# Get the best fitness
		bestFitness as double = 0
		Array.ForEach(_populationRanked, { cr | bestFitness = cr.Value if cr.Value > bestFitness})

		_generations.Add(Generation(totalFitness, averageFitness, bestFitness))

		if _debug:
			print "Parsing generation #" + (_generations.Count - 1)
			print "Total \tFitness: " + _generations[_generations.Count - 1].TotalFitness
			print "Average Fitness: " + _generations[_generations.Count - 1].AverageFitness
			print "Best \tFitness: " + _generations[_generations.Count - 1].BestFitness
			print "-----------------------------------------------"

	# Create a new generation!
	private def Generate():
		# Set up our roulette wheel!
		totalFitness as double = _generations[_generations.Count - 1].TotalFitness
		rand as double = 0
		acc as double = 0
		parents as (IChromosome) = array(IChromosome, 2)

		for i in range(0, Settings.Population - Settings.NumberOfElites, 2):
			# Find two parents using the roulette wheel method
			for j in range(2):
				rand = _random.NextDouble()

				for chromosome in _populationRanked:
					acc += chromosome.Value

					if acc / totalFitness >= rand:
						parents[j] = chromosome.Key
						acc = 0
						break # We have found a good parent, stop looking further!

			# Create two children of the two parents found
			children as (IChromosome) = parents[0].Crossover(parents[1], Settings.CrossoverProbability / 100)
			children[0].Mutate(Settings.MutationProbability / 100)
			children[1].Mutate(Settings.MutationProbability / 100)

			# Add to the population if possible
			_population[i] = children[0] if i < _population.Length
			_population[i + 1] = children[1] if i + 1 < _population.Length
		