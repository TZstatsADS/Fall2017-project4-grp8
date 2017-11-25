
# coding: utf-8

# In[1]:


import numpy as np
import pandas as pd


# In[5]:


movie_train = pd.read_csv("../data/eachmovie_sample/data_train.csv")
movie_test = pd.read_csv("../data/eachmovie_sample/data_test.csv")
web_train = pd.read_csv("../data/MS_sample/data_train.csv")
web_test = pd.read_csv("../data/MS_sample/data_test.csv")


# In[9]:


web_train.shape, web_test.shape, movie_train.shape, movie_test.shape


# In[20]:


'1' in web_train


# In[16]:


web_train

