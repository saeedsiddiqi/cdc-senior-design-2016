source("init/init_libraries.R")

# Create 1000 nodes without directed edges
nw <- network.initialize(n = 1000,
                         directed = FALSE)

# Set 500 nodes as race_0 and another 500 nodes as race_1
nw <- set.vertex.attribute(nw, "race", rep(0:1, each = 500))

formation <- ~edges + nodefactor("race") + nodematch("race") + concurrent

n <- 1000 # total nodes
n.half <- n/2
no.expected.edges <- 0.5 * n.half # mean deg. of 0.50 for nodes
stat.race1 <- 0.75 * n.half # mean deg. of 0.75 for Race 1
no.sameRace.edges <- 0.90 * no.expected.edges
no.concurrent <- 0.10 * n

target.stats <- c(no.expected.edges,
                  stat.race1,
                  no.sameRace.edges,
                  no.concurrent)

# Dissolution coeff. for partnership duration
coef.diss <- dissolution_coefs(dissolution = ~offset(edges), duration = 25)

# Estimated generative model for dynamic partnership networks
est1 <- netest(nw, formation, target.stats, coef.diss, edapprox = TRUE)

# Begin simulations & then compare results (dynamic model diagnostics)
dx <- netdx(est1, nsims = 5, nsteps = 500,
            nwstats.formula = ~edges + nodefactor("race", base = 0) + #setting base=0 in nodefactor means gen. results for Race0
                    nodematch("race") + concurrent)

# Diagnostic plots
par(mfrow = c(1, 2))
plot(dx, type = "duration")
plot(dx, type = "dissolution")
plot(dx)

# Simulating Epidemic 
param <- param.net(inf.prob = 0.1, act.rate = 5, rec.rate = 0.02)

# Generate status vector (1000 nodes) with binary indicators
status.vector <- c(rbinom(500, 1, 0.1), rep(0, 500))

# Convert binary to status string
status.vector <- ifelse(status.vector == 1, "i", "s")

# Initialize
init <- init.net(status.vector = status.vector)

control <- control.net(type = "SIR", nsteps = 500, nsims = 10, epi.by = "race")
                       
sim1 <- netsim(est1, param, init, control)







