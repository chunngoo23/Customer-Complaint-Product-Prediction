
library(caret)
library(shiny)
library(LiblineaR)
library(readr)
library(ggplot2)
library(reticulate)
library(keras)

#import Python packages
#py_run_string("import pandas as pd")
#py_run_string("import numpy as np")
#py_run_string("from sklearn.model_selection import train_test_split")
#py_run_string("from sklearn.feature_extraction.text import TfidfVectorizer, CountVectorizer")
#py_run_string("from sklearn.linear_model import LogisticRegression")
#py_run_string("import pickle")


#py_run_string("loaded_model = pickle.load(open(filename, 'rb'))")
#py_run_string("result = loaded_model.score(xtest_tfv, ytest)") #the input of x and y has to be already transformed
#py_run_string("print(result)")

#Load saved model
#loaded_model = py_load_object("finalized_model.pkl") 

model <- load_model_hdf5("My_model.h5")    # Load saved model
tokenizer <- load_text_tokenizer('tokenizer')
text_labels <- readRDS(file="text_labels.rds")


source("featureMapping.R")                         
#  a function for feature engineering. 
#  You can include data imputation, data manipulation, data cleaning,
#  feature transformation, etc.,  functions


shinyServer(function(input, output) {
  
  options(shiny.maxRequestSize = 800*1024^2)   
  # This is a number which specifies the maximum web request size, 
  # which serves as a size limit for file uploads. 
  # If unset, the maximum request size defaults to 5MB.
  # The value I have put here is 80MB
  
  
  output$sample_input_data_heading = renderUI({   # show only if data has been uploaded
    inFile <- input$file1
    
    if (is.null(inFile)){
      return(NULL)
    }else{
      tags$h4('Sample data')
    }
  }) #the end for sample_input_data_heading
  
  output$sample_input_data = renderTable({    # show sample of uploaded data
    inFile <- input$file1
    
    if (is.null(inFile)){
      return(NULL)
    }else{
      input_data =  readr::read_csv(input$file1$datapath, col_names = TRUE)
      
      #colnames(input_data) = c("Test1", "Test2", "Label")
      colnames(input_data) = c("CustomerComplaint", "Label")
      
      input_data$Label = as.factor(input_data$Label )
      
      #levels(input_data$Label) <- c("Failed", "Passed")
      levels(input_data$Label) <- c("Checking or savings account", "Credit card or prepaid card", "Credit reporting, credit repair services, or other personal consumer reports", "Debt collection", "Money transfer, virtual currency, or money service", "Mortgage", "Payday loan, title loan, or personal loan", "Student loan", "Vehicle loan or lease")
      head(input_data)
    }
  })
  
  
  #reactive objects, responsible for loading the data
  #where model training and predicting happens
  predictions<-reactive({
    
    inFile <- input$file1
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    
    
    if (is.null(inFile)){
      return(NULL)
    }else{
      withProgress(message = 'Predictions in progress. Please wait ...', {
        #load input data
        input_data =  readr::read_csv(input$file1$datapath, col_names = TRUE)
        #py_run_string("input_data_py = pd.read_csv(""  
        input_data = na.omit(input_data)
        #colnames(input_data) = c("Test1", "Test2", "Label")
        colnames(input_data) = c("CustomerComplaint", "Original_Product")
        
        
        input_data$Original_Product = as.factor(input_data$Original_Product)
        
        #levels(input_data$Label) <- c("Failed", "Passed")
        levels(input_data$Original_Product) <- c("Checking or savings account", "Credit card or prepaid card", "Credit reporting, credit repair services, or other personal consumer reports", "Debt collection", "Money transfer, virtual currency, or money service", "Mortgage", "Payday loan, title loan, or personal loan", "Student loan", "Vehicle loan or lease")
        
        
        
        xtest = input_data$CustomerComplaint
        ytest = input_data$Original_Product
        
        
        
        oneHot <- function(x) {
          xf <- factor(x)
          return(model.matrix(~xf+0))
          
        }
        
        
        
        #transform xtest
        x_test <- texts_to_matrix(tokenizer, xtest, mode='tfidf')
        
        
        #transform ytest
        y_test<- oneHot(ytest)
        
        #these three lines are for processing the model *****need to be revised
        
        #mapped = feature_mapping(input_data) #this is for previous person's feature engineering
        #df_final = cbind(input_data, mapped) #this is for previous person's feature engineering
        test = predict(model, x_test)
        #call out text label for preidction
        
        Predict_Labels <- c()
        for (i in 1:2000){
          Predict_Labels[i] <- text_labels[which(test[i,]==max(test[i,]))]
        }
        #the prediction demostration table
        ##py_run_string("print()")
        
        input_data_with_prediction = cbind(input_data, Predict_Labels) 
        input_data_with_prediction
        
      })
    }
  })
  
  
  #responsible for building the model, responds to the button
  #REQUIRED, as the panel that holds the result is hidden and trainResults will not react to it, this one will  
  output$sample_prediction_heading = renderUI({  # show only if data has been uploaded
    inFile <- input$file1
    
    if (is.null(inFile)){
      return(NULL)
    }else{
      tags$h4('Sample predictions')
    }
  })
  
  output$sample_predictions = renderTable({   # the last 6 rows to show
    pred = predictions()
    head(pred)
    
  })
  
  
#  output$plot_predictions = renderPlot({   # the last 6 rows to show
#    pred = predictions()
#    cols <- c("Failed" = "red","Passed" = "blue")
#    ggplot(pred, aes(x = Test1, y = Test2, color = factor(prediction))) + geom_point(size = 4, shape = 19, alpha = 0.6) +
#      scale_colour_manual(values = cols,labels = c("Failed", "Passed"),name="Test Result")
#    
#  })
  
  
  # Downloadable csv of predictions ----
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("input_data_with_predictions", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(predictions(), file, row.names = FALSE)
    })
  
})

