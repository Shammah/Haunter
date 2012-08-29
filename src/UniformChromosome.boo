# Chromosome class, which will hold a representation of of the solution of our problem
import System

# This chromosome holds its data as floating point values in the range [0, 1]
# This class mutates by increasing or decreasing a number by n in [-0.05; 0.05] with a probability p
class UniformChromosome(Chromosome[of single]):
    def constructor(data as (single)):
        super(data);

    def constructor(length as int):
        super(RandomData(length))

    # Copy constructor
    def constructor(cr as UniformChromosome):
        super(cr)

    # Generate a random Uniform chromosome with a specific length
    static def Random(length as int) as IChromosome:
        return UniformChromosome(RandomData(length))

    static def RandomData(length as int) as (single):
        if length <= 0:
            raise ArgumentException("A chromosome length cannot be less or equal to 0")

        data as (single) = array(single, length)

        for element in data:
            element = _random.NextDouble()

        return data

    # Mutates each gene of a chromosome with a certain possibility
    # Probability is a uniform value between [0, 1]
    def Mutate(probability as double):
        copy as UniformChromosome = UniformChromosome(self) # Create a copy that we can mutate and return

        for gene in copy.Data:
            val as int = _random.Next(100)
            if val <= (probability * 100):
                gene = _random.NextDouble() % 0.05
                if _random.NextDouble() < 0.5:
                    gene = -gene

        return copy

    # Crossover function for our interface, which has to check between chromosome compatibility
    def Crossover(cr as IChromosome, probability as double) as (IChromosome):
        if cr isa UniformChromosome:
            return Crossover(cr cast UniformChromosome, probability)
        else:
            raise ArgumentException("Chromosomes cannot crossover due incompatibility: " + self.GetType() + " vs " + cr.GetType())

    def Crossover(cr as IChromosome, probability as double, crossOverPoint as int) as (IChromosome):
        if cr isa UniformChromosome:
            return Crossover(cr cast UniformChromosome, probability, crossOverPoint)
        else:
            raise ArgumentException("Chromosomes cannot crossover due incompatibility: " + self.GetType() + " vs " + cr.GetType())

    # Crossover function for UniformChromosome, which returns 2 newly generated UniformChromosomes
    def Crossover(cr as UniformChromosome, probability as double) as (UniformChromosome):
        data as ((single)) = Crossover(cr as Chromosome[of single], probability)
        children as (UniformChromosome) = (UniformChromosome(data[0]), UniformChromosome(data[1]))

        return children

    def Crossover(cr as UniformChromosome, probability as double, crossOverPoint as int) as (UniformChromosome):
        data as ((single)) = Crossover(cr as Chromosome[of single], probability, crossOverPoint)
        children as (UniformChromosome) = (UniformChromosome(data[0]), UniformChromosome(data[1]))

        return children

    # Converts to data to an easy recognizable and processable string
    def ToString():
        output as string = "|"

        for data in Data:
            output += data.ToString() + "|"

        return output

    # Operator overloading for equality
    static def op_Equality(cr1 as UniformChromosome, cr2 as UniformChromosome):
        return false if (cr1 is null and cr2 is not null) or (cr1 is not null and cr2 is null)
        return false if cr1.Length != cr2.Length

        for i in range(cr1.Length):
            return false if cr1.Data[i] != cr2.Data[i]

        return true