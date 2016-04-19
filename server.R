#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(googleVis)
source("regression_project_improved_final_ddt.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    prediction <- reactive({
        new.cars <-
            data.frame(
                wt = input$weight,
                qsec = input$distance,
                am = input$transmission
            )
        prediction <- predict(fitBICI, newdata = new.cars)
    })
    
    output$prediction <- renderText({
        round(prediction(), 1)
    })
    
    output$mygraph <- renderPlot({
        ManVsAuto(dfCars, input$x, prediction())
    })
    output$residuals <- renderPlot({
        ggResid(fitBICI, dfCars)
    })
    output$pairs <- renderPlot({
        myGgpairs()
    })
    
    data <- dplyr::select(dfCars, mpg, wt, qsec)
    output$gchart <- renderGvis({
        gvisBubbleChart(dfCars,
                        idvar = "am", yvar = "mpg", xvar = "wt", 
                        sizevar = "qsec",
                        options=list(width="800px", height="500px",
                                     hAxis='{title: "weight"}',
                                     vAxis='{title: "mpg"}',
                                     explorer='{}'))
    })
    
    
    output$table <- DT::renderDataTable(DT::datatable({
        dfCars
        
    }))
    
})
