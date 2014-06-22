##
## Project Code for Getting and Cleaning Data
##
##
##


setwd("~/My Courses/GettingAndCleaningData/Project/")

url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
local_name <- "HAR.zip"
download.file(url=url,dest=local_name)
unzip(local_name)

library(reshape2)
library(plyr)

## Read all of the test data from the test directory
setwd("~/My Courses/GettingAndCleaningData/Project/UCI HAR Dataset/test")
Xtest <- read.table("X_test.txt")
ytest <- read.table("y_test.txt")
stest <- read.table("subject_test.txt")

## Read all of the training data from the training directory
setwd("~/My Courses/GettingAndCleaningData/Project/UCI HAR Dataset/train")
Xtrain <- read.table("X_train.txt")
ytrain <- read.table("y_train.txt")
strain <- read.table("subject_train.txt")

## Read all of the variable names from the "features.txt" file in the main directory
setwd("~/My Courses/GettingAndCleaningData/Project/UCI HAR Dataset")
features <- read.table("features.txt")

## Read all of the activity names from the "activity_labels.txt" file in the main directory
setwd("~/My Courses/GettingAndCleaningData/Project/UCI HAR Dataset")
activities <- read.table("activity_labels.txt")

f1 <- function(x) activities$V2[x]

anames <- lapply(combinedX2$activitiyid,function(x) activities$V2[x])


## Extract all variables that contain "mean" and "std" from the list of variable names in features
#selectvars1 <- features[grepl("mean()|std()",features$V2),]

## Extract all variables that contain "meanFreq" from the list of variables
#selectvars2 <- selectvars1[!grepl("meanFreq()",selectvars1$V2),]




## Apply the variable names from features to the "test" and "training" observations in X
names(Xtest) <- features$V2
names(Xtrain) <- features$V2


## Test contains test data and Train contains training data
## Xtest and Xtrain contain observations for all of the 30 subjects
## ytest and ytrain contain the activities for all of the 30 subjects
## stest and strain contain the subject IDs of all of the 30 subjects
mergedXtest <- cbind(stest, ytest, Xtest)
names(mergedXtest)[1] <- paste("subjectid")
names(mergedXtest)[2] <- paste("activityid")

mergedXtrain <- cbind(strain, ytrain, Xtrain)
names(mergedXtrain)[1] <- paste("subjectid")
names(mergedXtrain)[2] <- paste("activityid")

## Now combine the Test data and the Training data to create one comprehensive 30 subject data set
combinedX <- arrange(rbind(mergedXtest, mergedXtrain), subjectid, activityid)

## Extract all variables that contain "mean" and "std" from the list of variable names 
combinedX1 <- combinedX[,grepl("mean()|std()|subjectid|activityid",colnames(combinedX))]

## Remove those variables that contain "meanFreq()" in the  list of variable names 
combinedX2 <- combinedX1[,!grepl("meanFreq()",colnames(combinedX1))]

## Clean up the variable names getting rid of "-" and "(", ")", and making variables lower case
names(combinedX2) <- tolower(gsub("-","",colnames(combinedX2)))
names(combinedX2) <- gsub("\\(\\)x","",colnames(combinedX2))
names(combinedX2) <- gsub("\\(\\)y","",colnames(combinedX2))
names(combinedX2) <- gsub("\\(\\)z","",colnames(combinedX2))
names(combinedX2) <- gsub("\\(\\)","",colnames(combinedX2))

## Create a second, independent tidy data set with the average 
## of each variable for each activity and each subject.


moltenX <- melt(combinedX2, measure.vars=c("subjectid","activityid"))
averageX <- dcast(combinedX2, subjectid ~ activityid, mean)

