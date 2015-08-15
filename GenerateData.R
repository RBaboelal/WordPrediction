


library(RWeka)
library(tm)
library(SnowballC)
library(wordcloud)
library(qdap);


system("perl remove.pl en_US.twitter.txt en_US.twitter.txt2")
system("perl remove.pl en_US.news.txt en_US.news.txt2")
system("perl remove.pl en_US.blogs.txt en_US.blogs.txt2")

twitter_us <- readLines("en_US.twitter.txt2", encoding = "UTF-8", skipNul=TRUE)
news_us <- readLines("en_US.news.txt2", encoding = "UTF-8", skipNul=TRUE)
blogs_us <- readLines("en_US.blogs.txt2", encoding = "UTF-8", skipNul=TRUE)



#set.seed(1) #set seed
#blogs_us<- sample(blogs_us, size=1000)
#news_us<- sample(news_us, size=1000)
#twitter_us<- sample(twitter_us, size=1000)


text_all<- c(blogs_us,news_us,twitter_us)
corpus <- VCorpus(VectorSource(text_all))
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, stripWhitespace)
#corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, content_transformer(tolower)) #content transformer needed to return text doc
swearWords <- readLines("swearWords.txt") # swear word list from http://www.bannedwordlist.com/
corpus <- tm_map(corpus, removeWords, swearWords)
#corpus <- tm_map(corpus, stemDocument)



df <- data.frame( text = unlist( sapply (corpus, `[`, "content") ), stringsAsFactors=FALSE )

#ngram1 <- data.frame(table(NGramTokenizer(df, Weka_control(min = 1, max = 1))))
#colnames(ngram1) <- c("word","Freq")


ngram2 <- data.frame(table(NGramTokenizer(df, Weka_control(min = 2, max = 2))))
n2_split<-colsplit2df(as.data.frame(ngram2$Var1),sep=" ")
n2_total<-cbind(n2_split,ngram2)
colnames(n2_total)<-c("word","prediction","N2","Freq")
n2<-n2_total[order(n2_total$word, -n2_total$Freq),]
n2 <- subset(n2, select = -c(N2) )


ngram3 <- data.frame(table(NGramTokenizer(df, Weka_control(min = 3, max = 3))))
n3_split<-colsplit2df(as.data.frame(ngram3$Var1),sep=" ")
n3_split$word <- paste(n3_split$X1, n3_split$X2, sep=" ")
n3_total<-cbind(n3_split,ngram3)
names(n3_total)[names(n3_total) == 'X3'] <- 'prediction'
n3<-n3_total[order(n3_total$word, -n3_total$Freq),]
n3 <- subset(n3, select = -c(X1,X2,Var1) )


ngram4 <- data.frame(table(NGramTokenizer(df, Weka_control(min = 4, max = 4))))
n4_split<-colsplit2df(as.data.frame(ngram4$Var1),sep=" ")
n4_split$word <- paste(n4_split$X1, n4_split$X2,n4_split$X3, sep=" ")
n4_total<-cbind(n4_split,ngram4)
names(n4_total)[names(n4_total) == 'X4'] <- 'prediction'
n4<-n4_total[order(n4_total$word, -n4_total$Freq),]
n4 <- subset(n4, select = -c(X1,X2,X3,Var1) )

save(n2,n3,n4,file = 'ngrams.rda')

