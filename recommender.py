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
data = df[['Title','Genre','Director','Actors','Plot']]


def clean_text(text):
    r = Rake()
    r.extract_keywords_from_text(text)
    keywords_list = list(r.get_word_degrees().keys())
    return ' '.join(keywords_list)

def clean_name(name):
    name_list = name.split(',')
    clean = []
    for name in name_list:
        name = name.strip()
        name = name.lower()
        name = name.replace(" ", "")
        clean.append(name)
    return ' '.join(clean)
    
    
        
data['keywords'] = data['Plot'].apply(clean_text)

data['Director_norm'] = data['Director'].apply(clean_name)
data['actors_norm'] = data['Actors'].apply(clean_name)
data['genre_norm'] = data['Genre'].apply(clean_name)
data['bag_of_words'] = data['genre_norm'] + ' ' + data['Director_norm'] + ' ' + data['actors_norm'] + ' ' + data['keywords']

count = CountVectorizer()

count_matrix = count.fit_transform(data['bag_of_words'])


#generate similarity matrix
sim_mat = cosine_similarity(count_matrix, count_matrix)

indices = pd.Series(data.index, index=data['Title']).drop_duplicates()

def get_recommendations(movie_title):
    #get the index that git coomatches the title
    idx = indices[movie_title]
    
    sim_scores = list(enumerate(sim_mat[idx]))
    
    sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
    sim_scores = sim_scores[1:11]
    rec_indices = [i[0] for i in sim_scores]
    
    return data['Title'].iloc[rec_indices]   
    