
# coding: utf-8

# In[37]:


import csv
import pandas as pd


# In[73]:


data = 'webtrainAL1.csv'


# In[128]:


webtrain = pd.read_csv(data, header= None)


# In[129]:


m = webtrain.shape[0]
n = webtrain.shape[1]
a = []
k = 1


# In[1]:


for x in range(0, m):
    for y in range(0,x):
        a.append(pd.Series.count(list(set(webtrain.iloc[x]).intersection(set(webtrain.iloc[y])))))

