
source("init/init_libraries.R")
shinyUI(navbarPage("SIR Analytical Tool V1",
                   tabPanel("ICM SIR", 
                            sidebarLayout(
                              sidebarPanel(
                                h2("Initialization"),
                                
                                fileInput('fileIO', "Choose Excel File",
                                          accept = c('test/csv', '.xlsx','.xls','.csv',
                                                     'text/comma-separated-values,text/plain')),
                                conditionalPanel(
                                  
                                  condition = "output.initUpload",
                                  
                                  sliderInput("s.num", label="Initial No. of Susceptable persons:", 
                                              min=0, max=100000, value=1000),
                                  
                                  sliderInput("i.num", label="Initial No. of Infecteds:", 
                                              min=0, max=100000, value=1),
                                  
                                  sliderInput("r.num", label="Initial No. of Recovered persons:", 
                                              min=0, max=100000, value=0),
                                  
                                  h2("Parameters"),
                                  p("Adjust the following parameters according to your desired output."),
                                  
                                  sliderInput("inf.prob", label="Probability of Transmission Per Act:",
                                              min=0, max=1, value=0.5),
                                  
                                  sliderInput("act.rate", label="Acts per unit time:",
                                              min=0, max=1, value=0.5),
                                  
                                  sliderInput("rec.rate", label="Recoveries per unit time:", 
                                              min=0, max=1, value=0.5),
                                  #### Start demographic inputs here ####
                                  sliderInput("b.rate", label="Birth rate:", 
                                              min=0, max=1, value=0.5),
                                  sliderInput("ds.rate", label="Mortality:", 
                                              min=0, max=1, value=0.5),
                                  sliderInput("dr.rate", label="Recovered mortality:", 
                                              min=0, max=1, value=0.5),
                                  sliderInput("di.rate", label="Disease-induced mortality:", 
                                              min=0, max=1, value=0.5),
                                  #### End demographic inputs here ####
                                  sliderInput("nsteps", label="Number of timesteps:", 
                                              min=1, max=200, value=100),
                                  sliderInput("nsims", label="Number of simulations:",
                                              min=1, max=10, value=3),
                                  
                                  actionButton("replot", label=h3("RUN MODEL"))
                                  # Dev-ref: http://fontawesome.io/icons/
                                  
                                )),
                              mainPanel(
                                plotOutput(outputId = "result", height = "auto"),
                                conditionalPanel(
                                  h3("Model Summary"),
                                  condition = "output.initUpload",
                                  uiOutput("tb")
                                )
                              )
                            ))
))
