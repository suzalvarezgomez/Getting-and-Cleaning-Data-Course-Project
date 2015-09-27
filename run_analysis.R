# Getting-and-Cleaning-Data-Course-Project
# SUSANA ALVAREZ GOMEZ

###################################################
## 1.- Merges the training and the test sets to create one data set.
# READ THE LABELS FROM "features.txt" AND "activity_labels.txt"
###################################################
featureNames <- read.table("features.txt")
activityNames <- read.table("activity_labels.txt", header = FALSE)

# READ THE SUBJET FILES  AND COMBINE BOTH FILES INTO ONE
subjectTrain <- read.table("subject_train.txt", header = FALSE)
subjectTest <- read.table("subject_test.txt", header = FALSE)
subject <- rbind(subjectTrain, subjectTest)

# READ THE ACTIVITY FILES  AND COMBINE BOTH FILES INTO ONE
activityTrain <- read.table("y_train.txt", header = FALSE)
activityTest <- read.table("y_test.txt", header = FALSE)
activity <- rbind(activityTrain, activityTest)

# READ THE FEATURES FILES  AND COMBINE BOTH FILES INTO ONE
featuresTrain <- read.table("X_train.txt", header = FALSE)
featuresTest <- read.table("X_test.txt", header = FALSE)
features <- rbind(featuresTrain, featuresTest)

# LABELLED THE THREE PREVIOUS FILES
head(featureNames)
colnames(features) <- (featureNames[,2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"

# AND COMBINE THESE THREE FILE TO CREATE THE MERGE FILE
my_data <- cbind(features,activity,subject)
head(my_data)
dim(my_data)

#####################################################
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#USE GREP COMMAND TO SELECT THE COLUMN NAMES THAT INCLUDES "mean ()" AND "std ()"
# THIS EXCLUDE MEANFREG AND ANGLE.
# meanFreq(): Weighted average of the frequency components
#angle(): Angle between to vectors. For example: gravityMean  vs. tBodyAccMean
#ADDITIONALY, I ADD SUBJECT AND ACTIVITY COLUMNS
#####################################################

columns_mean_std <- grep("mean\\(\\)|std\\(\\)", names(my_data))
columns_subset_data <-c(columns_mean_std,562,563)
subset_data<-my_data[,columns_subset_data]

#####################################################
##3.- Uses descriptive activity names to name the activities in the data set
#USE FACTOR COMMAND TO CHANGES 1 FOR " WALKING", 2 FOR "WALKING_UPSTAIRS", ETC
#####################################################

subset_data$Activity = factor(subset_data$Activity, levels=c(1,2,3,4,5,6), labels = activityNames[,2])

#####################################################
##4.- Appropriately labels the data set with descriptive variable names. 
#####################################################

names(subset_data)<-gsub("Acc", "Acceleration.", names(subset_data ))
names(subset_data)<-gsub("Gyro", "Gyroscope.", names(subset_data ))
names(subset_data)<-gsub("Body", "Body_", names(subset_data ))
names(subset_data)<-gsub("Mag", "Magnitude.", names(subset_data ))
names(subset_data)<-gsub("^t", "Time.", names(subset_data ))
names(subset_data)<-gsub("^f", "Frequency.", names(subset_data ))
names(subset_data)<-gsub("Gravity", "Gravity_", names(subset_data ))
names(subset_data)<-gsub(".-mean()", "-Mean", names(subset_data ))
names(subset_data)<-gsub(".-std()", "-STD", names(subset_data ))
names(subset_data )

#####################################################
##5.- From the data set in step 4, creates a second, independent tidy data 
## set with the average of each variable for each activity and each subject.
#####################################################

tidydata <- aggregate(. ~Subject + Activity, subset_data, mean)
tidydata <- tidydata[order(tidydata$Subject,tidydata$Activity),]
