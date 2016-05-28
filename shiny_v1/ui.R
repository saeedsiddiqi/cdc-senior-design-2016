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
                                                    
                                                    sliderInput("s.num", label=h4("Initial No. of Susceptable persons:"), 
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
                                                    #### Start demographic inputs here ####
                                                    sliderInput("b.rate", label=h4("Birth rate:"), 
                                                                min=0, max=1, value=0.5),
                                                    sliderInput("ds.rate", label=h4("Mortality:"), 
                                                                min=0, max=1, value=0.5),
                                                    sliderInput("dr.rate", label=h4("Recovered mortality:"), 
                                                                min=0, max=1, value=0.5),
                                                    sliderInput("di.rate", label=h4("Disease-induced mortality:"), 
                                                                min=0, max=1, value=0.5),
                                                    sliderInput("inter.eff", label=h4("Intervention efficacy:"), 
                                                                min=0, max=1, value=0.5),
                                                    sliderInput("inter.start", label=h4("Intervention Start Time:"), 
                                                                min=1, max=200, value=0.5),
                                                    #### End demographic inputs here ####
                                                    sliderInput("nsteps", label=h4("Number of timesteps:"), 
                                                                min=1, max=200, value=100),
                                                    
                                                    actionButton("replot",icon = icon("spinner", "fa-spin"), label=h4("PLOT RESULTS"), width = 634.6)
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
                   tabPanel("ICM SIR" , icon = icon("user", "fa-3x")),
                   tabPanel("SNM SIR" , icon = icon("arrows-alt", "fa-3x"))
))

# Still have yet to add:
# birth rate, mortality, di-mortality, and intervention parameters