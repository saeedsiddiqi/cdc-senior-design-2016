source("init/init_libraries.R")
shinyUI(navbarPage("SIR Analytical Tool V1",
                   tabPanel("DCM SIR", icon = icon("group", "fa-3x"), 
                            sidebarLayout(
                                    sidebarPanel(
                                            h2("Initialization"),
                                            
                                            fileInput('fileIO', "Choose Excel File",
                                                      accept = c('test/csv', '.xlsx','.xls','.csv',
                                                                 'text/comma-separated-values,text/plain')),
                                            conditionalPanel(
                                                    
                                                    condition = "output.initUpload",
                                                    
                                                    sliderInput("s.num", label=h5("Initial No. of Susceptable persons:"), 
                                                                min=1, max=100000, value=50000),
                                                    
                                                    sliderInput("i.num", label=h5("Initial No. of Infecteds:"), 
                                                                min=1, max=100000, value=50000),
                                                    
                                                    sliderInput("r.num", label=h5("Initial No. of Recovered persons:"), 
                                                                min=0, max=100000, value=0),
                                                    
                                                    h2("Parameters"),
                                                    p("Adjust the following parameters according to your desired output."),
                                                    
                                                    sliderInput("inf.prob", label=h5("Probability of Transmission:"),
                                                                min=0, max=1, value=0.5),
                                                    
                                                    sliderInput("act.rate", label=h5("Acts per unit time:"),
                                                                min=0, max=1, value=0.5),
                                                    
                                                    sliderInput("rec.rate", label=h5("Recoveries per unit time:"), 
                                                                min=0, max=1, value=0.5),
                                                    #### Start demographic inputs here ####
                                                    sliderInput("b.rate", label=h5("Birth rate:"), 
                                                                min=0, max=1, value=0.5),
                                                    sliderInput("ds.rate", label=h5("Mortality:"), 
                                                                min=0, max=1, value=0.5),
                                                    sliderInput("dr.rate", label=h5("Recovered mortality:"), 
                                                                min=0, max=1, value=0.5),
                                                    sliderInput("di.rate", label=h5("Disease-induced mortality:"), 
                                                                min=0, max=1, value=0.5),
                                                    sliderInput("inter.eff", label=h5("Intervention efficacy:"), 
                                                                min=0, max=1, value=0.5),
                                                    sliderInput("inter.start", label=h5("Intervention Start Time:"), 
                                                                min=1, max=200, value=0.5),
                                                    #### End demographic inputs here ####
                                                    sliderInput("nsteps", label=h5("Number of timesteps:"), 
                                                                min=1, max=200, value=100),
                                                    
                                                    actionButton("replot",icon = icon("bar-chart", "fa-3x"), label=h3("PLOT RESULTS"))
                                                    # Dev-ref: http://fontawesome.io/icons/
                                                    
                                            )),
                                    mainPanel(
                                            conditionalPanel(
                                                    plotOutput("result", height = "auto"),
                                                    h3("DCM-SIR File Inputs"),
                                                    condition = "output.initUpload",
                                                    uiOutput("tb")
                                            )
                                    )
                            ))
))
