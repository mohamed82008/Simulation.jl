using Simulation
using Simulation.Units
using Unitful, Unitful.DefaultSymbols
using Distributions
using MPI
using Diversity

MPI.Init()
println(Threads.nthreads())
comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
totalsize = MPI.Comm_size(comm)

numSpecies = 1000; grid = (10, 10); req= 10.0kJ; individuals=10_000_000; area = 400_000.0*km^2; totalK = 100_000.0kJ/km^2
# Set up initial parameters for ecosystem

# Set up how much energy each species consumes
energy_vec = SolarRequirement(fill(req, numSpecies))

# Set probabilities
birth = 0.6/year
death = 0.6/year
longevity = 1.0
survival = 0.2
boost = 1.0

# Collect model parameters together
param = EqualPop(birth, death, longevity, survival, boost)

# Create kernel for movement
kernel = fill(GaussianKernel(10.0km, 10e-10), numSpecies)
movement = BirthOnlyMovement(kernel, Torus())

# Create species list, including their temperature preferences, seed abundance and native status
opts = fill(274.0K, numSpecies)
vars = fill(0.5K, numSpecies)
traits = GaussTrait(opts, vars)
native = fill(true, numSpecies)
# abun = rand(Multinomial(individuals, numSpecies))
abun = fill(div(individuals, numSpecies), numSpecies)
sppl = SpeciesList(numSpecies, traits, abun, energy_vec,
    movement, param, native)

# Create abiotic environment - even grid of one temperature
abenv = simplehabitatAE(274.0K, grid, totalK, area)

# Set relationship between species and environment (gaussian)
rel = Gauss{typeof(1.0K)}()

# Create ecosystem
eco = MPIEcosystem(sppl, abenv, rel)
q = 1.0
alphadiv = gather_diversity(eco, norm_sub_alpha, q)
if rank == 0
    print(alphadiv)
end

MPI.Finalize()
