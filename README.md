# obtain_clean_proj2
Coursera Getting &amp; Cleaning Data Course - Project #2 software

This software is provided under the GPL licence
This is free software and comes with ABSOLUTELY NO WARRANTY
Use this software at your own risk, no responsibility is accepted for issues or problems arising from use of this software

There's a single executable for this project, to be run via R
    run_analysis.R
  The code was developed and tested on a Linux system
  Windows & Mac users 
    
The executable is set up to -
  Automagically execute via 'source("run_analysis.R")' 
  ie. there are executable statements at the end of the file in addition to the 3 functions which actually "do the work"
  
When the executable is run, 2 new sub-directories will be created (if they don't already exist)
  /data     Contains the input data downloaded & decompressed
  /data/$OUTPUT  Contains the output data (summary file[s])
  
The Summary output (file) will be saved in the $OUTPUT subdirectory as 
  /data/$OUTPUT/wearable_summary.txt
  If this file already exists - it will be over-written
  
  The output file will be written in text format
    The first line contain field(column) names
    Fields(columns) are separated by a blank(space)

Data contained within the "wearable_summary.txt" file is described in 
  CodeBook.md

The executable R code in "run_analysis.R" contains extensive comments / documentation
Refer to the executable file for execution options. These would not normally be used but are available for the adventurous


The project is designed to -
    Download, save and decompress the wearables data from
               "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                as described at "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"
                This data was collected from the accelerometers from the Samsung Galaxy S smartphone.

    The project will 
    1) Merge the training and the test sets to create one data set.
    2) Extract only the measurements on the mean and standard deviation for each measurement.
    3) Use descriptive activity names to name the activities in the data set
    4) Appropriately label the data set with descriptive variable names.
    5) From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
