## Week 4 testing


#-----
## str
#allows a breif summary of an object

#set of 100 random numbers, w/ mean=2 and sd=4 
x <- rnorm(100, 2, 4)
summary(x)
str(x)#shows x is a numeric w/ 100 elements

#factor variable w/ 40 levels repeat 10 times
f <- gl(40,10)
str(f)

#Example of a dataframe
library(datasets)
head(airquality)
str(airquality)


#-----
## Simulation - RNG
# multiple functions for prob distributions in R, most common is the normal

# prob distributions usually have 4 functions
  # d = density
  # r = RNG
  # p = cumulative
  # q = quantile

# always set the seed when conduction simulations
# allows it to generate same random numbers again 
set.seed(1)
rnorm(5)
rnorm(5)
#resets RNG
set.seed(1)
rnorm(5)

# poisson distribution is xpois() where x is a prefix defined above


#-----
## Simulation - Simulating a Linear Model
# suppose we want to simulate the following linear model
  # y = B0 + B1x + e      where e~N(0,2^2)
  # Assumptions: x~N(0,1^2), B0 = 0.5, B1 = 2
set.seed(20)
x <- rnorm(100)
e <- rnorm(100,0,2)
y <- 0.5 + 2*x + e
summary(y)
plot(x,y)

# what if x is binary?
set.seed(10)
x <- rbinom(100, 1, 0.5)
e <- rnorm(100, 0, 2)
y <- 0.5 + 2*x + e
summary(y)
plot(x,y)

# poisson distribution
  # assume Y ~ poisson(mu)
  # log(mu) = B0 + B1x    w/ B0=0.5, B1=0.3
set.seed(1)
x <- rnorm(100)
log.mu <- 0.5 + 0.3*x
y <- rpois(100, exp(log.mu))
summary(y)
plot(x,y)


#-----
## Simulation - Random Sampling

# sample function randomly draws from a set without replacement
set.seed(1)
sample(1:10,4)
sample(1:10,4)
sample(letters,5)
sample(1:10) #permutation
sample(1:10, replace =TRUE) #sample w/ replacement


#-----
## R Profiler
  # systematic way to examine how much time is spent in parts of prgram
  # useful for optimization

  ## system.time()
    # computes the time in seconds needed to execute an expression

# DO NOT USE system.time() AND Rpof() TOGETHER

  ## Rprof()
    # used to start the profile in R
    # R must be compiled with profiler support
    # keeps track of function call stack

  ## summaryRprof()
    # tabulates the R profiler output and calculates time spent
    # 2 methods of normalizing
      # "by.total" diveds the time spent by total time
      # "by.self" first subtracts out time spent in functions above the prev

