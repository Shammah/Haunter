# Chromosome class, which will hold a representation of of the solution of our problem
import System

# This class mutates by changing the position of two integers with a certain probability
class IntegerChromosome(Chromosome[of int]):
    def constructor(data as (int)):
        super(data);

    def constructor(length as int):
        super(RandomData(length))

    # Copy constructor
    def constructor(cr as IntegerChromosome):
        super(cr)

    # Generate a random boolean chromosome with a specific length
    static def Random(length as int) as IChromosome:
        return IntegerChromosome(RandomData(length))

    static def RandomData(length as int) as (int):
        if length <= 0:
            raise ArgumentException("A chromosome length cannot be less or equal to 0")

        data as (int) = array(int, length)

        for element in data:
            element = _random.Next()

        return data

    # Mutates each gene of a chromosome with a certain possibility
    # Probability is a uniform value between [0, 1]
    def Mutate(probability as double):
        copy as IntegerChromosome = IntegerChromosome(self) # Create a copy that we can mutate and return

        for gene in copy.Data:
            val as int = _random.Next(100)
            if val <= (probability * 100):
                val = _random.Next(Length)
                temp as int = gene
                gene = copy.Data[val] # Swap integer locations
                copy.Data[val] = temp # ^^^^^^^^^^^^^^^^^^^^^^

        return copy

    # Crossover function for our interface, which has to check between chromosome compatibility
    def Crossover(cr as IChromosome, probability as double) as (IChromosome):
        if cr isa IntegerChromosome:
            return Crossover(cr cast IntegerChromosome, probability)
        else:
            raise ArgumentException("Chromosomes cannot crossover due incompatibility: " + self.GetType() + " vs " + cr.GetType())

    def Crossover(cr as IChromosome, probability as double, crossOverPoint as int) as (IChromosome):
        if cr isa IntegerChromosome:
            return Crossover(cr cast IntegerChromosome, probability, crossOverPoint)
        else:
            raise ArgumentException("Chromosomes cannot crossover due incompatibility: " + self.GetType() + " vs " + cr.GetType())

    # Crossover function for IntegerChromosome, which returns 2 newly generated IntegerChromosomes
    def Crossover(cr as IntegerChromosome, probability as double) as (IntegerChromosome):
        data as ((int)) = Crossover(cr as Chromosome[of int], probability)
        children as (IntegerChromosome) = (IntegerChromosome(data[0]), IntegerChromosome(data[1]))

        return children

    def Crossover(cr as IntegerChromosome, probability as double, crossOverPoint as int) as (IntegerChromosome):
        data as ((int)) = Crossover(cr as Chromosome[of int], probability, crossOverPoint)
        children as (IntegerChromosome) = (IntegerChromosome(data[0]), IntegerChromosome(data[1]))

        return children

    # Converts to data to an easy recognizable and processable string
    def ToString():
        output as string = "|"

        for data in Data:
            output += data.ToString() + "|"

        return output

    # Operator overloading for equality
    static def op_Equality(cr1 as IntegerChromosome, cr2 as IntegerChromosome):
        return false if (cr1 is null and cr2 is not null) or (cr1 is not null and cr2 is null)
        return false if cr1.Length != cr2.Length

        for i in range(cr1.Length):
            return false if cr1.Data[i] != cr2.Data[i]

        return true