using Distributions

# Function to sample randomly from the Exponential distribution
function jexp(theta, n::Int64=1)
  rand(Exponential(theta), n)
end

# Function to sample randomly from the Poisson distribution
function jpois(gamma, n::Int64=1)
  rand(Poisson(gamma), n)
end

# Function to sample randomly from the Binomial distribution
function jbinom(n::Int64, size::Int64, p::Real)
  rand(Binomial(size,p), n)
end

# Function to sample randomly from the Multinomial distribution
function jmulti(n::Int64, p::AbstractArray)
  rand(Multinomial(n, p))
end
function jmulti(n::Int64,size::Int64, p::Real)
  rand(Multinomial(size, repmat([p], n)))
end


# Function to sample randomly from the Uniform distribution
function junif(a,b)
  rand(Uniform(a,b))
end

# Function to sample randomly from the Dirichlet distribution
function jdir(k,a)
  rand(Dirichlet(k,a))
end

# Function to sample randomly from the Normal distribution
function jnorm(μ,σ,n::Int=1)
  rand(Normal(μ,σ),n)
end

function tnorm(μ, σ, l = 0, u = 1, n::Int = 1)
  rand(Truncated(Normal(μ, σ), l, u), n)
end
