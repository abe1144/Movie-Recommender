#Set Working Directory

setwd("C:/Users/Abraham Lin/Desktop/ml-latest-small/")

#Import Libraries
library(ggplot2)
library(data.table)
library(reshape2)

#Import Data
data <- read.csv("movies.csv", header =TRUE, stringsAsFactors = FALSE)

#Extract the tags for each movie
tags <- as.data.frame(data$genres, stringsAsFactors = FALSE)

#Split each record by the | delimiter
tags2 <- as.data.frame(tstrsplit(tags[,1], "[|]", type.convert = TRUE), stringsAsFactors = FALSE, header = TRUE)
colnames(tags2) <- c(1:10)

tags_list <- c(unique(unlist(tags2)))

#remove invalid tags 
length(tags_list) <- 18

#create a tags genre matrix (rows == movies; columns == tags)

tag_matrix <- matrix(0, 9126, 18)
colnames(tag_matrix) <- tags_list
tag_matrix[1,] <- tags_list

#Set entry of matrix to 1 if the movie has that specific tag

for (i in 1:nrow(tags2)){
  for (j in 1:ncol(tags2)){
    tag_col = which(tag_matrix[1,] == tags2[i,j])
    tag_matrix[i+1, tag_col] <- 1
  }
}



  
    