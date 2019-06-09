# -*- coding: utf-8 -*-
"""
Created on Sat Jun  8 15:52:36 2019

@author: Abraham Lin
"""

from flask import Flask
from flask_restful import reqparse, abort, Api, Resource
import pickle as pkl
import numpy as np
import pandas as pd

app = Flask(__name__)
api = Api(app)

#load data, indices, similarity matrix
ind_path = './indices.pkl'
with open(ind_path, 'rb') as f:
    indices = pkl.load(f)
    
sim_path = './similarity_matrix.npy'
with open(sim_path, 'rb') as f:
    sim_mat = np.load(f)
    
data_path = './data.pkl'
with open(data_path,'rb') as f:
    data = pkl.load(f)

def get_recommendations(movie_title):
    #get the index that git coomatches the title
    idx = indices[movie_title]
    
    sim_scores = list(enumerate(sim_mat[idx]))
    sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
    sim_scores = sim_scores[1:11]
    rec_indices = [i[0] for i in sim_scores]
    
    return list(data['Title'].iloc[rec_indices]) 


#argument parser
parser = reqparse.RequestParser()
parser.add_argument('title_query')

class PredictRecommendations(Resource):
    def get(self):
        #use parser and find user's query
        args = parser.parse_args()
        user_query = args['title_query']
        recommendation = get_recommendations(user_query)
        
        
        #output
        output = {}
        for i in range(len(recommendation)):
            rank = i+1
            output[rank] = recommendation[i]
        return output

# Setup the Api resource routing here
# Route the URL to the resource
api.add_resource(PredictRecommendations, '/')

if __name__ == '___main__':
    app.run(debug=True)
    
