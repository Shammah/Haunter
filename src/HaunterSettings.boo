# General structure for the settings of our genetic algorithm class
import System

class HaunterSettings:
	# The probability of a crossover to happen in percentages
	CrossoverProbability as single:
		get:
			return _crossOverProb * 100
	
		set:
			if value <= 0:
				_crossOverProb = 0
			elif value >= 100:
				_crossOverProb = 1
			else:
				_crossOverProb = value / 100

	# The probability of a mutation to happen in percentages
	MutationProbability as single:
		get:
			return _mutationProb * 100
	
		set:
			if value <= 0:
				_mutationProb = 0
			elif value >= 100:
				_mutationProb = 1
			else:
				_mutationProb = value / 100

	# The number of elitist chromosomes
	NumberOfElites as int:
		get:
			return _nElitism
	
		set:
			if value <= 0:
				_nElitism = 0
			else:
				_nElitism = value

	# The number of chromosomes in one generation
	# Only multiples of two are allowed!
	Population as int:
		get:
			return _nPopulation
	
		set:
			if value <= 2:
				_nPopulation = 2
			elif value % 2 != 0:
				_nPopulation = value + 1
			else:
				_nPopulation = value

	# The maximum number of generations to generate
	Generations as int:
		get:
			return _nGenerations
	
		set:
			if value <= 1:
				_nGenerations = 1
			else:
				_nGenerations = value

	# The length of a chromosome
	ChromosomeLength as int:
		get:
			return _nLength
	
		set:
			if value <= 1:
				_nLength = 1
			else:
				_nLength = value

	# The chromosome type
	ChromosomeType as Type:
		get:
			return _crType

		set:
			if value.GetInterface("IChromosome") is not null:
				_crType = value
			else:
				raise ArgumentException("ChromosomeType is not a valid Chromosome (does not inherit IChromosome)")

	private _crossOverProb as single = 0.8
	private _mutationProb as single = 0.05
	private _nElitism as int = 2
	private _nPopulation as int = 10
	private _nGenerations as int = 50
	private _nLength as int = 10
	private _crType as Type = BooleanChromosome