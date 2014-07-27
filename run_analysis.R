# Author: Michael Gierhake, <michael@xindaya.de>
# Date: 2014-07-27
#
# This script should be run from the directory where the raw data
# archive has been unzipped.
setwd("./UCI HAR Dataset/")

# get column names from features.txt file
features <- read.table("features.txt")
variableNames <- as.vector(features[,2])

# determine vector for subsetting the dataset, keeping only mean and std deviation variables
subsettingVector <- grepl("mean\\(\\)|std\\(\\)", variableNames)

# read test datasets
dataTest <- read.table("test/X_test.txt", col.names=variableNames)
subjectsTest <- read.table("test/subject_test.txt", col.names="subject")
activitiesTest <- read.table("test/y_test.txt", col.names="activity")

# discard unwanted variables, combine with subject and activity data
dataTest  <- dataTest[,subsettingVector]
dataTest  <- cbind(subjectsTest, activitiesTest, dataTest)

# read train datasets
dataTrain <- read.table("train/X_train.txt", col.names=variableNames)
subjectsTrain <- read.table("train/subject_train.txt", col.names="subject")
activitiesTrain <- read.table("train/y_train.txt", col.names="activity")
# discard unwanted variables, combine with subject and activity data
dataTrain  <- dataTrain[,subsettingVector]
dataTrain  <- cbind(subjectsTrain, activitiesTrain, dataTrain)

# combine train and test datasets
data <- rbind(dataTrain, dataTest)

# Read and edit activity labels
activityLabels <- read.table("activity_labels.txt", col.names=c("number", "activity"))
activityLabels$activity <- sub("_","", tolower(activityLabels$activity))
# Replace activity ID by name
activities <- sapply(data$activity, function(x) activityLabels[x,]$activity)
data$activity <- as.character(data$activity)
data$activity <- as.factor(activities)

# Cleanup variable names, expand abbreviations
variableNames <- names(data)
variableNames <- sub(".mean...|.mean..", "Mean", variableNames)
variableNames <- sub(".std...|.std..", "StdDev", variableNames)
variableNames <- sub("Acc", "Accelerometer", variableNames)
variableNames <- sub("Gyro", "Gyroscope", variableNames)
variableNames <- sub("Mag", "Magnitude", variableNames)
variableNames <- sub("^t", "time", variableNames)
variableNames <- sub("^f", "frequency", variableNames)
names(data) <- variableNames

finaldata <- aggregate(data[3:68], by=list(subject = data$subject, activity = data$activity), FUN=mean, na.rm=TRUE)

write.table(finaldata, "../tidyData.txt")

# (Superfluous) Housekeeping
rm(dataTrain, dataTest, activitiesTest, activitiesTrain, subjectsTest, subjectsTrain, features, subsettingVector)
setwd("../")
