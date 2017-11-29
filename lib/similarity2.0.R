library(entropy)


###################data processing######################
web.train<-read.csv("../data/web.train2.0.csv")
movie.train<-read.csv("../data/movie.train2.0.csv")


web.user<-web.train[,1]
web.feature<-unique(unlist(web.train[,-1]))
web.feature<-feature[!is.na(feature)]
length(web.feature)


movie.user<-movie.train[,1]
movie.feature<-colnames(movie.train[,-1])

dataprocess<-function(data,feature=web.feature){

  data<-data[,-1]
  
  #movie
  if(ncol(data)>1600){
    data[is.na(data)]<-0
    matrix<-as.matrix(data)
    
  }else{
    #web
    #feature<-unique(unlist(data))
    #feature<-feature[!is.na(feature)]
    
    matrix<-matrix(0,nrow=nrow(data),ncol=length(feature))
    colnames(matrix)<-feature
    
    for(i in 1:nrow(data)){
      for(j in 1:length(feature)){
        matrix[i,j]<-ifelse(feature[j]%in%data[i,],1,0)
      }
    }
    
  }
  return(matrix)
}

web.train.matrix<-dataprocess(web.train)
movie.train.matrix<-dataprocess(movie.train)

web.train.matrix<-cbind(web.user,web.train.matrix)
dim(web.train.matrix)
save(web.train.matrix,file="~/Desktop/Proj4/web.train.matrix.Rdata")
mv.train.matrix<-movie.train
dim(mv.train.matrix)
save(mv.train.matrix,file="~/Desktop/Proj4/mv.train.matrix.Rdata")

#####

web.test<-read.csv("~/Desktop/Proj4/web.test2.0.csv")
movie.test<-read.csv("~/Desktop/Proj4/movie.test2.0.csv")

web.test.matrix<-dataprocess(web.test)
web.test.user<-web.test[,1]
web.test.matrix<-cbind(web.test.user,web.test.matrix)
save(web.test.matrix,file="~/Desktop/Proj4/web.test.matrix.Rdata")

mv.test.matrix<-movie.test[,-1]
save(mv.test.matrix,file="~/Desktop/Proj4/mv.test.matrix.Rdata")


idx<-match(web.test.user,web.user)

#MOVIE
MAE<-function(pred,test){
   #idx<-match(colnames(movie.test.matrix),colnames(movie.train.matrix))
  test<-test[,-1]
  #pred<-pred[,-1]
  test[test==0]<-NA
  #idx<-match(colnames(test),colnames(mv.train.matrix[,-1]))
  colnames(pred)<-colnames(mv.train.matrix[,-1])
  idx<-match(colnames(test),colnames(pred))
  mae<-mean(abs(test-pred[,idx]),na.rm=T)
  return(mae)
}
MAE(mv.msd.p,mv.test.matrix)
######################function###############
getSpearman <- function(x,y) 
{
  return(cor(x,y,method="spearman"))
}


getEntropy <- function(x,y) 
{
  library(entropy)
  x[x==0]<-0.000001
  y[y==0]<-0.000001
  etp <- KL.empirical(x,y)
  return(etp)
}

getMSD <- function(x,y) 
{
  msd <- mean((x-y)^2)
  return(msd)
}

########################form matrix of web#################
d<-nrow(web.train.matrix)
web.sp.similarity<-matrix(NA,ncol=d,nrow=d)
web.entropy.similarity<-matrix(NA,ncol=d,nrow=d)
web.msd.similarity<-matrix(NA,ncol=d,nrow=d)

for(i in 1:d) {
  for(j in ((i+1):d)){
    #web.sp.similarity[i,j]= getSpearman(web.train.matrix[i,],web.train.matrix[j,])
    web.entropy.similarity[i,j]= getEntropy(web.train.matrix[i,],web.train.matrix[j,])
    web.msd.similarity[i,j]= getMSD(web.train.matrix[i,],web.train.matrix[j,])
  }
  print(i)
}

makesymmetric<-function(data){
  data[!upper.tri(data)] <- 0
  data.f<-data+t(data)
  #diag(data.f)<-1
  return(data.f)
}

# covertdis<-fucntion(data){
#   return(1-(data/max(as.vector(data))))
# }

#web.sp.sim<-makesymmetric(web.sp.similarity) 
#diag(web.sp.sim)<-1
#colnames(web.sp.sim)<-web.train[1,]
web.sp.sim<-cor(t(web.train.matrix), t(web.train.matrix),method="spearman")
save(web.sp.sim,file="~/Desktop/Proj4/web.sp.sim.Rdata")

web.entropy.sim<-makesymmetric(web.entropy.similarity)
web.etp.sim<-1-(web.entropy.sim/max(web.entropy.sim))
save(web.etp.sim,file="~/Desktop/Proj4/web.etp.sim.Rdata")

web.msd.sim<-makesymmetric(web.msd.similarity)
web.msdiff.sim<-1-(web.msd.sim/max(web.msd.sim))
save(web.msdiff.sim,file="~/Desktop/Proj4/web.msdiff.sim.Rdata")

#################form matrix of movie##############
d2<-nrow(movie.train.matrix)
mv.sp.similarity<-matrix(NA,ncol=d2,nrow=d2)
mv.entropy.similarity<-matrix(NA,ncol=d2,nrow=d2)
mv.msd.similarity<-matrix(NA,ncol=d2,nrow=d2)

mv.sp.sim<-cor(t(movie.train.matrix), t(movie.train.matrix),method="spearman")
save(mv.sp.sim,file="~/Desktop/Proj4/mv.sp.sim.Rdata")

for(k in (1:d2-1)) {
  for(l in ((k+1):d2)){
    #mv.sp.similarity[i,j]= getSpearman(movie.train.matrix[i,],movie.train.matrix[j,])
    mv.entropy.similarity[k,l]= getEntropy(movie.train.matrix[k,],movie.train.matrix[l,])
    mv.msd.similarity[k,l]= getMSD(movie.train.matrix[k,],movie.train.matrix[l,])
  }
  print(k)
}

mv.entropy.sim<-makesymmetric(mv.entropy.similarity)
mv.etp.sim<-1-(mv.entropy.sim/max(mv.entropy.sim))
save(mv.etp.sim,file="~/Desktop/Proj4/mv.etp.sim.Rdata")

mv.msd.sim<-makesymmetric(mv.msd.similarity)
mv.msdiff.sim<-1-(mv.msd.sim/max(mv.msd.sim))
save(mv.msdiff.sim,file="~/Desktop/Proj4/mv.msdiff.sim.Rdata")


