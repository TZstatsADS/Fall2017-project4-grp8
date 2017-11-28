data_train <- read.csv("~/Downloads/data_sample/eachmovie_sample/data_train.csv")
movietrain = data_train[,-1]

nrow_movie = length(unique(movietrain[,2]))
ncol_movie = length(unique(movietrain[,1]))

movie.train.matrix = matrix(NA, nrow = nrow_movie, ncol = ncol_movie)

################ write matrix #####################
movie.train.matrix = reshape(movietrain, idvar = "User", timevar = "Movie", direction = "wide")
write.csv(movie.train.matrix,"~/Downloads/data_sample/eachmovie_sample/moive_train.csv", na="")

