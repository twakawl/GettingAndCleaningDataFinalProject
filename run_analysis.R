## Run analysis for final project Getting and cleaning data
# load packages
install_load =function (package1, ...){   
  packages =c(package1, ...)
  for(package in packages){
    if(package %in% rownames(installed.packages()))
      do.call('library', list(package))
    else {
      install.packages(package)
      do.call("library", list(package))
    }
  } 
}
install_load("reshape","reshape")

# set working directory
setwd("~/3. Trainingen/Coursera course/Getting and Cleaning Data/Final project")

# Merge the training and the test sets to create one data set.
# Load subjects
subjectTest = read.table("UCI HAR Dataset/test/subject_test.txt")
subjectTrain = read.table("UCI HAR Dataset/train/subject_train.txt")

# Load X sets
X_train = read.table("UCI HAR Dataset/train/X_train.txt")
X_test = read.table("UCI HAR Dataset/test/X_test.txt")
  
# Load Y sets
Y_train = read.table("UCI HAR Dataset/train/Y_train.txt")
Y_test = read.table("UCI HAR Dataset/test/Y_test.txt")
  
# Merge train and test sets
subject = rbind(subjectTest,subjectTrain)
colnames(subject) = "subject"

X = rbind(X_test,X_train)

Y = rbind(Y_test,Y_train)
colnames(Y) = "activity"

# Extracts only the measurements on the mean and standard deviation for each measurement.
# load feature names
features = read.table("UCI HAR Dataset/features.txt")
#set names of df
colnames(X) = features[,2]

#list of selected variables and selection in dataframe
selVar = grep(pattern = "std\\(\\)|mean\\(\\)", x = features[,2])
interested_var = as.character(features[selVar,2])
X_sub = X[,interested_var]

# Uses descriptive activity names to name the activities in the data set
activities = read.table("UCI HAR Dataset/activity_labels.txt")
Y_comb = merge(Y,activities, by.x = "activity", by.y = "V1")
colnames(Y_comb) = c("activity","activity_name")

# Appropriately labels the data set with descriptive variable names.
df = cbind(subject,X_sub,Y_comb)

#check missing values (good)
which(is.na(df))

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
avg_subj_activity = aggregate(df[,2:(ncol(df)-2)], by = df[,c(1,ncol(df))],mean)
head(avg_subj_activity)
write.table(avg_subj_activity,file = "finalproject_GettingCleaningData",row.names=FALSE)


