## significance weighting
## read data as adjecent list file
webtrainAL = read.csv("../data/webtrainAL1.csv",header = FALSE)
webtestAL = read.csv("../data/webtestAL1.csv", header = FALSE)

m = dim(webtrainAL)[1]
n = dim(webtrainAL)[2]
a = 0
k = 1
for (i in 1:m){
  for(j in 1:n){
    a[k] = sum(!is.na(intersect(webtrainAL[i,],webtrainAL[j,])))
    k = k + 1
  }
}
mode(a)
write.csv(a,"../output/a.R")
