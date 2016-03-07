#ProgrammingAssignment3
Coursera - Data Science : Getting and Cleaning Data Course Project

###Mission
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.  
First, download data linked representing data collected from the accelerometers from the Samsung Galaxy S smartphone  
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

Create one R script called run_analysis.R that does the following.  
1.Merges the training and the test sets to create one data set.  
2.Extracts only the measurements on the mean and standard deviation for each measurement.  
3.Uses descriptive activity names to name the activities in the data set  
4.Appropriately labels the data set with descriptive variable names.  
5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

##Description:the function of uploaded run_analysis.R
First, Load the package used : dplyr and tidyr. Then...  
Step 1 : Check if the source data downloded? If not, download(as UCI.zip) and unzip it to working directory  
Step 2 : Read all the needed txt after unzipped -> activity_labels,features,test, and train    
Step 3 : Merge the row of test and train data into one new data set(all_df)  
Step 4 : Extract only the variables having "mean" and "std" in their name -> New data set(mean_std_df)  
Step 5 : Merge the sunject and activity labels into mean_std_df  
Step 6 : Change names of variables according to the features.txt  
Step 7 : Create a second, independent tidy data set with average of each variables for each activity from mean_std_df  
Step 8 : Output the result by write.table as avg_df.txt  

##Codebook for avg_df.txt
Dimension row 14220, column 6   
Sorted order by  
Column[1] Subject : the label of subjects tested, from 1 : 30   
Column[2] Activity : "LAYING", "SITTING", "STANDING", WALKING", "WALKING_DOWNSTAIRS", and "WALKING_UPSTAIRS"  

Split the names from features.txt to 3 columns   
Column[3] Features : feature names  
Column[4] Type : mean or std?  
Column[5] Direction : X, Y, or Z  

Result  
Column[6] Average : average of each feature of each subject and its activity 
