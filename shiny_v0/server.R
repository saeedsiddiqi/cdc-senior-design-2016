shinyServer(function(input, output) {
        
        plotVal <- eventReactive(input$replot, {
                
                param <- param.dcm(inf.prob = input$inf.prob, act.rate = input$act.rate, rec.rate = input$rec.rate)
                init <- init.dcm(s.num = input$s.num, i.num = input$i.num, r.num=input$r.num)
                
                control <- control.dcm(type = "SIR", nsteps = input$nsteps)
                mod <- dcm(param, init, control)
                # Store mod output as a dataframe
                df <- as.data.frame(mod)
                keeps <- c("s.num", "i.num", "r.num", "time")
                df <- df[keeps]
                meltdf <- melt(df, id="time")
                
        })
        
        
        output$result <- renderPlotly({
                
                # Color setting
                cols1 <- c("#ff8080", "#66b3ff")
                cols2 <- c("#ff4d4d", "#3399ff")
                
                ggplot(plotVal(),aes(x=time,y=value,colour=variable,group=variable)) + geom_line()
                ggplotly()
                
        })
        
        
        
})