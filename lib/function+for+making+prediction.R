# predict.nei<-function(data,sim,nei){
#   p<- matrix(NA, nrow = nrow(data), ncol = ncol(data)-1)
#   
#   for (a in 1:nrow(data)){
#     for(i in 1:ncol(data)-1){
#       
#       sim.sub<-sim[a,nei[a,]] #20
#       nei.sub<-data[nei[a, ], -1] #20*85
#       nei.norm <- (nei.sub[ ,i]-apply(nei.sub, 1, mean))/apply(nei.sub, 1, sd) #20
#       
#       #p[a,i] <- r_a[1] + sd_a[1] * sum(norm * neighbors1[a,] / sum(neighbors1[a,]))
#       p[a,i] <- mean(data[a,-1]) + sd(data[a,-1]) * sum(nei.norm * sim.sub) / sum(sim.sub)
#     }
#     print(a)
#   }
#   return(p)
# }
predict.nei<-function(data,sim,nei){
  #sim<-abs(sim)
  p<- matrix(NA, nrow = nrow(data), ncol = ncol(data)-1)
  
  for (a in 1:nrow(data)){
    
    sim.sub<-sim[a,nei[a,]] #20
    nei.sub<-data[nei[a, ],-1] #20*85
    # if(all(is.na(sim.sub))){
    #   sim.sub = sim.sub+1e-7
    # }
    for(i in 1:ncol(data)-1){
      nei.norm <- (nei.sub[ ,i]-apply(nei.sub, 1, mean))/apply(nei.sub, 1, sd) #20
      p[a,i] <- mean(data[a,-1]) + sd(data[a,-1]) * sum(nei.norm * sim.sub) / (sum(sim.sub)+1e-7)
    }
    
    print(a)
  }
  return(p)
}

predict.general<-function(data,sim){
  sim<-abs(sim)
  p<- matrix(NA, nrow = nrow(data), ncol = ncol(data)-1)
  norm<-t(apply(data[,-1],1,scale))
  
  for (a in 1:nrow(data)){
    for(i in 1:ncol(data)-1){
      p[a,i] <- mean(data[a,-1]) + sd(data[a,-1]) * sum(norm[,i]* sim[a,]) / sum(sim[a,])
    }
    print(a)
  }
  return(p)
}
