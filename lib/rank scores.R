#########author Sijian Xuan
load("../output/web.sp.sig.p.Rdata")
load("../output/web.etp.sig.p.Rdata")
load("../output/web.msd.sig.p.Rdata")
load("../output/web.sp.n.p.Rdata")
load("../output/web.etp.n.p.Rdata")
load("../output/web.msd.n.p.Rdata")
load("../output/web.test.matrix.Rdata")
load("../output/web.sp.p.Rdata")
load("../output/web.etp.p.Rdata")
load("../output/web.msd.p.Rdata")
load("../output/web.simrank.p.Rdata")
load("../output/web.sp.var.p.Rdata")
source("./ranked_scoring2.0.R")
####################
# web.sp.sig.p_1 <- apply(web.sp.sig.p, 2, rank, ties.method="min")
# web.msd.sig.p_1 <- apply(web.msd.sig.p, 2, rank, ties.method="min")
# web.etp.sig.p_1 <- apply(web.etp.sig.p, 2, rank, ties.method="min")
#rank.web.sp.sig = rank_scoring(web.sp.sig.p,web.test.matrix,5)

rank.web.sp.sig = rank_scoring(web.sp.sig.p,web.test.matrix,5)
rank.web.msd.sig = rank_scoring(web.msd.sig.p,web.test.matrix,5)
rank.web.etp.sig = rank_scoring(web.etp.sig.p,web.test.matrix,5)
####################
# web.sp.sig.n.p_1 <- apply(web.sp.sig.n.p, 2, rank, ties.method="min")
# web.msd.sig.n.p_1 <- apply(web.msd.sig.n.p, 2, rank, ties.method="min")
# web.etp.sig.n.p_1 <- apply(web.etp.sig.n.p, 2, rank, ties.method="min")

rank.web.sp.n = rank_scoring(web.sp.n.p,web.test.matrix,5)
rank.web.msd.n = rank_scoring(web.msd.n.p,web.test.matrix,5)
rank.web.etp.n = rank_scoring(web.etp.n.p,web.test.matrix,5)
#####################
# web.sp.var.p_1 <- apply(web.sp.var.p, 2, rank, ties.method="min")

rank.web.sp.var = rank_scoring(web.sp.var.p,web.test.matrix,5)
#####################
# web.sp.p_1 <- apply(web.sp.p, 2, rank, ties.method="min")
# web.etp.p_1 <- apply(web.etp.p, 2, rank, ties.method="min")
# web.msd.p_1 <- apply(web.msd.p, 2, rank, ties.method="min")
# web.simrank.p_1 <- apply(web.simrank.p, 2, rank, ties.method="min")

rank.web.sp = rank_scoring(web.sp.p,web.test.matrix,5)
rank.web.etp = rank_scoring(web.etp.p,web.test.matrix,5)
rank.web.msd = rank_scoring(web.msd.p,web.test.matrix,5)
rank.web.simrank = rank_scoring(web.simrank.p,web.test.matrix,5)
####################
web_result = data.frame(Model = c('/', 'Significance Weighting', 
                                  'Variance Weighting', 'Neigbors'), 
                        Spearman = c(rank.web.sp, rank.web.sp.sig, 
                                     rank.web.sp.var, rank.web.sp.n), 
                        Entropy = c(rank.web.etp, rank.web.etp.sig, 
                                    NA, rank.web.etp.n), 
                        Mean_Square_Diff = c(rank.web.msd, rank.web.msd.sig, 
                            NA, rank.web.msd.n))
web_result
