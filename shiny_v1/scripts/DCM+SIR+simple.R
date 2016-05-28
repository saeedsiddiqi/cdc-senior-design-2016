
source("init/init_libraries.R")
# inf.prob = transmission probability per act
# init.dcm = initial conditions
# controls = type of model etc...

param <- param.dcm(inf.prob = 0.2, act.rate = 0.25, rec.rate = 0.10)

init <- init.dcm(s.num = 1000, i.num = 1, r.num=0)

control <- control.dcm(type = "SIR", nsteps = 10)

# Wrap around all model parameters with dcm
mod <- dcm(param, init, control)
### Below for plotting:

# Store mod output as a dataframe
df <- as.data.frame(mod)

#plot(mod, main = "Prevalence vs. Time")

keeps <- c("s.num", "i.num", "r.num", "num", "time")

df <- df[keeps]
percDF <- df
percDF[c("s.num","r.num","i.num")] <- df[c("s.num", "r.num", "i.num")] / df$num
finalPrevNames <- c("s.num", "r.num", "i.num", "time")
finalPrevDF <- percDF[finalPrevNames]

# Melt dataframe for graphing purposes
meltdf <- melt(finalPrevDF, id="time")
names(meltdf)[1] <- paste("Time")
names(meltdf)[3] <- paste("Prevalence")

# Color setting
cols1 <- c("#ff8080", "#66b3ff")
cols2 <- c("#ff4d4d", "#3399ff")

ggplot(meltdf,aes(x=Time,y=Prevalence,colour=variable,group=variable)) + geom_line()

ggplotly()
