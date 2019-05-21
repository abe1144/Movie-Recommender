# -*- coding: utf-8 -*-
"""
Created on Mon May 20 19:54:02 2019

@author: Abraham Lin
"""


import pandas as pd
from rake_nltk import Rake
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import CountVectorizer

df = pd.read_csv('https://query.data.world/s/uikepcpffyo2nhig52xxeevdialfl7')