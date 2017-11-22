###########Train of MSWeb##############
data_train <- read.csv("~/Downloads/data_sample/MS_sample/data_train.csv",header=TRUE)

### consumer --> product 
max<-matrix(NA,nrow = 4151,ncol=285)
vec<-data_train[1,]$V2
c<-1

for ( i in 2:nrow(data_train)){
    if(data_train[i,]$V1=="C"){
    diff<-285-length(vec)
    vec<-c(vec,rep(NA,diff))
    max[c,]<-vec
    c<-c+1
    vec<-data_train[i,]$V2
  }
  if (data_train[i,]$V1=="V"){
    vec<-c(vec,data_train[i,]$V2)
    vec
  }
}
max<-as.data.frame(max)

write.csv(max,"~/Downloads/data_sample/MS_sample/relationship1.csv")





line <- readLines("~/Desktop/project4/mswebdata.txt")
### get original feature names 
web.feature<-NULL
web.featurename<-NULL
for( i in 1:length(line)){
  eachline= line[[i]]
  if(grepl('^A',eachline)){
    web.feature<-c(web.feature,unlist(strsplit(eachline, ","))[2])
    web.featurename<-c(web.featurename,unlist(strsplit(eachline, ","))[4])
  }
}

#### construct matrix 
web.train<-matrix(0,ncol=294,nrow=4151)
case=0

for( i in 2:nrow(data_train)){
  if(data_train[i,]$V1=="C"){
    case=case+1
  }
  
  if(data_train[i,]$V1=="V"){
    visit=data_train[i,]$V2
    idx=which(web.feature == visit) 
    web.train[case,idx]=1
  }
}
colnames(web.train)<-web.feature
#### delete features not in sample data 
web.train<-web.train[, colSums(web.train != 0) > 0]
rownames(web.train)<-max[,1]

###produce product --> consumer 
web.train.tran<-t(web.train)

# dim(web.train.tran)
web.link2<-matrix(NA,nrow = 269,ncol=4151)
rownames(web.link2)<-rownames(web.train.tran)
for ( i in 1: 269){
  for (j in 1:4151){
    if(web.train.tran[i,j] == 1){
      web.link2[i,j]<-colnames(web.train.tran)[j]
    }
  }
}
# dim(web.link2)
web2<-matrix(NA,nrow = 269,ncol=4151)
for (i in 1:269){
  web<- sort(web.link2[i,])
  diff<-4151-length(web)
  web2[i,]<-c(web,rep(NA,diff))
}

prodtopeo<-cbind(rownames(web.link2),web2)
write.csv(prodtopeo,"~/Downloads/data_sample/MS_sample/relationship2.csv",na="")
