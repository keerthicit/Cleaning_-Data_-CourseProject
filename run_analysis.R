#Author: Keerthi Murugesan Date: 18-Apr-18 

#run_analysis.R script to do the following actions
# 
# 1. Download the dataset form URL and extract the contents to the data folder
# 2. Merges the training and the test sets to create one data set.
# 3. Extracts only the measurements on the mean and standard deviation for each measurement.
# 4. Uses descriptive activity names to name the activities in the data set
# 5. Appropriately labels the data set with descriptive variable names.
# 6. From the data set in above step, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
# 7. Store the new independent data set to new CSV file


run_analysis <- function(){
                
        ##Loading required Libraries
        
        library(data.table)
        library(dplyr)
        
        ## Set data set URL for download in dataURL
        
        dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        
        
        ##Download Dataset and store it in the path
        
        download.file(dataURL,"./data/FUCI_HAR_Dataset.zip", method = "curl")
        
        ##Unzip the files
        
        unzip("./data/FUCI_HAR_Dataset.zip", exdir = "./data")
        
        ##set the path to the extracted folder
        
        path <- "./data/UCI HAR Dataset"
        
        ## Read the files X_train.txt and X_test.txt using readFile(), merge them using rbind and store the result in 'x_combined'
        
        x_combined <- rbind(readFile(paste(path, "train", sep = "/"), "X_train.txt"),
                   readFile(paste(path, "test", sep = "/"), "X_test.txt"))
        
        
        ## Read the files y_train.txt and y_test.txt using readFile(), merge them with rbind and store the result in 'y_combined'
        
        y_combined <- rbind(readFile(paste(path, "train", sep = "/"), "y_train.txt"),
                   readFile(paste(path, "test", sep = "/"), "y_test.txt"))
        
        
        ## Read the files subject_train.txt and subject_test.txt using readFile(), merge them using rbind and store in 'sub_combined'
        
        sub_combined <- rbind(readFile(paste(path, "train", sep = "/"), "subject_train.txt"),
                            readFile(paste(path, "test", sep = "/"), "subject_test.txt"))
        
        
        ## Read activity_labels.txt using readFile() and store the result in 'act_labels'
        
        act_lbl <- readFile(path, "activity_labels.txt")
        
        
        ## Read features.txt using readFile() and store the result in features
        
        
        features <- readFile(path, "features.txt")
        
        
        ##Add column names for 'x_combined' using names(), with labels extracted from 'features'
        
        names(x_combined) <- features$V2
        
        
        ##With x_combined do following actions
        
        x_combined <- tbl_df(x_combined %>%
             
             ##Trim x_combined to have only the measurements on the mean and standard deviation for each measurement using subset() function
             
             subset( TRUE, (grepl("*mean*", names(.)) | grepl("*std*", names(.)))) %>%
             
                     
                ##find the activity description from act_labels with activity ID from y_combined and add to new column to x_combined
             
                ##Add subject from sub_combined as a new column to x_combined
             
                cbind(subject = sub_combined$V1, activity_type = act_lbl$V2[match(y_combined$V1, act_lbl$V1)], .))
        
        
        ## final_data: independent tidy data set with the average of each variable grouped by activity and subject
        
        final_data <- x_combined %>% 
                group_by(subject, activity_type) %>% 
                summarise_all(funs(mean))
       
        ##Write the independent tidy data set to tidy_data.txt
        
        write.table(final_data, file = paste(path, "tidy_data.txt", sep = "/"), row.names = FALSE)
}


##Function gets file path, name and header availability as arguments 
##checks for file existence and reads the file 
##Return table data frame if file found, else return null
##Arguments:- 
##1. path - String - Folder in which the file is location
##2. fileName - String - Name of the file to be read
##3. hearderVal - Boolean - True or False for hearder row, default value is Flase
##Libraries needed: data.table, dplyr

readFile <- function(path, fileName, headerVal = FALSE) {

        ##concatenate path and filename to path
        
        path <- paste(path, fileName, sep = "/")
        
       ##Check if file exits in the path
        
        if (!file.exists(path)) {
        
                print(paste("File not found at", path))
        
                return(NULL)
        
        }
        
        else tbl_df(fread(path, header = headerVal))        
}