

###################web################
predict.general<-function(data,sim){
  #sim<-abs(sim)
  p<- matrix(NA, nrow = nrow(data), ncol = ncol(data)-1)
  #norm<-t(apply(data[,-1],1,scale))
  norm<-t(apply(data[,-1],1,scale))
  
  for (a in 1:nrow(data)){
    for(i in 1:ncol(data)-1){
      p[a,i] <- mean(data[a,-1]) + sd(data[a,-1]) * sum(norm[,i]* sim[a,]) / sum(sim[a,])
    }
    print(a)
  }
  return(p)
}

web.sp.sim<-(web.sp.sim-min(web.sp.sim))/(max(web.sp.sim)-min(web.sp.sim))
range(web.sp.sim)
web.sp.p<-predict.general(web.train.matrix,web.sp.sim)
save(web.sp.p,file="~/Desktop/Proj4/web.sp.p.Rdata")


web.etp.p<-predict.general(web.train.matrix,web.etp.sim)
save(web.etp.p.abs,file="~/Desktop/Proj4/web.etp.p.Rdata")

web.msd.p<-predict.general(web.train.matrix,web.msdiff.sim)
save(web.msd.p,file="~/Desktop/Proj4/web.msd.p.Rdata")

web.simrank<-read.csv("vistor_simrank_new.csv")
web.simrank.matrix<-as.matrix(web.simrank[,-1])
save(web.simrank.matrix,file="~/Desktop/Proj4/web.simrank.matrix.Rdata")
web.simrank.p<-predict.general(web.train.matrix,web.simrank.matrix)
save(web.simrank.p,file="~/Desktop/Proj4/web.simrank.p.Rdata")

###############web+nei########################
predict.nei<-function(data,sim,nei){
  #sim<-abs(sim)
  p<- matrix(NA, nrow = nrow(data), ncol = ncol(data)-1)

  for (a in 1:nrow(data)){
    
    nb<-nei[a,]
    nb<-nb[!is.na(nb)]
    
    if(length(nb)==0){
      p[a,]<-rep(mean(data[a,-1]),ncol(data)-1)
    }
    
    else{
    sim.sub<-sim[a,nb] #20
    nei.sub<-data[nb,-1] #20*85
  
    for(i in 1:ncol(data)-1){
      nei.norm <- (nei.sub[ ,i]-apply(nei.sub, 1, mean))/apply(nei.sub, 1, sd) #20
      p[a,i] <- mean(data[a,-1]) + sd(data[a,-1]) * sum(nei.norm * sim.sub) / sum(sim.sub)
    }
    
    }
    
    print(a)
  }
  
  return(p)
}

load("~/Desktop/Proj4/pl_web_msd_n20_th0.6.Rdata")
web.msd.nei.p<-predict.nei(web.train.matrix,web.msdiff.sim,result)
save(web.msd.nei.p,file="~/Desktop/Proj4/web.msd.nei.p.Rdata")
rank_scoring(web.msd.nei.p, web.test.matrix, 5)

range(web.sp.sim)
load("~/Desktop/Proj4/pl_web_sp_n20_th0.6.Rdata")
web.sp.nei.p<-predict.nei(web.train.matrix,web.sp.sim,result)
save(web.sp.nei.p,file="~/Desktop/Proj4/web.sp.nei.p.Rdata")
rank_scoring(web.sp.nei.p, web.test.matrix, 5)

load("~/Desktop/Proj4/web.etp.sim.Rdata")
load("~/Desktop/Proj4/pl_web_entropy_n20_th8.Rdata")
range(web.etp.sim)
web.etp.nei.p<-predict.nei(web.train.matrix,web.etp.sim,result)
save(web.etp.nei.p,file="~/Desktop/Proj4/web.etp.nei.p.Rdata")
rank_scoring(web.sp.nei.p, web.test.matrix, 5)





#############################movie###############


