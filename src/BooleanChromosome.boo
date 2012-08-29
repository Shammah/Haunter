# Chromosome class, which will hold a representation of of the solution of our problem
import System

# This class mutates by inverting a bit with a certain probability
class BooleanChromosome(Chromosome[of bool]):
    def constructor(data as (bool)):
        super(data);

    def constructor(length as int):
        super(RandomData(length))

    # Copy constructor
    def constructor(cr as BooleanChromosome):
        super(cr)

    # Generate a random boolean chromosome with a specific length
    static def Random(length as int) as IChromosome:
        return BooleanChromosome(RandomData(length))

    static def RandomData(length as int) as (bool):
        if length <= 0:
            raise ArgumentException("A chromosome length cannot be less or equal to 0")

        data as (bool) = array(bool, length)

        for element in data:
            val as int = _random.Next(2)
            if val == 0:
                element = false
            else:
                element = true

        return data

    # Mutates each gene of a chromosome with a certain possibility
    # Probability is a uniform value between [0, 1]
    def Mutate(probability as double):
        copy as BooleanChromosome = BooleanChromosome(self) # Create a copy that we can mutate and return

        for gene in copy.Data:
            val as int = _random.Next(100)
            if val <= (probability * 100):
                gene = not gene # Flip a bit

        return copy

    # Crossover function for our interface, which has to check between chromosome compatibility
    def Crossover(cr as IChromosome, probability as double) as (IChromosome):
        if cr isa BooleanChromosome:
            return Crossover(cr cast BooleanChromosome, probability)
        else:
            raise ArgumentException("Chromosomes cannot crossover due incompatibility: " + self.GetType() + " vs " + cr.GetType())

    def Crossover(cr as IChromosome, probability as double, crossOverPoint as int) as (IChromosome):
        if cr isa BooleanChromosome:
            return Crossover(cr cast BooleanChromosome, probability, crossOverPoint)
        else:
            raise ArgumentException("Chromosomes cannot crossover due incompatibility: " + self.GetType() + " vs " + cr.GetType())

    # Crossover function for BooleanChromosome, which returns 2 newly generated BooleanChromosomes
    def Crossover(cr as BooleanChromosome, probability as double) as (BooleanChromosome):
        data as ((bool)) = Crossover(cr as Chromosome[of bool], probability)
        children as (BooleanChromosome) = (BooleanChromosome(data[0]), BooleanChromosome(data[1]))

        return children

    def Crossover(cr as BooleanChromosome, probability as double, crossOverPoint as int) as (BooleanChromosome):
        data as ((bool)) = Crossover(cr as Chromosome[of bool], probability, crossOverPoint)
        children as (BooleanChromosome) = (BooleanChromosome(data[0]), BooleanChromosome(data[1]))

        return children

    # Converts to data to an easy recognizable and processable string
    def ToString():
        output as string

        for data in Data:
            if data == true:
                output += "1"
            else:
                output += "0"

        return output

    # Operator overloading for equality
    static def op_Equality(cr1 as BooleanChromosome, cr2 as BooleanChromosome):
        return false if (cr1 is null and cr2 is not null) or (cr1 is not null and cr2 is null)
        return false if cr1.Length != cr2.Length

        for i in range(cr1.Length):
            return false if cr1.Data[i] != cr2.Data[i]

        return true

class BooleanChromosomeTest:
    # Unit test function
    static def TestAll():
        cr as (IChromosome) = (BooleanChromosome(4), BooleanChromosome(4))

        assert cr is not null
        assert cr[0] is not null and cr[1] is not null
        assert cr[0].Length == 4 and cr[1].Length == 4

        TestCrossover(cr[0], cr[1])
        TestMutation(cr[0])
        TestString(cr[0])

        print "BooleanChromosome testing has been completed succesfully with 0 errors..."

    # We assume cr1 and cr2 are set, thus not null and have a length of 4
    static def TestCrossover(cr1 as IChromosome, cr2 as IChromosome):
        # Test crossover
        for data in (cr1 cast BooleanChromosome).Data:
            data = true

        for data in (cr2 cast BooleanChromosome).Data:
            data = false

        # Crossover with 0% probability
        crossover as (IChromosome) = cr1.Crossover(cr2, 0, 3)

        assert crossover is not null
        assert crossover[0] is not null and crossover[1] is not null
        //assert crossover[0] == BooleanChromosome((true, true, true, true))
        //assert crossover[1] == BooleanChromosome((true, true, true, true))

        for data in (crossover[0] cast BooleanChromosome).Data:
            assert data == true

        for data in (crossover[1] cast BooleanChromosome).Data:
            assert data == true

        # Crossover with 100% probability
        crossover = cr1.Crossover(cr2, 1, 3)
        crCast1 = crossover[0] cast BooleanChromosome
        crCast2 = crossover[1] cast BooleanChromosome

        assert crCast1 == BooleanChromosome((true, true, true, false))
        assert crCast2 == BooleanChromosome((false, false, false, true))

    # We assume cr is set, thus not null
    static def TestMutation(cr as BooleanChromosome):
        for data in cr.Data:
            data = true

        cr.Data[1] = false

        mutation as BooleanChromosome = cr.Mutate(0) # 0% mutation probability

        assert mutation is not null
        assert mutation == BooleanChromosome((true, false, true, true))

        mutation = cr.Mutate(1) # 100% mutation probability => inversion

        assert mutation is not null
        assert mutation == BooleanChromosome((false, true, false, false))

    # We assume cr is set and thus not null and has a length of 4
    static def TestString(cr as BooleanChromosome):
        cr.Data[0] = true
        cr.Data[1] = true
        cr.Data[2] = false
        cr.Data[3] = true

        assert cr.ToString() == "1101"