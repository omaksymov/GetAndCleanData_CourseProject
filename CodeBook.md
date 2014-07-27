Tidy data set variables' description
===============================

Description of initial data sets can be found at *feature_info.txt* and *README.txt* inside original [data source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
In particular, there we can obtain description for the signals, which are used for making further estimations:

tBodyAcc-XYZ  
tGravityAcc-XYZ  
tBodyAccJerk-XYZ  
tBodyGyro-XYZ  
tBodyGyroJerk-XYZ  
tBodyAccMag  
tGravityAccMag  
tBodyAccJerkMag  
tBodyGyroMag  
tBodyGyroJerkMag  
fBodyAcc-XYZ  
fBodyAccJerk-XYZ  
fBodyGyro-XYZ  
fBodyAccMag  
fBodyAccJerkMag  
fBodyGyroMag  
fBodyGyroJerkMag  

Among estimations there were sets of variables

* mean(): Mean value
* std(): Standard deviation

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

The task of the project was to use only **mean** and **standard deviation**. That is why we used regular expression 

```
features.mean_std<-grep("*-std() | *-mean()",features$feature.label)
```
to extract only that variables. As a result - set of 79 variables:

tBodyAcc.mean...[X-Z]  
tBodyAcc.std...[X-Z]  
tGravityAcc.mean...[X-Z]  
tGravityAcc.std...[X-Z]  
tBodyAccJerk.mean...[X-Z]  
tBodyAccJerk.std...[X-Z]  
tBodyGyro.mean...[X-Z]  
tBodyGyro.std...[X-Z]  
tBodyGyroJerk.mean...[X-Z]  
tBodyGyroJerk.std...[X-Z]  
tBodyAccMag.mean..  
tBodyAccMag.std..  
tGravityAccMag.mean..  
tGravityAccMag.std..  
tBodyAccJerkMag.mean..  
tBodyAccJerkMag.std..  
tBodyGyroMag.mean..  
tBodyGyroMag.std..  
tBodyGyroJerkMag.mean..  
tBodyGyroJerkMag.std..  
fBodyAcc.mean...[X-Z]  
fBodyAcc.std...[X-Z]  
fBodyAcc.meanFreq...[X-Z]  
fBodyAccJerk.mean...[X-Z]  
fBodyAccJerk.std...[X-Z]  
fBodyAccJerk.meanFreq...[X-Z]  
fBodyGyro.mean...[X-Z]  
fBodyGyro.std...[X-Z]  
fBodyGyro.meanFreq...[X-Z]  
fBodyAccMag.mean..  
fBodyAccMag.std..  
fBodyAccMag.meanFreq..  
fBodyBodyAccJerkMag.mean..  
fBodyBodyAccJerkMag.std..  
fBodyBodyAccJerkMag.meanFreq..  
fBodyBodyGyroMag.mean..  
fBodyBodyGyroMag.std..  
fBodyBodyGyroMag.meanFreq..  
fBodyBodyGyroJerkMag.mean..  
fBodyBodyGyroJerkMag.std..  
fBodyBodyGyroJerkMag.meanFreq..  

The last two variables in the tidy data set are *subject.id* and *activity.label*. They correspond to the index of the subject, whose data is represented in particular set of measurements, and appropriate activity name (*WALKING*, *WALKING_UPSTAIRS*, *WALKING_DOWNSTAIRS*,*STANDING*,*SITTING*,*LAYING*) in human-readable format respectively. 

Totally, we have 81 variables and 10299 observations (7352 for training set + 2947 for the test set) in our tidy data set.