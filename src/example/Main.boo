# Testing stuff :D
import System

// Fitness is the total amount of 1's in a boolean string
def FitnessLol(cr as IChromosome) as double:
	bcr as BooleanChromosome = cr cast BooleanChromosome
	sum as double = 0;

	for boolean in bcr.Data:
		if boolean == true:
			sum++

	return sum

def Main():
	settings as HaunterSettings = HaunterSettings()
	settings.ChromosomeLength = 32
	settings.ChromosomeType = typeof(BooleanChromosome)

	algorithm as Haunter = Haunter(settings, FitnessLol)
	//algorithm.Run()
	//solution as BooleanChromosome = algorithm.Population[0]
	//print solution.ToString()

	// Generate the best Haunter settings / parameters for our fitness function
	gengar as Gengar = Gengar(algorithm)
	gengar.Run()