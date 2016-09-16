
#####################################################
#       Make sure to source dependencies first!     #
#                        DW                         #
#####################################################

source("init/init_libraries.R")

shinyServer(function(input, output, session) {
        
        # This reactive function will take the inputs from UI.R and use them for read.table() to read the data from the file.
        # file$datapath -> gives the path of the file
        
        
        ##Epidemic Simulation
        param <- reactive({
          param.net(inf.prob = input$inf.prob,
                    act.rate = input$act.rate,
                    inter.start = input$inter.start,
                    inter.eff = input$inter.eff)
        })
        init <- reactive({
          init.net(i.num = input$i.num,
                   status.rand = TRUE)
        })
        control <- reactive({
          control.net(type = "SI",
                      nsims = input$nsims,
                      nsteps = input$nsteps,
                      verbose = FALSE)
        })
        
        
        # Running SIR EpiModel
        plotVal <- eventReactive(input$replot, {
                
                avgEdges <- (input$networkSize*input$avgDegree)/2
                
                #create network object 
                nw <- network.initialize(n=input$networkSize, directed=FALSE)
                
                #sets gender attribute for nodes
                nw <- set.vertex.attribute(nw, "Gender", sample(c(0,1),size=input$networkSize,
                                                                prob=c(1-input$percentMales,input$percentMales),replace=TRUE))
                #sets race attribute for nodes
                

                nw <- set.vertex.attribute(nw, "Race", sample(c(0,1),size=input$networkSize,
                                                              prob=c(1-input$percentWhite,input$percentWhite),replace=TRUE))

                #sets income attribute for nodes
                nw <- set.vertex.attribute(nw, "Income", rbinom(0:1, input$networkSize, input$percentIncome10k))
                
                print("hahahahaha")
                #sets incarceration attribut for nodes
                nw <- set.vertex.attribute(nw, "Incarceration", sample(c(0,1),size=input$networkSize,
                                                                       prob=c(1-input$percentIncarcerated,input$percentIncarcerated),replace=TRUE))
                
                print("hahahahaha")
                
                #formation formula
                formation <- ~edges
                
                #target stats 
                target.stats <- c(avgEdges)
                
                #edge dissolution
                #edge duration same for all partnerships 
                coef.diss <- dissolution_coefs(~offset(edges), input$avgEdgeDuration)
                
                #fit the model 
                modelFit <- netest(nw, formation, target.stats, coef.diss)
                #use to check for significants of parameters in formation formula
                #summary(modelFit)
                
                #model diagnostics 
                diagnositcs <- netdx(modelFit, nsims = input$nsims, nsteps =input$nsteps)
                
                # might need to add prevalance here
                sim <- netsim(modelFit, param(), init(), control())
                
                
        })
        
        output$result <- renderPlot({
          
          par(mfrow = c(1,2), mar = c(0,0,1,0))
          plot(plotVal(), type = "network", at = 1, col.status = TRUE,
               main = "Prevalence at t1")
          plot(plotVal(), type = "network", at = 100, col.status = TRUE,
               main = "Prevalence at t500")
                
                
        }, height = function() {
                (session$clientData$output_result_width)*0.5
        })
        
        
})

## Important links
# http://shiny.rstudio.com/reference/shiny/latest/updateSliderInput.html
