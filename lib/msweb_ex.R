### BEGIN WORKS ###
data(MSWeb)

MSWeb5 <- MSWeb[rowCounts(MSWeb) > 5, ]
hist(rowCounts(MSWeb5), breaks = 15) #Distribution of number of website visited for each user
hist(colCounts(MSWeb5), breaks = 25) #Distribution of item popularity

scheme <- evaluationScheme(MSWeb5, method = "split", train = .85, given = 3)

rec_UBCF_Pearson <- Recommender(getData(scheme, "train"), "UBCF",   parameter=list(normalize='center',    # normalizing(to reduce user bias) by subtracting average rating per user;
                                                                                   # note that we don't scale by standard deviations here;
                                                                                   # we are assuming people rate on the same scale but have
                                                                                   # different biases
                                                                                   method='Pearson',      # use Pearson correlation
                                                                                   nn=30                  # number of Nearest Neighbors for calibration
))
getModel(rec_UBCF_Pearson)
pred_ubcf <- predict(object = rec_UBCF_Pearson, newdata = getData(scheme, "known"))

calcPredictionAccuracy(pred_ubcf, getData(scheme, "unknown"), given = 3)
### END WORKS ###
