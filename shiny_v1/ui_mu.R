
shinyUI(navbarPage("SIR Analytical Tool V1",
                   tabPanel("DCM SIR",
                            sidebarLayout(
                                    sidebarPanel(
                                            h2("Initialization"),
                                            
                                            fileInput('fileIO', "Choose Excel File",
                                                      accept = c('test/csv', '.xlsx','.xls','.csv',
                                                                 'text/comma-separated-values,text/plain')),
                                            conditionalPanel(
                                                    
                                                    condition = "output.initUpload",
                                                    
                                                    sliderInput("s.num", label=h4("Initial Population Size:"), 
                                                                min=1, max=100000, value=50000),
                                                    
                                                    sliderInput("i.num", label=h4("Initial No. of Infecteds:"), 
                                                                min=1, max=100000, value=50000),
                                                    
                                                    sliderInput("r.num", label=h4("Initial No. of Recovered persons:"), 
                                                                min=0, max=100000, value=0),
                                                    
                                                    h2("Parameters"),
                                                    p("Adjust the following parameters according to your desired output."),
                                                    
                                                    sliderInput("inf.prob", label=h4("Probability of Transmission:"),
                                                                min=0, max=1, value=0.5),
                                                    
                                                    sliderInput("act.rate", label=h4("Acts per unit time:"),
                                                                min=0, max=1, value=0.5),
                                                    
                                                    sliderInput("rec.rate", label=h4("Recoveries per unit time:"), 
                                                                min=0, max=1, value=0.5),
                                                    
                                                    sliderInput("nsteps", label=h4("Number of timesteps:"), 
                                                                min=1, max=200, value=100),
                                                    
                                                    actionButton("replot",icon = icon("signal", "fa-3x"), label=h4("PLOT RESULTS"), width = 634.6)
                                                    # Dev-ref: http://fontawesome.io/icons/
                                                    
                                            )),
                                    mainPanel(
                                            h3("DCM-SIR Results"),
                                            plotlyOutput("result",height="auto", width="100%"),
                                            conditionalPanel(
                                                    condition = "output.tb",
                                                    uiOutput("tb")
                                            )
                                    )
                            )),
                   tabPanel("ICM SIR"),
                   tabPanel("SNM SIR")
))

# Still have yet to add:
# birth rate, mortality, di-mortality, and intervention parameters

# Still have yet to add:
# birth rate, mortality, di-mortality, and intervention parameters