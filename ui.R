#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(googleVis)
library(googleCharts)
source("regression_project_improved_final_ddt.R")


# Define UI for application that draws a histogram
shinyUI(fluidPage(
    googleChartsInit(),
    # Use the Google webfont "Source Sans Pro"
    tags$link(
        href=paste0("http://fonts.googleapis.com/css?",
                    "family=Source+Sans+Pro:300,600,300italic"),
        rel="stylesheet", type="text/css"),
    tags$style(type="text/css",
               "body {font-family: 'Source Sans Pro'}"
    ),
    # This line loads the Google Charts JS library
    
    # Application title
    titlePanel("Car distance predictor in miles per gallon"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            h3("Choose the X-axis"),
            selectInput("x", "X Axis", choices = c("wt", "qsec")),
            h3("Car characteristics"),
            sliderInput("weight",
                        "wt: Weight (1000 lbs)",
                        min = round(min(dfCars$wt) - 1),
                        max = round(max(dfCars$wt) + 1),
                        value = round(mean(dfCars$wt)),
                        step = .1),
            sliderInput("distance",
                        "qsec: 1/4 mile time",
                        min = round(min(dfCars$qsec) - 1),
                        max = round(max(dfCars$qsec) + 1),
                        value = mean(dfCars$qsec),
                        step = 0.1),
            selectInput("transmission",
                        "am: Transmission Type",
                        choices = c("automatic", "manual"))
            
        ),
        
        # Show a plot of the generated distribution
        mainPanel (
            tabsetPanel(
                tabPanel(title = "Prediction",
                         h3("Prediction in miles per gallon:"),
                         verbatimTextOutput("prediction"),
                         h3("mpg vs. selected X-axis"),
                         plotOutput("mygraph")),
                tabPanel(title = "Residuals",
                         plotOutput("residuals")),
                tabPanel(title = "Pairs",
                         plotOutput("pairs")),
                tabPanel(title = "Google charts",
                         htmlOutput("gchart")
                ),
                tabPanel(title = "Data",
                         fluidRow(DT::dataTableOutput("table")))
            )
        )
    )
))