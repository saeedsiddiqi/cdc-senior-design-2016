
#####################################################
#       Make sure to source dependencies first!     #
#                        DW                         #
#####################################################

source("init/init_libraries.R")

shinyServer(function(input, output, session) {
        
        # This reactive function will take the inputs from UI.R and use them for read.table() to read the data from the file.
        # file$datapath -> gives the path of the file
        
        
        # Model initializers
        model.init <- reactive({
                
                #XLSX house keeping
                inFile <- input$fileIO
                
                if(is.null(inFile))
                        return(NULL)
                
                ext <- tools::file_ext(inFile$name)
                
                file.rename(inFile$datapath,
                            paste(inFile$datapath, ext, sep="."))
                
                # Reading in data 
                df.init <- read_excel(paste(inFile$datapath, ext, sep="."), 2)
                
                # Subsetting to columns that are needed
                df.init <- df.init[,2:length(names(df.init))]
                df.init <- df.init[1:3,]
        })
        
        
        # Model parameters
        model.params <- reactive({
                
                inFile <- input$fileIO
                
                if(is.null(inFile))
                        return(NULL)
                
                ext <- tools::file_ext(inFile$name)
                
                file.rename(inFile$datapath,
                            paste(inFile$datapath, ext, sep="."))
                
                # Reading in data 
                df.param <- read_excel(paste(inFile$datapath, ext, sep="."), 3)
                df.param <- df.param[,2:length(names(df.param))]
                df.param <- df.param[1:8,]
                
        })
        
        # Model intervention
        model.inter <- reactive({
                
                inFile <- input$fileIO
                
                if(is.null(inFile))
                        return(NULL)
                
                ext <- tools::file_ext(inFile$name)
                
                file.rename(inFile$datapath,
                            paste(inFile$datapath, ext, sep="."))
                
                # Reading in data 
                df.inter <- read_excel(paste(inFile$datapath, ext, sep="."), 4)
                df.inter <- df.inter[,2:length(names(df.inter))]
                df.inter <- df.inter[1:2,]
                
        })
        
        # Update all of the sliders according to CSV inputs
        observe({
                # START INIT
                updateSliderInput(session, "s.num", value = model.init()$Value[1],
                                  min = model.init()["Lower bound"][[1]][1], max = model.init()["Upper bound"][[1]][1])
                
                updateSliderInput(session, "i.num", value = model.init()$Value[2],
                                  min = model.init()["Lower bound"][[1]][2], max = model.init()["Upper bound"][[1]][2])
                
                updateSliderInput(session, "r.num", value = model.init()$Value[3],
                                  min = model.init()["Lower bound"][[1]][3], max = model.init()["Upper bound"][[1]][3])
                # START PARAMS
                updateSliderInput(session, "inf.prob", value = model.params()$Value[1],
                                  min = model.params()["Lower bound"][[1]][1], max = model.params()["Upper bound"][[1]][1])
                
                updateSliderInput(session, "act.rate", value = model.params()$Value[2],
                                  min = model.params()["Lower bound"][[1]][2], max = model.params()["Upper bound"][[1]][2])
                
                updateSliderInput(session, "b.rate", value = model.params()$Value[3],
                                  min = model.params()["Lower bound"][[1]][3], max = model.params()["Upper bound"][[1]][3])
                
                updateSliderInput(session, "ds.rate", value = model.params()$Value[4],
                                  min = model.params()["Lower bound"][[1]][4], max = model.params()["Upper bound"][[1]][4])
                
                updateSliderInput(session, "dr.rate", value = model.params()$Value[5],
                                  min = model.params()["Lower bound"][[1]][5], max = model.params()["Upper bound"][[1]][5])
                
                updateSliderInput(session, "di.rate", value = model.params()$Value[6],
                                  min = model.params()["Lower bound"][[1]][6], max = model.params()["Upper bound"][[1]][6])
                
                updateSliderInput(session, "rec.rate", value = model.params()$Value[7],
                                  min = model.params()["Lower bound"][[1]][7], max = model.params()["Upper bound"][[1]][7])
                
                updateSliderInput(session, "nsteps", value = model.params()$Value[8],
                                  min = model.params()["Lower bound"][[1]][8], max = model.params()["Upper bound"][[1]][8])
                
                # START INTER
                updateSliderInput(session, "inter.eff", value = model.inter()$Value[1],
                                  min = model.inter()["Lower bound"][[1]][1], max = model.inter()["Upper bound"][[1]][1])
                
                updateSliderInput(session, "inter.start", value = model.inter()$Value[2],
                                  min = model.inter()["Lower bound"][[1]][2], max = model.inter()["Upper bound"][[1]][2])
                
        })
        
        
        output$initUpload <- reactive({
                return(!is.null(model.init()))
        })
        
        outputOptions(output, 'initUpload', suspendWhenHidden=FALSE)
        
        output$paramsUpload <- reactive({
                return(!is.null(model.params()))
        })

        # Outputs the table
        output$tableinit <- renderTable({
                if(is.null(model.init())){return ()}
                model.init()
        })
        

        output$tableparams <- renderTable({
                if(is.null(model.params())){return ()}
                model.params()
        })
        
        # Running SIR EpiModel
        plotVal <- eventReactive(input$replot, {
                
                param <- param.dcm(inf.prob = input$inf.prob, 
                                   act.rate = input$act.rate, 
                                   rec.rate = input$rec.rate,
                                   b.rate = input$b.rate,
                                   ds.rate = input$ds.rate,
                                   di.rate = input$di.rate,
                                   dr.rate = input$dr.rate,
                                   inter.eff = input$inter.eff,
                                   inter.start = input$inter.start)
                
                init <- init.dcm(s.num = input$s.num, i.num = input$i.num, r.num=input$r.num)
                
                control <- control.dcm(type = "SIR", nsteps = input$nsteps)
                mod <- dcm(param, init, control)
                
                ### Old - for interactive visualization
                # Store mod output as a dataframe
                # df <- as.data.frame(mod)
                # keeps <- c("s.num", "i.num", "r.num", "num", "time")
                
                # Create subset of dataframe with percentages of population
                # df <- df[keeps]
                # percDF <- df
                # percDF[c("s.num","r.num","i.num")] <- df[c("s.num", "r.num", "i.num")] / df$num
                # finalPrevNames <- c("s.num", "r.num", "i.num", "time")
                # finalPrevDF <- percDF[finalPrevNames]
                
                # meltdf <- melt(finalPrevDF, id="time")
                
        })
        
        # Plotting the output with plot_ly
        output$result <- renderPlot({
                plot(plotVal())
                
                ### Old - for interactive visualization
                #plot <- ggplot(plotVal(),aes(x=time,y=value,colour=variable,group=variable)) 
                #plot <- plot + geom_line(size=1, alpha=0.6)
                #plot <- plot + theme(panel.background = element_rect(fill='white', colour="red"),
                #                     axis.title.x = element_text(colour = "black"),
                #                     axis.title.y = element_text(colour = "black", angle=45),
                #                     panel.grid.major = element_line(colour = "gray91"))
                #ggplotly(plot)
                
        }, height = function() {
                (session$clientData$output_result_width)*0.5
        })
        

        # The following renderUI is used to dynamically generate the tabsets when the file is loaded.
        output$tb <- renderUI({
                tabsetPanel(type = "pills", tabPanel("Initial Parameters", tableOutput("tableinit")),
                            tabPanel("Epidemoelogical Parameters", tableOutput("tableparams")))
        })

})

## Important links
# http://shiny.rstudio.com/reference/shiny/latest/updateSliderInput.html
        

