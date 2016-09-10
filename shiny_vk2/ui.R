#EXAMPLE
source("init/init_libraries.R")
shinyUI(navbarPage("SIR Analytical Tool V1",
                   tabPanel("DCM SIR", icon = icon("group", "fa-3x"), 
                            sidebarLayout(
                                    sidebarPanel(
                                            h2("Initialization"),
                                            numericInput("networkSize", label=h5("Size of Network:")),
                                            sliderInput("percentMales", label=h5("% of Males"),
                                                        min=0, max=1, value=0.5),
                                            slideInput("percentWhite", label=h5("% that were of the white race"),
                                                       min=0, max=1, value=0.5),
                                            sliderInput("percentIncome10k", label=h5("% Income below USD$10K:"),
                                                        min=0, max=1, value=0.5),
                                            sliderInput("percentIncarcerated", label=h5("% of people incarcerated"),
                                                        min=0, max=1, value=0.5),
                                            
                                            numericInput("avgDegree", label=h5("Average Degree Size")),
                                            
                                            numericInput("avgEdgeDuration", label=h5("Average Edge Duration")),
                                            
                                            numericInput("nsims", label=h5("Number of simulations")),
                                            
                                            
                                            sliderInput("i.num", label=h5("Initial No. of Infecteds:"), 
                                                        min=1, max=100000, value=50000),
                                            
                                            h2("Parameters"),
                                            p("Adjust the following parameters according to your desired output."),
                                            
                                            sliderInput("inf.prob", label=h5("Probability of Transmission:"),
                                                        min=0, max=1, value=0.5),
                                            
                                            sliderInput("act.rate", label=h5("Acts per unit time:"),
                                                        min=0, max=50, value=0.5),
                                            
                                            sliderInput("inter.eff", label=h5("Intervention efficacy:"), 
                                                        min=0, max=1, value=0.5),
                                            
                                            sliderInput("inter.start", label=h5("Intervention Start Time:"), 
                                                        min=1, max=200, value=0.5),

                                            sliderInput("nsteps", label=h5("Number of timesteps:"), 
                                                        min=1, max=200, value=100),
                                            
                                            actionButton("replot",icon = icon("bar-chart", "fa-3x"), label=h3("PLOT RESULTS"))
                                    ), #end sidebarPanel
                                    
                                    mainPanel( plotOutput("result", height="auto")
                                               
                                    ) #end mainPanel
                            ) #end sidebarLayout
                   ) #end tablPanel
)) #end shinyUI