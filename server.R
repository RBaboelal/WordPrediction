library(shiny)
library(stringr)

load('ngrams.rda')

find2 <- function(prevwords){
  #n2rows <-grep(paste0("(^|\\s)",prevwords,"$"), n2$word)
  n2rows <-grep(paste0("^",prevwords,"$"), n2$word)
  if(sum(n2rows) > 0 )
  {
    n2result <-n2[n2rows,]
    return(n2result[ 1, which(names(n2result) %in% c("prediction"))])
  } else {
    return("the")
  }    
}

find3 <- function(prevwords){
  n3rows <-grep(paste0("^",prevwords,"$"), n3$word)
  if(sum(n3rows) > 0 )
  {
    n3result <-n3[n3rows,]
    return(n3result[ 1, which(names(n3result) %in% c("prediction"))])
  } else {
    prevwords<-gsub("^\\S+\\s", "", prevwords)
    return(find2(prevwords))
  }    
}

find4 <- function(prevwords){
  n4rows <-grep(paste0("^",prevwords,"$"), n4$word)
  if(sum(n4rows) > 0 )
  {
    n4result <-n4[n4rows,]
    return(n4result[ 1, which(names(n4result) %in% c("prediction"))])
  } else {
    prevwords<-gsub("^\\S+\\s", "", prevwords)
    return(find3(prevwords))
  }    
}

predict <- function(prevwords){
  #cleanup the words here
  prevwords<-str_replace_all(prevwords, "[^[:alnum:]]", " ")
  prevwords<-gsub("\\d+", "", prevwords)
  prevwords<-gsub("\\s+$", "", prevwords)
  prevwords<-tolower(prevwords)
    
  numwords<-length(strsplit(prevwords, " ")[[1]])
  if(numwords > 3){
    words<-strsplit(prevwords, " ")[[1]]
    words<-words[(length(words) - 2):length(words)]
    prevwords<-paste(words, collapse=' ' )
    res<-find4(prevwords)
  } else if (numwords == 3){
    res<-find4(prevwords)
  } else if (numwords == 2){
    res<-find3(prevwords)
  } else if (numwords == 1){
    res<-find2(prevwords)
  } else {
    res=""
  }    
  return(res)
}

shinyServer(function(input, output) {
  output$osentence <- reactive({predict(input$sentence)})
  output$otherwords <- renderPrint({n2[1,1]})
})