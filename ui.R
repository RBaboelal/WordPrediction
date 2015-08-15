library(shiny)
library(shinythemes)
# ui.R



shinyUI(fluidPage(
  headerPanel("Coursera Capstone - Next word prediction"),  
  

  
  sidebarPanel(width=4,
               h6("This prediction app uses 4gram models with backoff to predict the next word of the sentence being typed."),
               h6("You can type your sentence in below text field."),
               hr(),
      h4("Enter an English sentence:"),
      textInput("sentence" , label="")
      
  ),
    

    
  mainPanel(width=8,
            tabsetPanel(
              tabPanel("Prediction",
                       hr(),
                       h6("The predicted word is the most probable word based on frequencies observed in a specific corpus."),
                       h6("The corpus used is based on blogs, news and twitter messages, and can be found at the Coursera Data Science website."),                       
                       h4("The predicted word is:"),
                       hr(),
                       verbatimTextOutput("osentence")), 
              tabPanel("Instructions", 
                       
                h6("Simply enter the first part of a sentence in the first text box. In the example below you can see 'How are' being filled in."),
                img(src = "Input.JPG")  ,
                h6("The result will be displayed in the second text box. In this case 'you' is displayed."),       
                img(src = "output.JPG")  ,
                h6("Note that you are allowed to type in numbers and special characters, however these will be skipped in the evaluation!")       
              ), 
              tabPanel("Model & data", 
                       hr(),
                       h4("Data"),
                       h6("The training data is downloaded from the Data Science Capstone course on Coursera."),
                       h6("The following link will guide you to the syllabus of the course where the data can be found in section 'Course dataset'."),
                       a("Coursera Data Science Capstone website.", href="https://class.coursera.org/dsscapstone-004/wiki/syllabus"),
                       h6("The data consists of news articles, blogs and tweets. In total more than 6 millions lines of text."),
                       hr(),
                       h4("Model"),
                       h6("The model is a 4gram model with a simple backoff. In case the 4gram is not found, the 3gram is used. Then the 2 gram, etc."),
                       h6("Given the size of the corpus, a subset (1%) of the data has only been used")
                       
                       
              )
            
            )
          

               
  )
  
))