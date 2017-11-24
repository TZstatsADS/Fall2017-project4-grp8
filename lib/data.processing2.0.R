#######author: SijianXuan#########################
# make adject list data for webtrain and movietrain
library(recommenderlab)
webtrain = read.csv("../data/MS_sample/data_train.csv")
############################################################
nrow = sum(webtrain[,2] == 'C')
a = which(webtrain[,2] == 'C')
b = diff(a)
ncol = max(b)
web.train.matrix<-matrix(0,nrow = nrow, ncol = ncol)
####################write matrix##########################
###########################################################
web.feature<-NULL
web.featurename<-NULL
for (i in 1:dim(webtrain)[1]){
  if (webtrain[i,2] == "C"){
    web.feature = c(web.feature,webtrain[i,3])
  }
}

c = a+1
d = b
b2 = b
for(i in 2:4151){
  d[i] = b2[i] + b2[i-1]
  b2[i] = d[i]
}
d[4151] = 38026


web.train.matrix<-matrix(0,nrow = nrow, ncol = ncol)

for (x in 1:length(c)){
  for(y in 1:(d[x]-c[x]+1)){
    web.train.matrix[x,1:(d[y]-c[y]+1)] = webtrain[c[y]:d[y],3]
  }
}
length(web.feature)
rownames(web.train.matrix) = web.feature
#####################################################
save(web.train.matrix,file="../output/web.train2.0.Rdata")