predict.mv.general<-function(data,test,sim){
  #sim<-abs(sim)
  data[is.na(data)]<-0
  train.movie<-colnames(data[,-1])
  
  p<- matrix(NA, nrow = nrow(test), ncol = ncol(test)-1)
  norm<-abs(t(apply(data[,-1],1,scale)))
  
  for (a in 1:nrow(test)){
      test.sub<-test[a,-1]
      isna<-which(!is.na(test.sub))
      #colref<-colnames(test.sub[isna])
      #idx<-match(colref,colnames(data))
      
    #for(i in idx){ 
    for(i in isna){
      ref<-match(colnames(test.sub)[i],train.movie)
      p[a,i] <- mean(as.numeric(data[a,-1])) + sd(as.numeric(data[a,-1])) * sum(norm[,ref]* sim[a,]) / sum(sim[a,])
      
    }
    print(a)
  }
  return(p)
}

############movie full###################
mv.sp.sim<-(mv.sp.sim-min(mv.sp.sim))/(max(mv.sp.sim)-min(mv.sp.sim))
range(mv.sp.sim)

#sim
mv.sp.p<- predict.mv.general(mv.train.matrix,mv.test.matrix,mv.sp.sim)
mv.etp.p<-predict.mv.general(mv.train.matrix,mv.test.matrix,mv.etp.sim)
mv.msd.p.abs<-predict.mv.general(mv.train.matrix,mv.test.matrix,mv.msdiff.sim)

save(mv.sp.p,file="~/Desktop/Proj4/mv.sp.p.Rdata")
save(mv.etp.p,file="~/Desktop/Proj4/mv.etp.p.Rdata")
save(mv.msd.p,file="~/Desktop/Proj4/mv.msd.p.Rdata")
save(mv.msd.p.abs,file="~/Desktop/Proj4/mv.msd.p.abs.Rdata")

mv.sp.mae<- mean(as.matrix(abs((mv.test.matrix[,-1]-mv.sp.p))),na.rm=T)
mv.etp.mae<-mean(as.matrix(abs((mv.test.matrix[,-1]-mv.etp.p))),na.rm=T)
mv.msd.mae<-mean(as.matrix(abs((mv.test.matrix[,-1]-mv.msd.p))),na.rm=T)
mv.msd.mae.abs<-mean(as.matrix(abs((mv.test.matrix[,-1]-mv.msd.p.abs))),na.rm=T)

#sim+sig
load(file="~/Desktop/Proj4/movietrain_significance_weighting_n=11.rdata")

newsim<-mv.sp.sim * movie_train_a_11
mv.sp.sig.p<-predict.mv.general(mv.train.matrix,mv.test.matrix,newsim)

newsim<-mv.etp.sim * movie_train_a_11
mv.etp.sig.p<-predict.mv.general(mv.train.matrix,mv.test.matrix,newsim)

newsim<-mv.msdiff.sim * movie_train_a_11
mv.msd.sig.p<-predict.mv.general(mv.train.matrix,mv.test.matrix,newsim)

save(mv.sp.sig.p,file="~/Desktop/Proj4/mv.sp.sig.p.Rdata")
save(mv.etp.sig.p,file="~/Desktop/Proj4/mv.etp.sig.p.Rdata")
save(mv.msd.sig.p,file="~/Desktop/Proj4/mv.msd.sig.p.Rdata")

mv.sp.sig.mae<- mean(as.matrix(abs((mv.test.matrix[,-1]-mv.sp.sig.p))),na.rm=T)
mv.etp.sig.mae<-mean(as.matrix(abs((mv.test.matrix[,-1]-mv.etp.sig.p))),na.rm=T)
mv.msd.sig.mae<-mean(as.matrix(abs((mv.test.matrix[,-1]-mv.msd.sig.p))),na.rm=T)

#sim+var

load(file="~/Desktop/Proj4/movie_variance_weights.rdata")
mv.var.p<-predict.mv.general(mv.train.matrix, mv.test.matrix, var_weighted_w)
mv.var.mae<-mean(as.matrix(abs((mv.test.matrix[,-1]-mv.var.p))),na.rm=T)



mv_result = data.frame(Similarity = c('/', 'Significance Weighting','Variance Weighting'), 
                          Spearman = c(mv.sp.mae, mv.sp.sig.mae, mv.var.mae), 
                          Entropy = c(mv.etp.mae, mv.etp.sig.mae,"/"), 
                          Mean_Square_Diff = c(mv.msd.mae.abs, mv.msd.sig.mae,"/"))
mv_result
save(mv_result,file="~/Desktop/Proj4/mv_result.Rdata")


###########sub + mv + general #############
mv.test.sub.l<-mv.test.matrix[1:100,]

