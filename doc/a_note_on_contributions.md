Project 4: Collaborative Filtering Algorithm

Summary: In this project, we implemented and compared algorithms from the collaborative filtering literature on two datasets – Microsoft anonymous website data and EachMovie data.

We applied different variants of similarity weighting, which include Spearman, Entropy (empirical KL-Divergence), Mean Squared Difference, and SimRank. Additional adjustments, including Significance Weighting, Variance Weighting, Combined Selected Neighbors, and Ratio Normalization with Z-score, are applied.  In addition, we have cross-validated C for the number of clusters.

[Contribution Statement]

+ Chenyun Wu

+ Sihui Shao: Created the Expectation and Maximization function and Implemented the EM algorithm on EachMovie data for the Cluster Model; created functions in Python to implement SimRank on EachMovie data

+ Sijian Xuan

+ Yajie Guo

+ Yiran Li: Created functions to calculate Spearman Correlation Weighting, Variance Weighting, a memory-based prediction function, a cluster model prediction function, a cluster model cross validation function for the number of clusters C.
