#runAnalysis

Date: 22/02/2015

The runAnalysis function is meant to clean up data coming from 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and perform the following 5 steps:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The function will download the file from the above remove location unless it finds a /data folder, 
in which case it expects that the dataset has already been downloaded.

The function starts with writing down a metadata file with the date and time of when the file has 
been downlaoded.


##1. Merges the training and the test sets to create one data set.
It reads the X_train, X_test datasets containing the measurements and binds them together using the *rbind()* function.
It does the same for the y_train and y_test which contain the type of activity each measurement refers to.
It also merges the subject_test and subject_train, these files contains Ids that map each observation to an individual.

##2. Extracts only the measurements on the mean and standard deviation for each measurement.
The assignment requests to extract  mean and standard deviation, the dataset contains features for
* mean(): Mean value
* std(): Standard deviation
but also values for 
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency

For this exercise I have decided to exclude meanFreq() measuments, it is not very clear from the requirements if this measurement had to be included, I have decided to exclude those as although their name includes the word mean, the measurements description seems to be going beyond the description of just 'mean'.

I have used the grep() function to extract the features ending with std() and and mean()

##3. Uses descriptive activity names to name the activities in the data set
The y_train and y_test files contain the id of the activities that the subject was performing for each observation, the activity_label.txt file contains a description for each of these activities.
I have joined the description to the result of the merge of y_train and y_test done in the first step, and then used the mutate() function of the dplyr package to add an extra column to the  main dataset.

##4. Appropriately labels the data set with descriptive variable names. 
The features file contains a descriptive name for each of the measuments in the main dataset.
I have used the names() function to apply a heading to each of the measurements.

##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
There has been various discussions in the course forum on whether a tidy dataset should keep each measument in their own column and consider the set of measurements one observation or whether we should have considered each measument an observation of their own. I personally don't think there is a right or wrong way as I believe it depends very much on the type of analysis that it will need to be done after the tidy up, which is not clear from the requirements.
As such, I have decided to interpret each measurement as a single observation and "melt" the data so to end up with 4 columns:
1. subject
2. activity_type
3. variable
4. mean

subject         activity_type           variable                mean

4               WALKING_DOWNSTAIRS        fBodyAccJerk-std()-Y -1.772021e-01
4               WALKING_DOWNSTAIRS        fBodyAccJerk-std()-Z -6.688673e-01
4               WALKING_DOWNSTAIRS          fBodyGyro-mean()-X -2.402989e-01
4               WALKING_DOWNSTAIRS          fBodyGyro-mean()-Y -7.175458e-01

To accomplish this I have used the melt() function of the dpyr package and the ddply to summarise the measurments and calculate the mean.

The analysis script at this point will create a tidy_data folder and  will save a file in a there containing the result of the analysis as well as returning the tidy dataset.