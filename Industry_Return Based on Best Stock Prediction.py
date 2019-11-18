#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import pandas as pd
import numpy as np
import os


# In[ ]:


import pandas_datareader as pdr


# In[ ]:


codes = pd.read_csv('Industry.Codes.csv')['x']


# In[ ]:


i_mean = []
full_data = []
for i in codes:
    anch = pd.read_csv(str(i)+'Anchors.csv')
    dat = []
    for j in range(2008,2019):
        start = str(j)+'-6-1'
        end = str(j+1)+'-6-1'
        x = anch[str(j)]
        try:
            t_a = pd.DataFrame(pdr.get_data_yahoo(x, start, end)['Adj Close'].reset_index())
            p_a = t_a.iloc[[0,len(t_a)-1]][x]
            ra = (p_a.iloc[1]/p_a.iloc[0]-1)
        except:
            pass
        dat.append(ra)
    m = np.mean(dat)
    i_mean.append(m)
    full_data.append(dat)

