#runAnalysis: Code book

Date: 22/02/2015

The runAnalysis function is meant to clean up data coming from 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip while performing the following 5 steps:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


##About the data

The dataset returned will have 4 columns

1. subject - numeric, the ID of the subject performing the activity
2. activity_type - Factor, the name of the activity performed
3. variable - factor, the measurement name
4. mean - numeric, the mean for each of the measurements per subject and activity type.

###subject

int [1:11880], values between [1:30]

###activity_type 

Factor w/ 6 levels "LAYING","SITTING", "STANDING", "WALKING", "WALKING_DOWNSTAIRS",  "WALKING_UPSTAIRS"

###variable

 Factor w/ 66 levels
 
 tBodyAcc-mean()-X
 tBodyAcc-mean()-Y
 tBodyAcc-mean()-Z
 tBodyAcc-std()-X
 tBodyAcc-std()-Y
 tBodyAcc-std()-Z
 tGravityAcc-mean()-X
 tGravityAcc-mean()-Y
 tGravityAcc-mean()-Z
 tGravityAcc-std()-X
 tGravityAcc-std()-Y
 tGravityAcc-std()-Z
 tBodyAccJerk-mean()-X
 tBodyAccJerk-mean()-Y
 tBodyAccJerk-mean()-Z
 tBodyAccJerk-std()-X
 tBodyAccJerk-std()-Y
 tBodyAccJerk-std()-Z
 tBodyGyro-mean()-X
 tBodyGyro-mean()-Y
 tBodyGyro-mean()-Z
 tBodyGyro-std()-X
 tBodyGyro-std()-Y
 tBodyGyro-std()-Z
 tBodyGyroJerk-mean()-X
 tBodyGyroJerk-mean()-Y
 tBodyGyroJerk-mean()-Z
 tBodyGyroJerk-std()-X
 tBodyGyroJerk-std()-Y
 tBodyGyroJerk-std()-Z
 tBodyAccMag-mean()
 tBodyAccMag-std()
 tGravityAccMag-mean()
 tGravityAccMag-std()
 tBodyAccJerkMag-mean()
 tBodyAccJerkMag-std()
 tBodyGyroMag-mean()
 tBodyGyroMag-std()
 tBodyGyroJerkMag-mean()
 tBodyGyroJerkMag-std()
 fBodyAcc-mean()-X
 fBodyAcc-mean()-Y
 fBodyAcc-mean()-Z
 fBodyAcc-std()-X
 fBodyAcc-std()-Y
 fBodyAcc-std()-Z
 fBodyAccJerk-mean()-X
 fBodyAccJerk-mean()-Y
 fBodyAccJerk-mean()-Z
 fBodyAccJerk-std()-X
 fBodyAccJerk-std()-Y
 fBodyAccJerk-std()-Z
 fBodyGyro-mean()-X
 fBodyGyro-mean()-Y
 fBodyGyro-mean()-Z
 fBodyGyro-std()-X
 fBodyGyro-std()-Y
 fBodyGyro-std()-Z
 fBodyAccMag-mean()
 fBodyAccMag-std()
 fBodyBodyAccJerkMag-mean()
 fBodyBodyAccJerkMag-std()
 fBodyBodyGyroMag-mean()
 fBodyBodyGyroMag-std()
 fBodyBodyGyroJerkMag-mean()
 fBodyBodyGyroJerkMag-std()
  
###mean

 num [1:11880] 0.2216 -0.0405 -0.1132 -0.9281 -0.8368 ...