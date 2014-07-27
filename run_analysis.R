# We consider, that working directory is the one, where the referenced data downloaded and already unzipped.
# If no - here is the code:
if (!(file.exists("./test") & file.exists("./train"))){
  fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  # Windows version, no need in method="curl"
  zipName <- "getdata-projectfiles-UCI HAR Dataset.zip"
  download.file(fileUrl,destfile=zipName)
  unzip(zipName)
  setwd("./UCI HAR Dataset")
}

# Reading general information - labels for features and activities
features<-read.table("features.txt",sep = " ",col.names = c("feature.id","feature.label"), comment.char = "")
activities<-read.table("activity_labels.txt",sep = " ",col.names = c("activity.id","activity.label"), comment.char = "")

# Reading training data sets
y.train<-read.table("./train/y_train.txt", col.names = "activity.id", comment.char = "")
# Pre-reading of X_train.txt for identifying colClasses (for future quicker full data obtaining)
x.train<-read.table("./train/X_train.txt", comment.char = "", nrows = 100)
x.train.classes<-sapply(x.train,class)
x.train<-read.table("./train/X_train.txt", comment.char = "", colClasses = x.train.classes, col.names = features$feature.label)
subject.train<-read.table("./train/subject_train.txt", comment.char = "", colClasses = "integer", col.names = "subject.id")

# Reading test data sets.
# NOTE: step 4 ("Appropriately labels the data set with descriptive variable names") is also here
y.test<-read.table("./test/y_test.txt", col.names = "activity.id", comment.char = "")
# Here we consider classes of data in columns to be the same as for x.train, so no need in pre-reading
x.test<-read.table("./test/X_test.txt", comment.char = "", colClasses = x.train.classes, col.names = features$feature.label)
subject.test<-read.table("./test/subject_test.txt", comment.char = "", colClasses = "integer", col.names = "subject.id")

# 2. get list of features, which have "mean()" or "std()" specification in their names 
features.mean_std<-grep("*-std()|*-mean()",features$feature.label)
x.train.mean_std<-x.train[,features.mean_std]
x.test.mean_std<-x.test[,features.mean_std]
rm(x.train,x.test)

# 1. merging extracted and reduced data sets (training and test)
x.all.mean_std<-rbind(x.train.mean_std,x.test.mean_std)
rm(x.train.mean_std,x.test.mean_std)

y.all<-rbind(y.train,y.test)
rm(y.train,y.test)

subject.all<-rbind(subject.train,subject.test)
rm(subject.train,subject.test)

x.all.mean_std$activity.id<-unlist(y.all)
x.all.mean_std$subject.id<-unlist(subject.all)
rm(y.all,subject.all)

# 3. Applying descriptive activity names to the obtained data set
# Reordering levels of "activity labels" factor to correspond with appropriate indices
activity.factor.reordered<-with(activities,factor(activity.label,levels(activity.label)[c(4,6,5,2,3,1)]))
act.labels <- as.factor(x.all.mean_std$activity.id)
levels(act.labels)<-levels(activity.factor.reordered)
x.all.mean_std$activity.label<-act.labels
rm(act.labels)
x.all.mean_std<-x.all.mean_std[,-which(colnames(x.all.mean_std)=="activity.id")]
# at this point we have "activity.label" column, which is factor, instead of "activity.id" column

# 5. Creating second, independent tidy data set with the average of each variable for each activity and each subject. 
library(plyr)
avg.by.subject_vs_activity<-ddply(x.all.mean_std, .(subject.id,activity.label),mean = colMeans())

# Saving results as tidy data
write.table(avg.by.subject_vs_activity,file="tidy_data.txt",row.names=FALSE)