submv.sp.p<-predict.mv.general(mv.train.matrix,mv.test.sub.l,mv.sp.sim)
save(submv.sp.p,file="~/Desktop/Proj4/submv.sp.p.Rdata")

submv.etp.p<-predict.mv.general(mv.train.matrix,mv.test.sub.l,mv.etp.sim)
save(submv.etp.p,file="~/Desktop/Proj4/submv.etp.p.Rdata")

submv.msd.p<-predict.mv.general(mv.train.matrix,mv.test.sub.l,mv.msdiff.sim)
save(submv.msd.p,file="~/Desktop/Proj4/submv.msd.p.Rdata")

submv.sp.mae<-mean(as.matrix(abs((mv.test.sub.l[,-1]-submv.sp.p))),na.rm=T)
submv.etp.mae<-mean(as.matrix(abs((mv.test.sub.l[,-1]-submv.etp.p))),na.rm=T)
submv.msd.mae<-mean(as.matrix(abs((mv.test.sub.l[,-1]-submv.msd.p))),na.rm=T)

submv.sp.mae
submv.etp.mae
submv.msd.mae

# ll<-mv.msd.p[1,]
# ll<-p[1,]
# length(ll[!is.na(ll)])
# load("~/Desktop/Proj4/mv.sp.sim.Rdata")
# load("~/Desktop/Proj4/web.sp.sim.Rdata")


#############sub + mv + VARIANCE +general ##############
load(file="~/Desktop/Proj4/movie_variance_weights.rdata")
submv.var.p<-predict.mv.general(mv.train.matrix,mv.test.sub.l,var_weighted_w)
submv.var.mae<-mean(as.matrix(abs((mv.test.sub.l[,-1]-submv.var.p))),na.rm=T)


#############sub + mv + SIGNIFICANCE +general ##############
load(file="~/Desktop/Proj4/movietrain_significance_weighting_n=11.rdata")

newsim<-mv.sp.sim%*%movie_train_a_11
submv.sp.sig.p<-predict.mv.general(mv.train.matrix,mv.test.sub.l,newsim)

newsim<-mv.etp.sim%*%movie_train_a_11
submv.etp.sig.p<-predict.mv.general(mv.train.matrix,mv.test.sub.l,newsim)

newsim<-mv.msdiff.sim%*%movie_train_a_11
submv.msd.sig.p<-predict.mv.general(mv.train.matrix,mv.test.sub.l,newsim)

save(submv.sp.sig.p,file="~/Desktop/Proj4/submv.sp.sig.p.Rdata")
save(submv.etp.sig.p,file="~/Desktop/Proj4/submv.etp.sig.p.Rdata")
save(submv.msd.sig.p,file="~/Desktop/Proj4/submv.msd.sig.p.Rdata")

submv.sp.sig.mae<-mean(as.matrix(abs((mv.test.sub.l[,-1]-submv.sp.sig.p))),na.rm=T)
submv.etp.sig.mae<-mean(as.matrix(abs((mv.test.sub.l[,-1]-submv.etp.sig.p))),na.rm=T)
submv.msd.sig.mae<-mean(as.matrix(abs((mv.test.sub.l[,-1]-submv.msd.sig.p))),na.rm=T)

#####################################
#########mv+NEI######################

predict.mv.nei<-function(data,test,sim,nei){
  #sim<-abs(sim)
  data[is.na(data)]<-0
  train.movie<-colnames(data[,-1])
  
  p<- matrix(NA, nrow = nrow(test), ncol = ncol(test)-1)
  norm<-t(apply(data[,-1],1,scale))
  
  for (a in 1:nrow(test)){
    test.sub<-test[a,-1]
    isna<-which(!is.na(test.sub))
    
    sim.sub<-sim[a,nei[a,]] #simlimarity subset of neighborrs
    nei.sub<-data[nei[a, ],-1] #data subset of neighborrs
    
    #for(i in idx){ 
    for(i in isna){
      ref<-match(colnames(test.sub)[i],train.movie)#index of test data in train data
      nei.norm <- (nei.sub[ ,ref]-apply(nei.sub, 1, mean))/apply(nei.sub, 1, sd) #20
      p[a,i] <- mean(as.numeric(data[a,-1])) + sd(as.numeric(data[a,-1])) * sum(nei.norm* sim) / sum(sim)
      
    }
    print(a)
  }
  return(p)
}

