#install.packages("recommenderlab")
library(recommenderlab)

###########Train of MSWeb##############
#should be 372711*294
line <- readLines("~/Desktop/proj4/anonymous-msweb.data.txt")
length(line)

web.feature<-NULL
web.featurename<-NULL
for( i in 1:length(line)){
   eachline= line[[i]]
   
  if(grepl('^A',eachline)){
    web.feature<-c(web.feature,unlist(strsplit(eachline, ","))[2])
    web.featurename<-c(web.featurename,unlist(strsplit(eachline, ","))[4])
    }
}
length(web.feature)

web.train<-matrix(0,ncol=294,nrow=32711)
case=0

for( i in 1:length(line)){
  eachline= line[[i]]
  
  if(grepl('^C',eachline)){
    case=case+1
  }
  
  if(grepl('^V',eachline)){
    visit=unlist(strsplit(eachline, ","))[2]
    idx=which(web.feature == visit) 
    web.train[case,idx]=1
  }
}
  
colnames(web.train)<-web.feature
save(web.train,file="~/Desktop/Proj4/web.train.Rdata")


###############Test of MSWeb##############
#should be 5000*294
line <- readLines("~/Desktop/proj4/anonymous-msweb.test.txt")
web.test<-matrix(0,ncol=294,nrow=5000)
case=0

for( i in 1:length(line)){
  eachline= line[[i]]
  
  if(grepl('^C',eachline)){
    case=case+1
  }
  
  if(grepl('^V',eachline)){
    visit=unlist(strsplit(eachline, ","))[2]
    idx=which(web.feature == visit) 
    web.test[case,idx]=1
  }
}

colnames(web.test)<-web.feature
save(web.test,file="~/Desktop/Proj4/web.test.Rdata")

web.train.matrix<-as(web.train,"binaryRatingMatrix")
web.test.matrix<-as(web.test,"binaryRatingMatrix")

#colnames(web.train.matrix)<-web.feature
#colnames(web.train.matrix)<-web.feature




######################eachmovie data clean########################
eachmovie<-read.table("~/Desktop/proj4/eachmovie_triple",col.names = c("movie","user","rate"))
dim(eachmovie)
range(eachmovie$movie)
range(eachmovie$user)
range(eachmovie$rate)

eachmovie.matrix<-matrix(0,ncol=1648,nrow=74424)

#library(reshape)
#eachmoive.matrix <- cast(eachmovie, user ~ movie, value = "rate")

for(i in 1: nrow(eachmovie)){
  colno= eachmovie[i,1]
  rowno= eachmovie[i,2]
  rating=eachmovie[i,3]
  eachmovie.matrix[rowno,colno]=rating
}
eachmovie.matrix[74424,1584]
save(eachmovie.matrix,file="~/Desktop/Proj4/eachmovie.matrix.Rdata")

set.seed(42)
n<-nrow(eachmovie.matrix)
K <- 5
folds <- sample(rep(1:K, each = n/K))
movie.train<-eachmovie.matrix[folds!=1,]
movie.test<-eachmovie.matrix[folds==1,]

save(movie.train,file="~/Desktop/Proj4/movie.train.Rdata")
save(movie.test,file="~/Desktop/Proj4/movie.test.Rdata")

moive.train.matrix<- as(eachmovie.matrix,"realRatingMatrix")
moive.test.matrix <-as(eachmovie.matrix,"realRatingMatrix")


# evaluation_scheme <- evaluationScheme(
#   eachmovie.matrix.t, 
#   method='split',
#   train=0.8,
#   k=1,
#   given=-1)
# 
# evaluation_scheme


