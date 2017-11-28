#######author: SijianXuan#########################
# make adject list data for webtrain and movietrain
library(recommenderlab)
################ web train ##########################
webtrain = read.csv("../data/MS_sample/data_train.csv")
webtest =read.csv("../data/MS_sample/data_test.csv")
############################################################处理webtrain
nrow = sum(webtrain[,2] == 'C')
a = which(webtrain[,2] == 'C')
b = diff(a)
ncol = max(b)
###########################################################处理webtest
nrow =sum(webtest[,2] == 'C')
a = which(webtest[,2] =='C')
b = diff(a)
ncol = max(b)
####################write webtrain matrix##########################
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
for(i in 2:nrow){
  d[i] = b2[i] + b2[i-1]
  b2[i] = d[i]
}
d[nrow] = dim(webtrain)[1]


web.train.matrix<-matrix(NA,nrow = nrow, ncol = ncol)

for (x in 1:length(c)){
  for(y in 1:(d[x]-c[x]+1)){
    web.train.matrix[x,1:(d[y]-c[y]+1)] = webtrain[c[y]:d[y],3]
  }
}
length(web.feature)
rownames(web.train.matrix) = web.feature
#####################################################
save(web.train.matrix,file="../output/web.train2.0.Rdata")
write.csv(web.train.matrix,file = "../data/web.train2.0.csv")
#################################################################
####################write webtest matrix##########################
###########################################################
web.feature<-NULL
web.featurename<-NULL
for (i in 1:dim(webtest)[1]){
  if (webtest[i,2] == "C"){
    web.feature = c(web.feature,webtest[i,3])
  }
}

c = a+1
d = b
b2 = b
for(i in 2:nrow){
  d[i] = b2[i] + b2[i-1]
  b2[i] = d[i]
}
d[nrow] = dim(webtest)[1]


web.test.matrix<-matrix(NA,nrow = nrow, ncol = ncol)

for (x in 1:length(c)){
  for(y in 1:(d[x]-c[x]+1)){
    web.test.matrix[x,1:(d[y]-c[y]+1)] = webtest[c[y]:d[y],3]
  }
}
length(web.feature)
rownames(web.test.matrix) = web.feature
#####################################################
save(web.test.matrix,file="../output/web.test2.0.Rdata")
write.csv(web.test.matrix,file = "../data/web.test2.0.csv")
##############################################$$$$$$#

################# movie train #######################
movietrain = read.csv("../data/eachmovie_sample/data_train.csv")
movietrain = movietrain[,-1]

nrow_movie = length(unique(movietrain[,2]))
ncol_movie = length(unique(movietrain[,1]))

movie.train.matrix = matrix(NA, nrow = nrow_movie, ncol = ncol_movie)
################# movie test#########################
movietest = read.csv("../data/eachmovie_sample/data_test.csv")
movietest = movietest[,-1]
nrow_movie = length(unique(movietest[,2]))
ncol_movie = length(unique(movietest[,1]))
movie.test.matrix = matrix(NA, nrow = nrow_movie, ncol = ncol_movie)
################ write matrix #####################
movie.train.matrix = reshape(movietrain, idvar = "User", timevar = "Movie", direction = "wide")
movie.test.matrix = reshape(movietest, idvar = "User", timevar = "Movie", direction = "wide")

write.csv(movie.train.matrix,"../data/movie.train2.0.csv")
write.csv(movie.test.matrix,"../data/movie.test2.0.csv")
 