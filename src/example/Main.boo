import System

// Fitness is the total amount of 1's in a boolean string
def Fitness1(cr as IChromosome) as double:
	bcr as BooleanChromosome = cr cast BooleanChromosome
	sum as double = 0;

	for boolean in bcr.Data:
		if boolean == true:
			sum++

	return sum

// Find the closest number to 24434
def Fitness24434(cr as IChromosome) as double:
	bcr as BooleanChromosome = cr cast BooleanChromosome
	number as int = Convert.ToInt32(bcr.ToString(), 2)

	result = Math.Abs(24434 - number)

	return Int16.MaxValue - result

// Solve the knapsack problem
def FitnessSack(cr as IChromosome) as double:
	bcr as BooleanChromosome = cr cast BooleanChromosome
	sum as int = 0
	counter as int = 0;

	sack as (int) = (1, 3, 7, 3, 6, 8, 5, 4, 6, 8, 3, 1, 4, 5, 2, 3, 1, 3, 7, 3, 6, 8, 5, 4, 6, 8, 3, 1, 4, 5, 2, 3, 1, 3, 7, 3, 6, 8, 5, 4, 6, 8, 3, 1, 4, 5, 2, 3, 1, 3, 7, 3, 6, 8, 5, 4, 6, 8, 3, 1, 4, 5, 2, 3)
	weight = 275

	for boolean in bcr.Data:
		if boolean == true:
			sum += sack[counter]

		counter++

	return Int16.MaxValue - Math.Abs(weight - sum)

def Main():
	settings as HaunterSettings = HaunterSettings()
	settings.ChromosomeLength = 32
	settings.ChromosomeType = typeof(BooleanChromosome)

	algorithm as Haunter = Haunter(settings, Fitness1)
	//algorithm.Run()
	//solution as BooleanChromosome = algorithm.Population[0]
	//print solution.ToString()

	// Generate the best Haunter settings / parameters for our fitness function
	gengar as Gengar = Gengar(algorithm)
	gengar.Run()