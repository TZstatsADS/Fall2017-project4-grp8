### Author: Yiran Li ###
### BEGIN rank_scoring ###

# spearman_p <- memory_based_prediction(train_data = web_train_rank0[1:num_users,], w = spearman_w[1:num_users,])
# predicted_rank <- apply(spearman_p, 2, rank)
rank_scoring <- function(predicted_rank, web_mini_test, alpha){
  
  visited_ind <- apply(web_mini_test, 1, function(rrr){return(which(rrr==1))})
  
  # R_a_s: Expecte dutility of a ranked list for user a 
  R_a_s <- rep(NA, nrow(web_mini_test))
  for(a in 1:nrow(web_mini_test)){
    j_s <- predicted_rank[visited_ind[[a]]]
    R_a_s[a] <- sum(1/ 2^((j_s-1)/(alpha-1)))
    R_a_max <- length(visited_ind[[a]])
  }
  
  # Final rank score for an experiment
  R <- sum(R_a_s) / sum(R_a_max)
  return(R)
}
### END rank_scoring ###

# rank_scoring(predicted_rank, web_mini_test, alpha)