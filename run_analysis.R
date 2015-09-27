featureNames <- read.table("features.txt")
activityNames <- read.table("activity_labels.txt", header = FALSE)
subjectTrain <- read.table("subject_train.txt", header = FALSE)
subjectTest <- read.table("subject_test.txt", header = FALSE)
subject <- rbind(subjectTrain, subjectTest)
activityTrain <- read.table("y_train.txt", header = FALSE)
activityTest <- read.table("y_test.txt", header = FALSE)
activity <- rbind(activityTrain, activityTest)
featuresTrain <- read.table("X_train.txt", header = FALSE)
featuresTest <- read.table("X_test.txt", header = FALSE)
features <- rbind(featuresTrain, featuresTest)
head(featureNames)
colnames(features) <- (featureNames[,2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
my_data <- cbind(features,activity,subject)
head(my_data)
dim(my_data)


columns_mean_std <- grep("mean\\(\\)|std\\(\\)", names(my_data))
columns_subset_data <-c(columns_mean_std,562,563)
subset_data<-my_data[,columns_subset_data]


subset_data$Activity = factor(subset_data$Activity, levels=c(1,2,3,4,5,6), labels = activityNames[,2])


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

tidydata <- aggregate(. ~Subject + Activity, subset_data, mean)
tidydata <- tidydata[order(tidydata$Subject,tidydata$Activity),]
write.table(tidydata, file = "My_Tidy_Data.txt", row.names = FALSE)
