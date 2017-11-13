### BEGIN Spearman correlation ###

#load("/Users/yiranli/Documents/Graduate_School_2016-2017/MA_Graduate_Classes/Applied_Data_Science_Ying_Liu/Proj4_Collaborative_Filtering_Recommendation_System/web.test.Rdata")
#load("/Users/yiranli/Documents/Graduate_School_2016-2017/MA_Graduate_Classes/Applied_Data_Science_Ying_Liu/Proj4_Collaborative_Filtering_Recommendation_System/web.train.rdata")


web_train <- web.train
web_train_rank0 <- t(apply(web.train, 1, rank))

###########################
# BEGIN spearman weights #
spearman_w <- matrix(NA, nrow = nrow(web_train_rank0) , ncol = ncol(web_train_rank0))

for(a in 1:nrow(spearman_w)){
  for(u in 1:ncol(spearman_w)){
    
    spearman_w[a,u] <- sum((web_train_rank0[a,] - mean(web_train_rank0[a,])) * (web_train_rank0[u,] - mean(web_train_rank0[u,]))) / (sd(web_train_rank0[a,]) * sd(web_train_rank0[u,]))
  }
}
# END spearman weights #
########################
# 
# #####################
# # BEGIN Prediction #
# var_weight_p <- matrix(NA, nrow = nrow(web_train_rank), ncol = ncol(web_train_rank))
# 
# for (a in 1:nrow(web_train_rank0)){
#   for(i in 1:ncol(web_train_rank0)){
#     var_weight_p[a,i] <- mean(web_train_rank0[a, ]) + sd(web_train_rank0[a,]) * sum(web_train_rank_mat[,i] * var_weighted_w[a,]) / sum(var_weighted_w[a,])
#   }
# }
# # END Prediction #
# ##################

####################
# BEGIN Prediction #
memory_based_prediction <- function(train_data, w){
  
  std_r <- t(apply(train_data, 1, function(rrr){
    return( (rrr-mean(rrr)) / sd(rrr)) }))
  
  p <- matrix(NA, nrow = nrow(train_data), ncol = ncol(train_data))
  
  for (a in 1:nrow(p)){
    for(i in 1:ncol(p)){
      
      p[a,i] <- mean(train_data[a, ]) + sd(train_data[a,]) * sum(std_r[,i] * w[a,]) / sum(w[a,])
    }
  }
  return(p)
}
# END Prediction

spearman_p <- memory_based_prediction(train_data = web_train_rank0[1:5,], w = spearman_w[1:5,])
apply(spearman_p, 2, rank)
  