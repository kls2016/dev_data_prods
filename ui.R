#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Estimate MPG"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       numericInput("numeric", "Enter a decimal fraction for training:", 
                    value = 0.6, min = 0.6, max = 0.8, step = 0.02), 
       radioButtons("mlMethod", "ML Method: ",
                    c("Plain LM" = "LM", 
                      "Decision Trees" = "DT", 
                      "Random Forests" = "RF", 
                      "Generalized LM" = "GLM")), 
       submitButton("Submit")
   ),
    
    # Show a plot of the generated distribution
    mainPanel(
       h2("mtcars: Estimate MPG using other variables"), 
       tableOutput("table1"), 
       textOutput("text1"),
       plotOutput("plot1")
    )
  )
))

