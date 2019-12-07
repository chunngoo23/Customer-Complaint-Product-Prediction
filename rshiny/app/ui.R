
packages_to_use <- c("shiny", "shinydashboard","shinythemes")


install_load <- function(packages){
  to_install <- packages[!(packages %in% installed.packages()[, "Package"])] # identify unavailable packages
  
  if (length(to_install)){  # install unavailable packages 
    install.packages(to_install, repos='http://cran.us.r-project.org', dependencies = TRUE)  # install those that have not yet been installed
  }
  
  for(package in packages){  # load all of the packges 
    suppressMessages(library(package, character.only = TRUE))
  }
}

install_load(packages_to_use) 

dashboardPage(skin="black",
              dashboardHeader(title=tags$em("Customer Complaint Product Prediction App", style="text-align:center;color:#006600;font-size:200%"),titleWidth = 1600),
              
              dashboardSidebar(width = 250,
                               sidebarMenu(
                                 br(),
                                 menuItem(tags$em("Upload Test Data",style="font-size:120%"),icon=icon("upload"),tabName="data"),
                                 menuItem(tags$em("Download Predictions",style="font-size:120%"),icon=icon("download"),tabName="download")
                                 
                                 
                                 )
                                 ),
              
              dashboardBody(
                tabItems(
                  tabItem(tabName="data",
                           
                          
                          br(),
                          br(),
                          br(),
                          br(),
                          tags$h4("With this shiny prediction app, you can upload your customer complaint data and get back product predictions.
                                  The model is a Logistic Regression that predicts which specific financial product is the customer complaining 
                                  While assigning customer complaint to the accurate department efficiently is tasking and acquire human labor 
                                  in understanding, this Natural Language Processing Model eliminate the manual time needed for judgment. 
                                .", style="font-size:150%"),
                        
                        
                      br(),

                      tags$h4("To predict using this model, upload test data in csv format (you can change the code to read other data types) by using the button below.", style="font-size:150%"),
                      
                      tags$h4("Then, go to the", tags$span("Download Predictions",style="color:red"),
                              tags$span("section in the sidebar to  download the predictions."), style="font-size:150%"),
                      
                          br(),
                          br(),
                          br(),
                      column(width = 4,
                             fileInput('file1', em('Upload test data in csv format ',style="text-align:center;color:blue;font-size:150%"),multiple = FALSE,
                                       accept=c('.csv')),
                             
                             uiOutput("sample_input_data_heading"),
                             tableOutput("sample_input_data"),
                          
                          
                          br(),
                           br(),
                           br(),
                          br()
                          ),
                          br()
                          
                        ),
                  
                  
                  tabItem(tabName="download",
                          fluidRow(
                            br(),
                            br(),
                            br(),
                            br(),
                            column(width = 8,
                            tags$h4("After you upload a test dataset, you can download the predictions in csv format by
                                    clicking the button below.", 
                                    style="font-size:200%"),
                            br(),
                            br()
                            )),
                          fluidRow(
                            
                            column(width = 7,
                            downloadButton("downloadData", em('Download Predictions',style="text-align:center;color:blue;font-size:150%")),
                            plotOutput('plot_predictions')
                            ),
                            column(width = 4,
                            uiOutput("sample_prediction_heading"),
                            tableOutput("sample_predictions")
                            )
                              
                            ))
                          )))
         