########################SUB + MV + NEI ###################
mv.test.sub.s<-mv.test.matrix[101:111,]

load(file="~/Desktop/Proj4/pl_movie_sp_n20_th0.3.Rdata")
submv.sp.nei.p<-predict.mv.nei(mv.train.matrix,mv.test.sub.s,mv.sp.sim,result)
save(submv.sp.nei.p,file="~/Desktop/Proj4/submv.sp.nei.p.Rdata")

load(file="~/Desktop/Proj4/pl_movie_entropy_n20_th0.6.Rdata")
submv.etp.nei.p<-predict.mv.nei(mv.train.matrix,mv.test.sub.s,mv.etp.sim,result)
save(submv.etp.nei.p,file="~/Desktop/Proj4/submv.etp.nei.p.Rdata")

load(file="~/Desktop/Proj4/pl_movie_msd_n20_th0.7.Rdata")
submv.msd.nei.p<-predict.mv.nei(mv.train.matrix,mv.test.sub.s,mv.msdiff.sim,result)
save(submv.msd.nei.p,file="~/Desktop/Proj4/submv.msd.nei.p.Rdata")

submv.sp.nei.mae<-mean(as.matrix(abs((mv.test.sub.s[,-1]-submv.sp.nei.p))),na.rm=T)
submv.etp.nei.mae<-mean(as.matrix(abs((mv.test.sub.s[,-1]-submv.etp.nei.p))),na.rm=T)
submv.msd.nei.mae<-mean(as.matrix(abs((mv.test.sub.s[,-1]-submv.msd.nei.p))),na.rm=T)



submv_result = data.frame(Similarity = c('/', 'Significance Weighting', 
                                 'Variance Weighting', 'Neigbors'), 
                       Spearman = c(submv.sp.mae, submv.sp.sig.mae, 
                                          submv.var.mae, submv.sp.nei.mae), 
                       Entropy = c(submv.etp.mae, submv.etp.sig.mae, 
                                           "/", submv.etp.nei.mae), 
                       Mean_Square_Diff = c(submv.msd.mae, submv.msd.sig.mae, 
                                           "/", submv.msd.nei.mae))
submv_result
save(submv_result,file="~/Desktop/Proj4/submv_result.Rdata")

web_result = data.frame(Model = c('/', 'Significance Weighting', 
                                    'Variance Weighting', 'Neigbors'), 
                          Spearman = c(web.sp.rs, web.sp.sig.rs, 
                                       web.var.rs, web.sp.nei.rs), 
                          Entropy = c(web.etp.rs, web.etp.sig.rs, 
                                      "NA", web.etp.nei.rs), 
                          Mean_Square_Diff = web.msd.rs, web.msd.sig.rs, 
                                      "NA", web.msd.nei.rs)



# load("~/Desktop/Proj4/pl_web_msd_n20_th0.6.Rdata")
# web.msd.nei.p<-predict.nei(web.train.matrix,web.msdiff.sim,result)
# save(web.msd.nei.p,file="~/Desktop/Proj4/web.msd.nei.p.Rdata")

# p<- matrix(NA, nrow = nrow(web.train.matrix), ncol = ncol(web.train.matrix))
# norm<-t(apply(web.train.matrix[,-1],1,scale))
# 
# for (a in 1:nrow(web.train.matrix)){
#   for(i in 1:ncol(web.train.matrix)-1){
#   
#     p[a,i] <- mean(web.train.matrix[a,-1]) + sd(web.train.matrix[a,-1]) * sum(norm[,i]* web.msdiff.sim[a,]) / sum(web.msdiff.sim[a,])
#   }
#   print(a)
# }
# 
# p2<- matrix(NA, nrow = nrow(mv.train.matrix), ncol = ncol(mv.train.matrix)-1)
# norm<-t(apply(mv.train.matrix[,-1],1,scale))
# 
# 
# for (a in 1:nrow(mv.train.matrix)){
#   for(i in 1:ncol(mv.train.matrix)-1){
#     
#     p2[a,i] <- mean(mv.train.matrix[a,-1]) + sd(mv.train.matrix[a,-1]) * sum(norm[,i]* mv.msdiff.sim[a,]) / sum(mv.msdiff.sim[a,])
#   }
#   print(a)
# }

