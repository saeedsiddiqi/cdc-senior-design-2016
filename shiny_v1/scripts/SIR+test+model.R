
# David Wang
# 5/21/2016
# SIR Test Model
# Resources used: [statnet sir day 1, R-cookbook]
library(ggplot2)
library(plotly)
library(reshape2)

num=1000
init.inum=1
num.timesteps=10
act.rate=35
tprob=0.70
rec.rate=0.10

# create individuals
ids <- 1:num

# assign status
# make "num" amount of s-states
status <- rep("s", num)

# make "init.num" amount of i-states
status[sample(ids, size=init.inum)] <- "i"

prevTrack <- vector("numeric")
indTrack <- vector("numeric")
recovTrack <- vector("numeric")
susTrack <- vector("numeric")

#print(table(status))

# create time
step = 1
while (step <= num.timesteps) {
        
        # transmission
        # calculate number of acts: n acts per timestep
        acts <- round(act.rate)
        
        # take the number of acts and acquire samples of 2 elements (in pairs)
        element <- t( replicate(acts, sample(1:num, 2)) )
        
        # limit edgelist to discordant pairs (pairs that will get an element infected)
        
        # find SI and IS pairs' boolean values
        discordant <- (status[element[,1]] == "i" & status[element[,2]] == "s") |
                (status[element[,1]] == "s" & status[element[,2]] == "i")
        
        # use above to filter pairs-matrix
        del <- element[discordant == TRUE, ]
        
        # which of the discordants are selected to become infected?
        trans <- rbinom(nrow(del),1, tprob)
        
        # do bookkeeping for transmissions
        del <- del[trans == TRUE, ]
        
        susIds <- ifelse(status[del[,1]] == "s", del[,1], del[,2])
        
        newInfIds <- susIds[trans == 1]
        
        # update
        status[newInfIds] <- "i"
        
        # recovery implementation
        # outputs ids of those infected
        idsElig <- which(status =="i")
        
        # length of eligible recovery elements
        nElig <- length(idsElig)
        
        # gives us the indices of nElig that manage to recover
        vecRecov <- which(rbinom(nElig,1,rec.rate) == 1)
        
        # change status indices accordingly
        if (length(vecRecov) > 0) {
                idsRecov <- idsElig[vecRecov]
                nRecov <- length(idsRecov)
                status[idsRecov] <- "r"
        }
        
        print(table(status))
        
        prevalence <- sum(status=="i")
        
        prevTrack <- append(prevTrack, prevalence)
        
        incidence <- length(newInfIds)
        indTrack <- append(indTrack, incidence)
        
        recovery <- sum(status=="r")
        recovTrack <- append(recovTrack, recovery)
        
        suscept <- sum(status == "s")
        susTrack <- append(susTrack, suscept)
        
        step = step + 1
        
}

# visual analytics portion

# Create dataframe with results
PREVALENCE <- prevTrack
INCIDENCE <- indTrack
TIMESTEP <- 1:num.timesteps
RECOVERY <- recovTrack
SUSCEPTABLE <- susTrack
results.df <- data.frame(PREVALENCE, INCIDENCE, RECOVERY, SUSCEPTABLE, TIMESTEP)

# Reshape data frame for easier graphing
meltdf <- melt(results.df, id="TIMESTEP")


cols1 <- c("#ff8080", "#66b3ff")
cols2 <- c("#ff4d4d", "#3399ff")
ggplot(meltdf,aes(x=TIMESTEP,y=value,colour=variable,group=variable)) + geom_line()

ggplotly()







