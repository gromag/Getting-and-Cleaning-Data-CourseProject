runAnalysis <- function(){

        #Variables declaration
        
        datasetUrl              <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        dataFolder              <- "./data"
        datasetArchive          <- paste(dataFolder, "/dataset.zip", sep="")
        rawDataFolder           <- paste(dataFolder, "/raw", sep="")
        metaDataFile            <- paste(dataFolder, "/download_metadata.txt", sep="")
        processingFolder        <- paste(dataFolder, "/processing", sep="")
        tidyFolder              <- paste(dataFolder, "/tidy_data", sep="")
        tidyFilePath            <- paste(tidyFolder, "/tidy_data.txt", sep="")
        rawInnerFolder          <- paste(rawDataFolder, "/UCI HAR Dataset", sep="")
        trainFolder             <- paste(rawInnerFolder, "/train", sep="")
        testFolder              <- paste(rawInnerFolder, "/test", sep="")
        #Train set of files paths
        trainXFile              <- paste(trainFolder, "/X_train.txt", sep="")
        trainSubjectFile        <- paste(trainFolder, "/subject_train.txt", sep="")
        trainYFile              <- paste(trainFolder, "/y_train.txt", sep="")
        #Test set of file paths
        testXFile               <- paste(testFolder, "/X_test.txt", sep="")
        testSubjectFile         <- paste(testFolder, "/subject_test.txt", sep="")
        testYFile               <- paste(testFolder, "/y_test.txt", sep="")
        # File containing descriptive names for the observations in Train and Test file
        featuresFile            <- paste(rawInnerFolder, "/features.txt", sep="")
        activitiesFile          <- paste(rawInnerFolder, "/activity_labels.txt", sep="")
        
        # Download raw data from remote location if that was not done before
        # Note: here we are assume that if the data folder has been created 
        # then this will already contain the raw data.
        
        if(!file.exists(dataFolder)) { 
                message("Creating data directory")                                
                dir.create(dataFolder)
                message("Downloading file from remote location")
                download.file(datasetUrl, datasetArchive)        
                
                # Recording date and time and other details like checksum of the file just 
                # downloaded.
                message("Recording date and time and other file details")
                library(tools) # md5sum       
                
                sink(metaDataFile)
                print("Download date:")
                print(Sys.time())
                print("Download URL:")
                print(datasetUrl)
                print("Downloaded file Information")
                print(file.info(datasetArchive))
                print("Downloaded file md5 Checksum")
                print(md5sum(datasetArchive))
                sink()
                message("Unarchiving file")
                unzip(zipfile = datasetArchive, exdir = rawDataFolder)
        }
        
        
        
        
        # Reading raw data
        # Reading train and test values
        message("Reading X_train data")
        xTrainTbl               <- read.table(trainXFile)
        message("Reading X_test data")
        xTestTbl                <- read.table(testXFile)
        
        # Reading file that define the type of activity for each of the recordings above
        message("Reading y_train data")
        yTrainTbl               <- read.table(trainYFile)
        message("Reading y_test data")
        yTestTbl                <- read.table(testYFile)
        
        # Reading file that define who perfomed the activity recorded above
        message("Reading subject_train data")
        subjectTrainTbl         <- read.table(trainSubjectFile)
        message("Reading subject_test data")
        subjectTestTbl          <- read.table(testSubjectFile)
        
        # *****************************************************************************
        # 1. Merge training set and test set for all required files
        # *****************************************************************************
        message("Binding train and test data sets")
        xTrainAndTestTbl        <- rbind(xTrainTbl, xTestTbl) 
        yTrainAndTestTbl        <- rbind(yTrainTbl, yTestTbl)
        subjectTrainAndTestTbl  <- rbind(subjectTrainTbl, subjectTestTbl)
        
        # *****************************************************************************
        # 2. Extracts only the measurements on the mean and standard deviation for each
        #    measurement. 
        # *****************************************************************************
        message("Reading required features")
        features <- read.table(featuresFile) 
        # Using grep to filter out any feature whose description matches
        # std() or mean(), these are the only features we are interested in.
        # I can safely overwrite the features variable, the full set is no needed for 
        # this assignment.        
        features <- features[grep("(std|mean)\\(\\)", features[,2]),]
        
        # The first column of the features table holds the indexes of the features we
        # are intereset in.
        message("Extracting only required measurements")
        xTrainAndTestTbl        <- xTrainAndTestTbl[,features[,1]]
        
        
        # *****************************************************************************
        # 3. Uses descriptive activity names to name the activities in the data set
        # *****************************************************************************
        message("Reading the activity types")
        activitiesTbl <- read.table(activitiesFile)

        library(dplyr)
        
        # Here we are joining the Activity labels to data set holding only the activity Ids
        yActivities <- join(yTrainAndTestTbl, activitiesTbl, by="V1", type="left" )
        
        # Here we are adding an the activity column to the main datset
        message("Adding activities to the main dataset")
        xTrainAndTestTbl        <- mutate(xTrainAndTestTbl, yActivities[,2])
                
        # *****************************************************************************
        # 4. Appropriately labels the data set with descriptive variable names. 
        # *****************************************************************************
        
        # Appropriately labelling the column of each feature with the correct feature name
        names(xTrainAndTestTbl) <- features[,2]
        
        # Naming also the activity type column previously added.
        names(xTrainAndTestTbl)[ncol(xTrainAndTestTbl)] <- "activity_type"
        
        
        
        # *****************************************************************************
        # 5. From the data set in step 4, creates a second, independent tidy data set 
        #    with the average of each variable for each activity and each subject.
        # *****************************************************************************
        
        message("Starting tidying data")
        
        xCols <- ncol(xTrainAndTestTbl)     
        
        # Rearranging the data so that it is in the following order:
        # 1) subject, 2) activity_type, 3...N) others 
        temp <- data.frame(subjectTrainAndTestTbl, xTrainAndTestTbl[, xCols], xTrainAndTestTbl[,1:xCols -1])
        
        # Calculating the column names in the new order
        colNames <- c("subject", names(xTrainAndTestTbl)[xCols], names(xTrainAndTestTbl)[1:xCols-1])
        
        names(temp) <- colNames
        
        #Reshaping data so that we have only 4 columns:
        # 1) subject, 2) activity_type, 3) measurement type, 4) value        
        
        message("Reshaping data")

        tidyDataSet <- melt(temp, id= c("subject", "activity_type"), measure.vars = names(temp)[3:ncol(temp)])
        
        message("Calculating average for each variable/activity/subject combination")
        tidyDataSet <- ddply(tidyDataSet, .(subject, activity_type, variable), summarize, mean = mean(value))
        
        if(!file.exists(tidyFolder)){
                message("Creating tidy data folder")
                dir.create(tidyFolder)
                message("Saving tidy data into file")
                write.table(tidyDataSet, file= tidyFilePath, col.names=FALSE, row.names=FALSE)
        }
                
        tidyDataSet        
}