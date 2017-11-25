
# coding: utf-8

# ## AUTHOR: Sijian Xuan
# ### make the adjacent list into the wei(not in matrix yet)

# In[14]:


import csv
import pandas as pd


# In[15]:


data = '../data/web.train2.0.csv'
data1 = '../data/movie.train2.0.csv'


# In[50]:


webtrain = pd.read_csv(data, header= 0)
movietrain = pd.read_csv(data1, header = 0)


# In[80]:


m = webtrain.shape[0]
a = []
print(m)


# In[66]:


##### webtrain
for x in range(0, m):
    for y in range(0,m):
        a.append(pd.Series.count(list(set(webtrain.iloc[x]).intersection(set(webtrain.iloc[y])))))


# In[100]:


movietrain_numpyarray = pd.DataFrame.as_matrix(movietrain)


# In[112]:


m1 = movietrain.shape[0]
a1 = []


# In[114]:


for x in range(m1):
    for y in range(x):
        a1.append(sum(movietrain_numpyarray[x,] == movietrain_numpyarray[y,]))
    print(x)


# In[115]:


print(a1)


# In[117]:


outfile1 = open('../output/movie_train_a.csv','w')
out = csv.writer(outfile1)
out.writerows(map(lambda x: [x], a1))
outfile1.close()


# In[39]:


outfile = open('../output/webtrain_a.csv','w')
out = csv.writer(outfile)
out.writerows(map(lambda x: [x], a))
outfile.close()

