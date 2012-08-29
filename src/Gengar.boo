# Class for finding the best arguments for a genetic algorithm ... by a genetic algorithm
import System

class Gengar:
	# Our instance of the algorithm with settings and fitness function
	Algorithm as Haunter:
		get:
			return _haunter
	
		set:
			_haunter = value if value is not null

	private _haunter as Haunter

	def constructor(haunter as Haunter):
		raise ArgumentNullException("Haunter instance is null?") if haunter is null
		_haunter = haunter

	# Fitness function for our settings
	# Fitness is derived by the average fitness of the last generation
	def Fitness(cr as IChromosome) as double:
		ucr as UniformChromosome = cr cast UniformChromosome

		_haunter.Settings.CrossoverProbability 	= ucr.Data[0] * 100 # Percentage [0, 100]
		_haunter.Settings.MutationProbability 	= ucr.Data[1] * 100 # Percentage [0, 100]
		_haunter.Settings.NumberOfElites 		= ucr.Data[2] * 10  # A percentage of the population
		_haunter.Settings.Population 			= ucr.Data[2] * 100 # Population between [0, 100]
		_haunter.Settings.Generations 			= ucr.Data[3] * 100 # Number of generations [0, 100]
		
		_haunter.Run()
		return _haunter.LastGeneration.AverageFitness

	def Run():
		# Gengar's own settings
		settings as HaunterSettings = HaunterSettings()
		settings.Population = 20
		settings.Generations = 30
		settings.NumberOfElites = 3
		settings.MutationProbability = 80
		settings.CrossoverProbability = 70
		settings.ChromosomeLength = 4
		settings.ChromosomeType = typeof(UniformChromosome)

		# Run Gengar
		algorithm as Haunter = Haunter(settings, Fitness)
		algorithm.RunDebug();

		solution as UniformChromosome = algorithm.Population[0]
		bestSettings as HaunterSettings = HaunterSettings()
		bestSettings.CrossoverProbability = solution.Data[0] * 100
		bestSettings.MutationProbability = solution.Data[1] * 100
		bestSettings.NumberOfElites = solution.Data[2] * 10
		bestSettings.Population = solution.Data[2] * 100
		bestSettings.Generations = solution.Data[3] * 100
		bestSettings.ChromosomeLength = _haunter.Settings.ChromosomeLength
		bestSettings.ChromosomeType = _haunter.Settings.ChromosomeType

		print "Gengar uses Number Crunch. It's super effective!"
		print "-----------------------------------------------"
		print "Crossover Prob: \t" + bestSettings.CrossoverProbability.ToString() + "%"
		print "Mutation Prob: \t\t" + bestSettings.MutationProbability.ToString() + "%"
		print "Number of elites: \t" + bestSettings.NumberOfElites.ToString()
		print "Population: \t\t" + bestSettings.Population.ToString()
		print "Generations: \t\t" + bestSettings.Generations.ToString()
		print "Chromosome Length: \t" + bestSettings.ChromosomeLength.ToString()
		print "Chromosome Type: \t" + bestSettings.ChromosomeType.ToString()

		print "-----------------------------------------------"
		print "Possible solution: " + _haunter.Population[0].ToString()

		return bestSettings