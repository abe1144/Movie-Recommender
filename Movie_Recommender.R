#Set Working Directory


#Import Libraries
library(ggplot2)
library(data.table)
library(reshape2)

#Import Data
data <- read.csv(file.choose(), header = TRUE, stringsAsFactors = FALSE)

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

#convert matrix into dataframe
#exclude the first row
tag_matrix2 <- as.data.frame(tag_matrix[-1,], stringsAsFactors = FALSE)

for (i in 1:ncol(tag_matrix2)) {
  tag_matrix2[,i] <- as.integer(tag_matrix2[,i])
}


#build user profiles
user_data <- read.csv(file.choose(), stringsAsFactors = FALSE, header = TRUE)

binaryratings <- user_data
for (i in 1:nrow((binaryratings))){
  if (binaryratings[i,3] > 3){
    binaryratings[i,3] <- 1
  }
  else{
    binaryratings[i,3] <- -1
  }
}

binaryratings2 <- dcast(binaryratings, movieId~userId, value.var="rating", na.rm=FALSE)
for (i in 1:ncol(binaryratings2)){
  binaryratings2[which(is.na(binaryratings2[,i]) == TRUE), i] <- 0
}
binaryratings2 = binaryratings2[,-1]

#remove rows of movies that have no ratings
rated_movies <- as.data.frame(unique(user_data$movieId))
colnames(rated_movies) <- c("movieId")


data2 <- filter(data, movieId %in% rated_movies$movieId)





