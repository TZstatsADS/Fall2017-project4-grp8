library(recommenderlab)
library(entropy)
#install.packages("rrecsys")

load("~/Desktop/Proj4/web.train.Rdata")
load("~/Desktop/Proj4/web.test.Rdata")
load("~/Desktop/Proj4/movie.train.Rdata")
load("~/Desktop/Proj4/movie.test.Rdata")


#####################Similarity Weight########################

#############similarity#################
getSpearman <- function(x,y) 
{
  #x<-as.vector(as(x,"matrix")*1)
  #y<-as.vector(as(y,"matrix")*1)
  return(cor(x,y,method="spearman"))
}

getSpearman(web.train[1,],web.train[2,])


getEntropy <- function(x,y) 
{
  library(entropy)
  x[x==0]<-0.000001
  y[y==0]<-0.000001
  etp <- KL.empirical(x,y)
  return(etp)
}

getEntropy(web.train[1,],web.test[2,])

getMSD <- function(x,y) 
{
  msd <- sum((x-y)^2) / length(x)
  return(msd)
}

getMSD(web.train[1,],web.test[2,])


##########predictive########

p.ubcf<-function(train,test,sim){
  
  p <- matrix(NA, nrow = nrow(test), ncol = ncol(test))
  
  for (a in 1:nrow(p)){
    for(i in 1:ncol(p)){
      w<-apply(train,1,sim,test[a,]) #1*37211
      p[a,i] <- mean(test[a,-i]) + sum((train[,i]-apply(train,1,mean)) * w) / sum(w)
    }
  }
  return(p)
}


########test case############
web.pd.sp<-p.ubcf(web.train[1:30,],web.test[1:10,],getSpearman)
web.pd.etp<-p.ubcf(web.train[1:30,],web.test[1:10,],getEntropy)
web.pd.msd<-p.ubcf(web.train[1:30,],web.test[1:10,],getMSD)

# web.train[web.train==0]<-NA
# web.train[web.test==0]<-NA
# web.pd.sp.t<-p.ubcf(web.train[1:30,],web.test[1:10,],getSpearman)


movie.train.t<-as(movie.train,"matrix")
movie.test.t<-as(movie.test,"matrix")
movie.pd.sp<-p.ubcf(movie.train.t[1:30,],movie.test.t[1:10,],getSpearman)
movie.pd.etp<-p.ubcf(movie.train.t[1:10,],movie.test.t[1:5,],getEntropy)
movie.pd.msd<-p.ubcf(movie.train.t[1:10,],movie.test.t[1:5,],getMSD)





#################################ignore#################

  
  #ignore below
  #case of recommenderlab
  #simlarity matrix
  
  
#################################
library(rrecsys)
load("~/Desktop/Proj4/eachmovie.matrix.Rdata")

web.matrix<-as(rbind(web.test,web.train),"binaryRatingMatrix")
web.train.matrix<-as(web.train,"binaryRatingMatrix")
web.test.matrix<-as(web.test,"binaryRatingMatrix")

movie.train.matrix<- as(movie.train,"realRatingMatrix")
movie.test.matrix <-as(movie.test,"realRatingMatrix")

######similarity########
u.sp.similarity<-matrix(NA,ncol=32711,nrow=32711)
u.entropy.similarity<-matrix(NA,ncol=32711,nrow=32711)
u.msd.similarity<-matrix(NA,ncol=32711,nrow=32711)

for(i in 1:nrow(web.train)) {
  for(j in 1:nrow(web.train)) {
    u.sp.similarity[i,j]= getSpearman(web.train[i,],web.train[j,])
    u.entropy.similarity[i,j]= getEntropy(web.train[i,],web.train[j,])
    u.msd.similarity[i,j]= getMSD(web.train[i,],web.train[j,])
  }
}


#r <- rrecsys(defineData(web.train), alg = "UBKNN", simFunct = getSpearman, neigh = 5)
####
web.e <- evaluationScheme(
  web.matrix,
  method='split',
  train=0.8,
  k=1,
  given=-1)

web.e

web.rc.sp <- Recommender(
  data=getData(web.e,"train"),
  method='UBCF',             # User-Based Collaborative Filtering
  parameter=list(
    method=getSpearman,      
    nn=50,                  # number of Nearest Neighbors for calibration
    weighted=F
  ))

# web.rc.sp <- Recommender(
#   data=getData(web.e,"train"),
#   method='UBCF')   

web.sp.pd <- predict(
  object=web.rc.sp,
  newdata=getData(web.e,"known"),
  type="topNList",
  n=1)

web.sp.acc <- calcPredictionAccuracy(
  web.sp.pd,
  getData(web.e,"unknown"),
  given=-1)

web.sp.acc <- sum(
  web.sp.pd-
  getData(evaluation_scheme,"unknown"))

####

web.rc.entropy <- Recommender(
  data=web.train.matrix,
  method='UBCF',           # User-Based Collaborative Filtering
  parameter=list(
    method=getEntropy,      # use Pearson correlation
    nn=199,                # number of Nearest Neighbors for calibration
    weighted=F
  ))
getModel(web.rc.entropy)


web.rc.msd <- Recommender(
  data=web.train.matrix,
  method='UBCF',           # User-Based Collaborative Filtering
  parameter=list(
    method=getMSD,      # use Pearson correlation
    nn=199,                # number of Nearest Neighbors for calibration
    wegited=F
  ))


web.msd.pd <- predict(
  web.rc.msd,
  web.test.matrix,
  type='ratings')



######item-based########
# i.sp.similarity<-matrix(0,ncol=294,nrow=294)
# i.entropy.similarity<-matrix(0,ncol=294,nrow=294)
# i.msd.similarity<-matrix(0,ncol=294,nrow=294)
# 
# for(i in 1:ncol(web.train.matrix)) {
#   for(j in 1:ncol(data.germany.ibs)) {
#     i.sp.similarity[i,j]= getSpearman(web.train.matrix[,i],web.train.matrix[,j])
#     i.entropy.similarity[i,j]= getEntropy(web.train.matrix[,i],web.train.matrix[,j])
#     i.msd.similarity[i,j]= getMSD(web.train.matrix[,i],web.train.matrix[,j])
#   }
# }