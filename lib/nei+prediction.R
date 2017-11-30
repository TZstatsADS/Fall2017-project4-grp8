source("./function+for+making+prediction.R")
####### web spearman neighbor
load("../output/web.train.matrix.Rdata")
data1 = web.train.matrix
load("../output/web.sp.sim.Rdata")
web.sp.sim = (web.sp.sim - min(web.sp.sim))/(max(web.sp.sim)-min(web.sp.sim))
sim1 = web.sp.sim
load("../output/sn_web_sp_n=20_th=0.6.Rdata")
nei1 = value_matrix
######################################################
web.sp.n.p = predict.nei(data1,sim1,nei1)
save(web.sp.n.p,file = "../output/web.sp.n.p.Rdata")
#####################################################
####### web msd neighbor
data2 = web.train.matrix
load("../output/web.msdiff.sim.Rdata")
sim2 = web.msdiff.sim
load("../output/sn_web_msd_n=20_th=0.6.Rdata")
nei2 = value_matrix
######################################################
web.msd.n.p = predict.nei(data2,sim2,nei2)
save(web.msd.n.p,file = "../output/web.msd.n.p.Rdata")
#####################################################
####### web etp neighbor
data3 = web.train.matrix
load("../output/web.etp.sim.Rdata")
sim3 = web.etp.sim
load("../output/sn_web_entropy_n=20_th=8.Rdata")
nei3 = value_matrix
######################################################
web.etp.n.p = predict.nei(data3,sim3,nei3)
save(web.etp.n.p,file = "../output/web.etp.n.p.Rdata")
#####################################################