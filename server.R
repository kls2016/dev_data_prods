#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
library(randomForest)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  data(mtcars)
  mtcars1 <- sapply(mtcars, as.numeric)
  mtcars1 <- as.data.frame(mtcars1)
  getTable <- reactive({
    set.seed(1234)
    trainingFraction <- input$numeric
    carsPartition <- createDataPartition(y = mtcars1$mpg, p = 0.7, list = FALSE)
    
    training <- mtcars1[carsPartition, ]
    validCars <- mtcars1[-carsPartition, ]
    
    predMethod <- switch(input$mlMethod, 
                         LM = "lm", 
                         DT = "rpart", 
                         RF = "rf",  
                         GLM = "glm", 
                         "rf")
    if(predMethod == "rf")
      fit <- randomForest(mpg ~ ., data = training)
    else
      fit <- train(mpg ~ ., data = training, method = predMethod)
    
    predMpg <- predict(fit, newdata = validCars)

    validCars$cyl <- as.factor(validCars$cyl)
    print(class(validCars$cyl))
    compareVals <- cbind(validCars$mpg, predMpg, validCars$cyl, validCars$disp)
    compareVals <- data.frame(compareVals)
    colnames(compareVals) <- c("mpg", "PredMpg", "cyl", "disp")
#    print(compareVals)
    compareVals$cyl <- as.factor(compareVals$cyl)
    print(class(compareVals$cyl))
    compareVals   
#    print(length(predMpg))
#    print(length(validCars$mpg))
#    print(dim(compareVals))
#    mse <- sum((predMpg - validCars$mpg)^2)/length(predMpg)
#    print(prtVal)
    
  })
  output$table1 <- renderTable({
    predTable <- getTable()
    predTable
  })
  output$text1 <- renderText({
    predTable2 <- getTable()
    predMethod <- switch(input$mlMethod, 
                         LM = "LINEAR MODEL", 
                         DT = "DECISION TREE", 
                         RF = "RANDOM FOREST",  
                         GLM = "GENERALIZED LM", 
                         "rf")
    mse <- sum((predTable2$mpg - predTable2$PredMpg)^2)/length(predTable2$mpg)
    prtVal <- paste("Method = ", predMethod, " ========> Mean Squared Error = ", mse, sep = ' ')
    print(prtVal)
  })
  
  output$plot1 <- renderPlot({
    predTable3 <- getTable()
    print(class(predTable3$cyl))
    predMethod <- switch(input$mlMethod, 
                         LM = "LINEAR MODEL", 
                         DT = "DECISION TREE", 
                         RF = "RANDOM FOREST",  
                         GLM = "GENERALIZED LM", 
                         "rf")
    print(" ")
    strVal <- paste0("\n Indicative Plot of mpg vs disp for ", predMethod)
    g <- ggplot(predTable3, aes(x = mpg, y = disp))
    g <- g + geom_point(aes(color = cyl))
    g <- g + geom_point(aes(PredMpg, disp))
    g <- g + geom_line(aes(PredMpg, disp), color = "red")
    g <- g + annotate("text", x = 25.55, y = 450, label = "Red Line indicates Predicted mpg", fontface = "bold", color = "blue")
    g <- g + annotate("text", x = 25.75, y = 470, label = "Coloured Points indicate actual mpg", fontface = "bold", color = "brown")
    g <- g + ggtitle(strVal)
    print(g)
  })
})
  
