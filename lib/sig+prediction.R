################### web spearman
source("./msweb_spearman-copy.R")
#source("./function+for+making+prediction.R")
load("../output/web.train.matrix.Rdata")
data1 = web.train.matrix
load("../output/web.sp.sim.Rdata")
web.sp.sim = (web.sp.sim - min(web.sp.sim))/(max(web.sp.sim)-min(web.sp.sim))
sim1 = web.sp.sim

web.sp.p = predict.general(data1,sim1)
save(web.sp.p,file = "../output/web.sp.p.Rdata")

data2 = web.train.matrix
load("../output/web.msdiff.sim.Rdata")
sim2 = web.msdiff.sim
web.msd.p = predict.general(data2,sim2)
save(web.msd.p, file = "../output/web.msd.p.Rdata")

data3 = web.train.matrix
load("../output/web.etp.sim.Rdata")
sim3 = web.etp.sim
#web.etp.sig.p = predict.general(data3,sim3)
web.etp.p = predict.general(data3,sim3)
save(web.etp.p, file = "../output/web.etp.p.Rdata")

####################################################
###### with significance weighting
load("../output/webtrain_significance_weighting_n=9.Rdata")
data4 = web.train.matrix
sim4 = sim1*webtrain_a_matrix_9
web.sp.sig.p = predict.general(data4,sim4)
save(web.sp.sig.p, file = "../output/web.sp.sig.p.Rdata")
#################### web msd
data5 = web.train.matrix
sim5 = sim2*webtrain_a_matrix_9
#web.msd.sig.p = predict.general(data2,sim2)
web.msd.sig.p = predict.general(data5,sim5)
save(web.msd.sig.p, file = "../output/web.msd.sig.p.Rdata")
#################### web etp
data6 = web.train.matrix
sim6 = sim3*webtrain_a_matrix_9
#web.etp.sig.p = predict.general(data3,sim3)
web.etp.sig.p = predict.general(data6,sim6)
save(web.etp.sig.p, file = "../output/web.etp.sig.p.Rdata")
