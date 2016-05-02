#Dowloaded all the data to my Hard drive and will now read in X_train.txt, y_train.txt, subject_train.txt,
#X_test.txt, y_traing.txt, subject_test.txt, features.txt, and activity_labels.txt

xTrain <- read.csv("/Users/reinhad/Documents/Data Scientist/Classes/Class 3 - Getting and Cleaning Data/Week 4/Week 4 Assignment/UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
yTrain <- read.csv("/Users/reinhad/Documents/Data Scientist/Classes/Class 3 - Getting and Cleaning Data/Week 4/Week 4 Assignment/UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
subjectTrain <- read.csv("/Users/reinhad/Documents/Data Scientist/Classes/Class 3 - Getting and Cleaning Data/Week 4/Week 4 Assignment/UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)


xTest <- read.csv("/Users/reinhad/Documents/Data Scientist/Classes/Class 3 - Getting and Cleaning Data/Week 4/Week 4 Assignment/UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
yTest <- read.csv("/Users/reinhad/Documents/Data Scientist/Classes/Class 3 - Getting and Cleaning Data/Week 4/Week 4 Assignment/UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
subjectTest <- read.csv("/Users/reinhad/Documents/Data Scientist/Classes/Class 3 - Getting and Cleaning Data/Week 4/Week 4 Assignment/UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)

features <- read.csv("/Users/reinhad/Documents/Data Scientist/Classes/Class 3 - Getting and Cleaning Data/Week 4/Week 4 Assignment/UCI HAR Dataset/features.txt", sep = "", header = FALSE)
activity <- read.csv("/Users/reinhad/Documents/Data Scientist/Classes/Class 3 - Getting and Cleaning Data/Week 4/Week 4 Assignment/UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)

#Step 1 - Merges the training and the test sets to create one data set.
train <-cbind(xTrain, yTrain, subjectTrain)
test <- cbind(xTest, yTest, subjectTest)
merge_train_test<-rbind(train,test)

#Remove special characters and adds describtive variables to the features table called "activity" and "subject"
features <- gsub("-",".", gsub("[\\(\\)]","",as.character(features$V2)))
col_names <- c(features, "activity","subject")
colnames(merge_train_test) <- col_names

#Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
mean_std <- subset(merge_train_test, select = col_names[grep("mean\\.|mean$|std\\.|std$|activity|subject",col_names)])
head(mean_std)

#Step 3 - Uses descriptive activity names to name the activities in the data set
#Step 4 - Appropriately label the data set with descriptive variable names
mean_std$activity
mean_std$activity <-factor(merge_train_test$activity, labels=c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))
mean_std$activity

#Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
install.packages("reshape2")
library(reshape2)
clean_mtt <- melt(mean_std, id=c("subject", "activity"))
tidy <-dcast(clean_mtt, subject + activity ~ variable, mean)

write.csv(tidy, "tidydata_smartphones.csv")

