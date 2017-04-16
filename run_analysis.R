library(reshape2)

#Assume the working directory is '.../getdata%2Fprojectfiles%2FUCI HAR Dataset'
ActivityLabels <- read.table('UCI HAR Dataset/activity_labels.txt')
Features <- read.table('UCI HAR Dataset/features.txt')

#Extract only the measurements on the mean and standard deviation for each measurement
SelectedFeatures <- grep('mean|std', Features[, 2])

#Appropriately label the data set with descriptive variable names
SelectedFeaturesNames <- Features[, 2][SelectedFeatures]
SelectedFeaturesNames <- tolower(SelectedFeaturesNames)
SelectedFeaturesNames <- gsub('-', '', SelectedFeaturesNames)
SelectedFeaturesNames <- gsub('[()])', '', SelectedFeaturesNames)


#Read, manipulate and determine the training data set
XTrain <- read.table('UCI HAR Dataset/train/X_train.txt')
YTrain <- read.table('UCI HAR Dataset/train/y_train.txt')
SubjectTrain <- read.table('UCI HAR Dataset/train/subject_train.txt')
Train <- cbind(SubjectTrain, YTrain, XTrain[SelectedFeatures])

#Read, manipulate and determine the test data set
XTest <- read.table('UCI HAR Dataset/test/X_test.txt')
YTest <- read.table('UCI HAR Dataset/test/y_test.txt')
SubjectTest <- read.table('UCI HAR Dataset/test/subject_test.txt')
Test <- cbind(SubjectTest, YTest, XTest[SelectedFeatures])

#Merge the training and the test sets to create one data set
AllData <- rbind(Train, Test)
colnames(AllData) <- c('subject', 'activity', SelectedFeaturesNames)

#Use descriptive activity names to name the activities in the data set
AllData$activity <- factor(AllData$activity, levels = ActivityLabels[, 1], labels = ActivityLabels[, 2])

#Create a second, independent tidy data set with the average of each variable for each activity and each subject
AllDataMelted <- melt(AllData, id = c('subject', 'activity'))
TidyData <- dcast(AllDataMelted, subject + activity ~ variable, mean)

#Save the tidy data
write.table(TidyData, 'tidy_data.txt', row.names = FALSE, quote = FALSE)
