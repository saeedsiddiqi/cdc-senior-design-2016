
# Setting up base parameters
# Model start:
param <- param.icm(inf.prob = 0.2, act.rate = 0.8, rec.rate = 1/50,
                   b.rate = 1/100, ds.rate = 1/100, di.rate = 1/90,
                   dr.rate = 1/100)

init <- init.icm(s.num = 900, i.num = 100, r.num = 0)

control <- control.icm(type = "SIR", nsteps = 300, nsims = 5)

output <- icm(param, init, control)
# Model end.

plot(output)


# Not worth the effort lol...
#allSims <- control$nsims

# S
#time <- c(0,0, 0)
#s.num <- c(0,0, 0)
#SDF <- as.data.frame(time, s.num)

#for(simIndex in (1:allSims)){
        
        # Dataframe for main-plot
        #overall.df <- as.data.frame(output)
        
        # Dataframe for all means
        #mean.df <- as.data.frame(output, out = "mean")
        
        # Dataframe for individual plots
        #sim.df <- as.data.frame(output, sim = simIndex, out = "vals")
        
        # Names of interest
        #noi <- c("s.num", "i.num", "r.num", "time", "num")
        
        #sNames <- c(noi[4], noi[1], noi[5])
        #iNames <- c(noi[4], noi[2], noi[5])
        #rNames <- c(noi[4], noi[3], noi[5])
        
        #sSim.df <- sim.df[sNames]
        #sSim.df[c("s.num")] <- sSim.df[c("s.num")] / sSim.df$num
        #finSN <- c(noi[4], noi[1])
        #sSim.df <- sSim.df[finSN]
        #DFtranspose <- cbind(t(SDF[2, ]), t(sSim.df))
        #rownames(DFtranspose) <- SDF[1, ]
        
        #iSim.df <- sim.df[iNames]
        #iSim.df[c("i.num")] <- iSim.df[c("i.num")] / iSim.df$num
        #finIN <- c(noi[4], noi[2])
        #iSim.df <- iSim.df[finIN]
        
        #rSim.df <- sim.df[rNames]
        #rSim.df[c("r.num")] <- rSim.df[c("r.num")] / rSim.df$num
        #finRN <- c(noi[4], noi[3])
        #rSim.df <- rSim.df[finRN]
        
        #sMeltdf <- melt(SDF, id="time")
        #iMeltdf <- melt(iSim.df, id="time")
        #rMeltdf <- melt(rSim.df, id="time")
        
        #ggplot(sMeltdf,aes(x=time,y=value,colour=variable,group=variable)) + geom_line()

        
#}




