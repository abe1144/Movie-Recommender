#Set Working Directory

setwd("C:/Users/Abraham Lin/Desktop/Recomender Project/ml-latest-small/")

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
