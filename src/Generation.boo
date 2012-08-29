# Class that holds statistics for one generation
import System

class Generation:
	# The total fitness of a generation
	TotalFitness as double:
		get:
			return _totalFitness

	# The avera fitness of a generation
	AverageFitness as double:
		get:
			return _averageFitness

	# The best fitness of a generation
	BestFitness as double:
		get:
			return _bestFitness

	def constructor(tf as double, af as double, bf as double):
		_totalFitness = tf
		_averageFitness = af
		_bestFitness = bf

	private _totalFitness as double
	private _averageFitness as double
	private _bestFitness as double