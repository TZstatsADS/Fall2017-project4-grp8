
# coding: utf-8

# In[25]:


import numpy as np


# In[72]:


abs_corr_thed = 5
abs_corr = [1,2,3,4,5,6,7,8]
a = []


# ##### Absolute Correlation Threshold Method

# In[73]:


for i in range(len(abs_corr)):
    if abs_corr[i] <= abs_corr_thed:
        a.append(i)##return the index of neighbors that lower than threshold


# In[74]:


a


# ##### Best-n-estimator

# In[45]:


abs_corr = [1,2,3,4,5,4,7,8]
k = 5   ## value of n
a = []  ##the neighbors that will be used


# In[46]:


abs_corr = np.sort(abs_corr)


# In[47]:


a.append(abs_corr[0:k])

