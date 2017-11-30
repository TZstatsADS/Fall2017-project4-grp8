rank_scoring <- function(predicted, web_mini_test, alpha){
  
  visited_ind <- apply(web_mini_test, 1, function(rrr){return(which(rrr==1))})
  ord <- t(apply(predicted, 1, function(rrr){return(order(rrr,decreasing = T))})) #rank list of predicted
  # R_a_s: Expected utility of a ranked list for user a 
  R_a_s <- rep(NA, nrow(web_mini_test))
  R_a_max <- rep(NA, nrow(web_mini_test))
  
  for(a in 1:nrow(web_mini_test)){
    d<-mean(predicted[a,])
    j<-ord[a,] # rank of test case in predicted
    m<-ifelse((predicted[a,]-d)>0,(predicted[a,]-d),0)
    
    R_a_s[a] <- sum( m / 2^((j-1)/(alpha-1)) )
    R_a_max[a] <- length(visited_ind[[a]])
  }
  
  # Final rank score for an experiment
  R <- sum(R_a_s) / sum(R_a_max)*100
  return(R)
}

# load("../data/web.sp.p.Rdata")
# load("../data/web.etp.p.Rdata")
# load("../data/web.msd.p.Rdata")
# 
# rank_scoring(web.msd.p, web.test.matrix, 5)
# rank_scoring(web.etp.p, web.test.matrix, 5)
# rank_scoring(web.sp.p, web.test.matrix, 5)
