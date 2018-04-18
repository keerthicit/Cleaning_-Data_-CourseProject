---
title: "Codebook"
author: "Keerthi Murugesan"
date: "18 April 2018"
output: html_document
---

Codebook for my CourseProject of Getting & Cleaning Data course

This code book is for run_analysis.R script to do the following actions

1. Download the dataset form URL and extract the contents to the data folder
2. Merges the training and the test sets to create one data set.
3. Extracts only the measurements on the mean and standard deviation for each measurement.
4. Uses descriptive activity names to name the activities in the data set
5. Appropriately labels the data set with descriptive variable names.
6. From the data set in above step, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
7. Store the new independent data set to txt file
________________________________________________________________________________________________________

Variables:

1. dataURL         - Type: String  Value: Data set URL to download data from
2. path            - Type: String  Value: Local path where the files are stored
3. x_combined      - Type: tibble  Value: combined values of X_train.txt and X_test.txt
4. y_combined      - Type: tibble  Value: combined values of y_train.txt and y_test.txt
5. sub_combined    - Type: tibble  Value: combined values of  subject_train.txt and subject_test.txt
6. act_lbl         - Type: tibble  Value: values of activity_labels.txt
7. features        - Type: tibble  Value: values of features.txt
8. final_data      - Type: tibble  Value: Final tidy independent dataset  
________________________________________________________________________________________________________

Functions:

run_analysis():

Purpose: Function that performs all the activites and produces the output file with Tidy data

Input: No Input

Output: tidy_data.txt file with tidy data under ./data/UCI HAR Dataset folder

Steps:

1. Load required Librabries

2. Download data from 'dataURL' using download.file()

3. Unzip the dataset to .data folder using unzip()

4. set 'path' value to ./data/UCI HAR Dataset

5. Read the files X_train.txt and X_test.txt using readFile(), merge them using rbind and store the result in 'x_combined' - resulting tibble: 10,299 x 561

6. Read the files y_train.txt and y_test.txt using readFile(), merge them using rbind and store the result in 'y_combined' - resulting tibble: 10,299 x 1

7. Read the files subject_train.txt and subject_test.txt using readFile(), merge them using rbind and store the result in 'sub_combined' - resulting tibble: 10,299 x 1

8. Read activity_labels.txt using readFile() and store the result in 'act_lbl' - resulting tibble: 6 x 2

9. Read features.txt using readFile() and store the result in 'features' - resulting tibble: 561 x 2

10. Add column names for 'x_combined' using names(), with labels extracted from 'features'

11. Trim 'x_combined' with subset(), only to have column names containing "mean" or "std" (using grep1 on names(x_combined)) - resulting tibble: 10299 x 79

12. Extracted the activity description for all rows in 'y_combined' from 'act_lbl' using match() matching the activity ID in 'y_combined' and 'act_lbl' and added to 'x_combined' along with subject from 'sub_combined' using cbind(). resulting tibble: 10299 x 81

13. Group 'x_combined' data with columns 'activity_type' and 'subject' using group_by() and find average for other columns by applying summarise_all(mean) to the result from group_by() and store it in 'final_data'. resulting tibble: 180 x 81

14. write 'final_data' into tidy_data.txt using write.table()
________________________________________________________________________________________________________

readfile():

Purpose: To read a file using fread() fucntion and return as tibble 

Input: 

1. path         - Type: String  Value: folder path 

2. fileName     - Type: String  Value: file name

3. headerVal    - Type: logical Value: TRUE if header present in the file, else FALSE (default value)


Output: a tibble with file content if file is present, else NULL
____________________________________________________________________________________________________

Libraries:

1. data.tables
2. dplyr