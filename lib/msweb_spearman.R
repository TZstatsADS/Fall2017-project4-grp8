# Author: Yiran Li #
# The Spearman correlation coeffcient ρ is defined in the same manner as the Pearson correlation, except that r_alpha and r_tilda_alpha are replaced by the ranks of the respective objects.

### BEGIN Spearman correlation with variance weighting ###

#load("/Users/yiranli/Documents/Graduate_School_2016-2017/MA_Graduate_Classes/Applied_Data_Science_Ying_Liu/Proj4_Collaborative_Filtering_Recommendation_System/web.test.Rdata")
#load("/Users/yiranli/Documents/Graduate_School_2016-2017/MA_Graduate_Classes/Applied_Data_Science_Ying_Liu/Proj4_Collaborative_Filtering_Recommendation_System/web.train.rdata")

# Transform rating to rank
# We apply default voting to implicit voting (MSWeb) where missing values take on 0 to reflect a neutral and somewhat negative preference for these unobserved values.
web_train <- web.train
web_train_mini <- web_train[1:5,] # Plug in a mini set; web_train[1:5000,]

web_train_rank0 <- t(apply(web_train_mini, 1, function(rrr){return(ifelse(rrr==1, 1, 2))}))


var_i <- apply(web_train_rank0, 2, var) 
v_i <- (var_i - min(var_i)) / max(var_i)

# BEGIN Calc weights #

var_weighted_w <- matrix(NA, nrow = nrow(web_train_rank0), ncol = nrow(web_train_rank0))

for( i in 1:nrow(var_weighted_w) ){
  v_ind <- which(web_train[i,] == 1)
  
  for( j in 1:ncol(var_weighted_w)){
    # var_weighted_w[i,j] <- sum(v_i[v_ind] * web_train_rank0[i, v_ind] * web_train_rank0[j, v_ind]) / sum(v_i[v_ind])
    var_weighted_w[i,j] <- cor(x=web_train_rank0[i,], y=web_train_rank0[j,], method = "pearson")
  }
}
var_weighted_w
# END Calc weights #

# BEGIN Prediction #
var_weight_p <- matrix(NA, nrow = nrow(web_train_rank), ncol = ncol(web_train_rank))

for (a in 1:nrow(var_weight_p)){
  for(i in 1:ncol(var_weight_p)){
    var_weight_p[a,i] <- mean(web_train_rank0[a, ]) + sd(web_train_rank0[a,]) * sum(web_train_rank0[,i] * var_weighted_w[a,]) / sum(var_weighted_w[a,])
  }
}
var_weight_p

final_var_weight_p <- apply(var_weight_p, 2, rank, ties.method="min")
# END Prediction #

