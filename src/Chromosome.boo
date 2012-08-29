# Chromosome class, which will hold a representation of of the solution of our problem
import System

interface IChromosome:
    def Random() as IChromosome
    def Crossover(cr as IChromosome, probability as double) as (IChromosome)
    def Crossover(cr as IChromosome, probability as double, crossOverPoint as int) as (IChromosome)
    def Mutate(probability as double) as IChromosome

    Length as int:
        get

abstract class Chromosome[of CrType](IChromosome):
    Length as int:
        get:
            return _data.Length

    Data as (CrType):
        get:
            return _data

    # Construct a chromosome out of the data
    def constructor(data as (CrType)):
        raise ArgumentNullException("Chromosome Data") if data is null
        raise ArgumentException("Chromosome has a length of 0") if data.Length <= 0

        _data = data

    # Copy constructor
    def constructor(cr as Chromosome[of CrType]):
        copy as (CrType) = array(CrType, cr.Data)
        self(copy)

    # The data a chromosome holds is not represented by a string, but an array of a specific type
    private _data as (CrType)
    protected static _random as System.Random = System.Random()

    virtual def Random() as IChromosome:
        pass

    virtual def Mutate(probability as double) as IChromosome:
        pass

    # Returns a pair of crossovered chromosomes
    # For now, 1 crossover will be enough
    # Probability is a uniform value between [0, 1] wether to crossover or not
    protected def Crossover(cr as Chromosome[of CrType], probability as double) as ((CrType)):
        raise ArgumentNullException("Chromosome") if cr is null
        return Crossover(cr, probability, _random.Next(1, cr.Length)) # Random crossover point

    protected def Crossover(cr as Chromosome[of CrType], probability as double, crossOverPoint as int) as ((CrType)):
        raise ArgumentNullException("Chromosome") if cr is null
        raise ArgumentException("Crossover offset is not in valid range of this chromosome") if crossOverPoint >= cr.Length or crossOverPoint <= 0
        raise ArgumentException("The lengths of both chromosomes do not match up") if self.Length != cr.Length

        val as int = _random.Next(101)
        if val <= (probability * 100):  # Crossover on some chance
            return ((self.Data[:crossOverPoint] + cr.Data[crossOverPoint:]),
                    (cr.Data[:crossOverPoint] + self.Data[crossOverPoint:]))

        else:                           # No crossover, so base parent gets returned
            return (self.Data, self.Data)

    def ToString():
        return ("Chromosome[of " + Data.GetType().GetElementType().ToString() + "]")