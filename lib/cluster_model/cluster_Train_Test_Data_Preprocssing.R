load("~/Downloads/Fall2017-project4-grp8-master/output/mv.test.matrix.Rdata")
load("~/Downloads/Fall2017-project4-grp8-master/output/mv.train.matrix.Rdata")


data_test <- read.csv("~/Downloads/data_sample/eachmovie_sample/data_test.csv")

################ write matrix #####################
movie.test.matrix = reshape(data_test, idvar = "User", timevar = "Movie", direction = "wide")
write.csv(movie.test.matrix,"~/Downloads/data_sample/eachmovie_sample/moive_test.csv", na="")
rownames(movie.test.matrix)<-movie.test.matrix[,1]
movie.test.matrix<-movie.test.matrix[,-1]
movie.test.col<-colnames(movie.test.matrix)


data_train <- read.csv("~/Downloads/data_sample/eachmovie_sample/data_train.csv")
movietrain = data_train[,-1]

################ write matrix #####################
movie.train.matrix = reshape(movietrain, idvar = "User", timevar = "Movie", direction = "wide")
rownames(movie.train.matrix)<-movie.train.matrix[,1]
movie.train.matrix<-movie.train.matrix[,-1]

movie.train.col<-colnames(movie.train.matrix)

common<-intersect(movie.train.col,movie.test.col)
train.col<-match(common,movie.train.col)
test.col<-match(common,movie.test.col)
new.matrix<-matrix(NA,nrow=nrow(movie.train.matrix),ncol=ncol(movie.train.matrix))
for (i in 1:length(common)){
  a<-train.col[i]
  b<-test.col[i]
  new.matrix[,a]<-movie.test.matrix[,b]
  new.matrix[,i]
}
rownames(new.matrix)<-rownames(movie.train.matrix)
colnames(new.matrix)<-colnames(movie.train.matrix)
write.csv(new.matrix,"~/Downloads/data_sample/eachmovie_sample/moive_test_train_new.csv", na="")

