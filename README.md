---
title: "run_analysis.R description"
output: html_document
---

This file contains the description of the *run_analysis.R* script. Actually, the body of the script is also documented, so this explanation may be redundant.

1. Identifying, if current working directory contains needed data. If no - retrieve it from the source and switch to unzipped directory.


```r
if (!(file.exists("./train") & file.exists("./test"))){
  fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  zipName <- "getdata-projectfiles-UCI HAR Dataset.zip"
  # Windows version, no need in method="curl"
  download.file(fileUrl,destfile=zipName)
  unzip(zipName)
  setwd("./UCI HAR Dataset")
}
```

2. Reading general information - labels for features and activities.


```r
features<-read.table("features.txt",sep = " ",col.names = c("feature.id","feature.label"), comment.char = "")
activities<-read.table("activity_labels.txt",sep = " ",col.names = c("activity.id","activity.label"), comment.char = "")
```

3. Reading training data sets. Need note, that **step 4** (about appropriate labeling the data sets with descriptive variable names) is also included in this code. Large data set *X_train.txt* retrieving may require a lot of time and memory. That is why we use pre-reading of first 100 rows to identify *colClasses*, then read the whole data set.


```r
y.train<-read.table("./train/y_train.txt", col.names = "activity.id", comment.char = "")
# Pre-reading of X_train.txt for identifying colClasses (for future quicker full data obtaining)
x.train<-read.table("./train/X_train.txt", comment.char = "", nrows = 100)
x.train.classes<-sapply(x.train,class)
x.train<-read.table("./train/X_train.txt", comment.char = "", colClasses = x.train.classes, col.names = features$feature.label)
subject.train<-read.table("./train/subject_train.txt", comment.char = "", colClasses = "integer", col.names = "subject.id")
```

4. Reading test data sets.  The code is the same, but for extracting *X_test.txt* we use the same *colClasses* as for *X_train.txt*.



5. Getting the list of features, which have "mean()" or "std()" specification in their names.


```r
features.mean_std<-grep("*-std() | *-mean()",features$feature.label)
x.train.mean_std<-x.train[,features.mean_std]
x.test.mean_std<-x.test[,features.mean_std]
rm(x.train,x.test)
```


6. Merging extracted and reduced data sets (training and test).


```r
x.all.mean_std<-rbind(x.train.mean_std,x.test.mean_std)
y.all<-rbind(y.train,y.test)
subject.all<-rbind(subject.train,subject.test)
x.all.mean_std$activity.id<-unlist(y.all)
x.all.mean_std$subject.id<-unlist(subject.all)
```



7. Applying descriptive activity names to the obtained data set.


```r
# Reordering levels of "activity labels" factor to correspond with appropriate indices
activity.factor.reordered<-with(activities,factor(activity.label,levels(activity.label)[c(4,6,5,2,3,1)]))
act.labels <- as.factor(x.all.mean_std$activity.id)
levels(act.labels)<-levels(activity.factor.reordered)
x.all.mean_std$activity.label<-act.labels
rm(act.labels)
x.all.mean_std<-x.all.mean_std[,-which(colnames(x.all.mean_std)=="activity.id")]
```

At this point we have *activity.label* column, which is factor, instead of *activity.id* column.


8. Creating the second, independent tidy data set with the average of each variable for each activity and each subject. 


```r
library(plyr)
avg.by.subject_vs_activity<-ddply(x.all.mean_std, .(subject.id,activity.label),mean = colMeans())
setwd("../")
# Saving results as tidy data
write.table(avg.by.subject_vs_activity,file="tidy_data.txt",row.names=FALSE)
```

