
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
    df.param <- df.param[1:9,]
    
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
    
    updateSliderInput(session, "nsims", value = model.params()$Value[9],
                      min = model.params()["Lower bound"][[1]][9], max = model.params()["Upper bound"][[1]][9])
    
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
  
  param <- reactive({
    param.icm(inf.prob = input$inf.prob, 
              act.rate = input$act.rate, 
              rec.rate = input$rec.rate,
              b.rate = input$b.rate,
              ds.rate = input$ds.rate,
              di.rate = input$di.rate,
              dr.rate = input$dr.rate)
  })
  
  init <- reactive({
    init.icm(s.num = as.numeric(input$s.num),
             i.num = as.numeric(input$i.num),
             r.num=as.numeric(input$r.num))
  })
  
  control <- reactive({
    control.icm(type = "SIR", 
                nsteps = input$nsteps, 
                nsims = input$nsims)
  })
  
  mod <- eventReactive(input$replot,{
    isolate(icm(param(), init(), control()))
  })
  
  output$result <- renderPlot({
    plot(mod(),
         mean.line = TRUE,
         sim.lines = TRUE,
         qnts = TRUE,
         leg = TRUE,
         popfrac = FALSE,
         leg.cex = 1.1,
         lwd = 3.5)
    
  }, height = function() {
    (session$clientData$output_result_width)*0.5
  })
  
  
  # Output tab
  output$Summary <- renderPrint({
          if (is.na(input$timestep)) {
                  summat <- 1
          } else {
                  summat <- input$timestep
          }
          summary(mod(),
                  at = summat)
  })
  
  # Incidence Plot
  output$incResult <- renderPlot({
          plot(mod(),
               y = "si.flow",
               popfrac = FALSE,
               mean.line = TRUE,
               sim.lines = TRUE,
               leg = TRUE,
               leg.cex = 1.1,
               lwd = 3.5)
  })
  
  output$CompartPlot <- renderPlot({
          if (is.na(input$timestep)) {
                  summat <- 1
          } else {
                  summat <- input$timestep
          }
          comp_plot(mod(),
                    at = summat)
  })
  
  
  # The following renderUI is used to dynamically generate the tabsets when the file is loaded.
  output$tb <- renderUI({
    tabsetPanel(type = "pills", 
                tabPanel("Model Output",
                         fluidRow(
                                 column(5,
                                        numericInput(inputId = "timestep",label = strong("Time Step"),
                                                     value = 1, min = 1, max = 500))
                                 ),
                         fluidRow(
                                 verbatimTextOutput(outputId = "Summary"))

                ),
                
                tabPanel("Incidence Plot",
                          fluidRow(
                                  plotOutput(outputId ="incResult")
                          )
                         ),
                
                tabPanel("Compartment Plot",
                          
                          fluidRow(
                                  plotOutput(outputId = "CompartPlot"))
                          
                          )
                )
  })
  
})

## Important links
# http://shiny.rstudio.com/reference/shiny/latest/updateSliderInput.html

