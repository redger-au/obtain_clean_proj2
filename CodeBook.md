Introduction
---------------------------------------------------------------------------------------------------------------
This codebook describes the data contained in the summary file ("/data/$OUTPUT/wearable_summary_tidy.txt") produced by "run_analysis.R"

Source Data
---------------------------------------------------------------------------------------------------------------
The data is based on source data downloaded from  
               "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  
                as described at "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"  
                Human Activity Recognition Using Smartphones Dataset Version 1.0  

The data results from experiments carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details.  

Data collected was  

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.  
* Triaxial Angular velocity from the gyroscope.   
* A 561-feature vector with time and frequency domain variables.  
* Its activity label.  
* An identifier of the subject who carried out the experiment.  


The data of interest is in 3 groups of files (extracted from the compressed file which was downloaded)  

1.  Reference Data  
  +  activity_labels.txt - decode activity codes (numeric) into a description  
  +  features.txt - names all the data columns in "X.txt" files  

2.  Test Data  
  +  /test/subject.txt - a coded id for the subject observation data was derived from (one row for each observation)
  +  /test/y.txt - a coded id for the activity data was derived from (one row for each observation)
  +  /test/X.txt - the observation data (one row for each observation)

3.  Train Data
  +  /train/subject.txt - a coded id for the subject observation data was derived from (one row for each observation)
  +  /train/y.txt - a coded id for the activity data was derived from (one row for each observation)
  +  /train/X.txt - the observation data (one row for each observation)


Data Transformations
---------------------------------------------------------------------------------------------------------------
The column name data from "features.txt" is scanned for those names containing "-mean" or "-std" followed by a special character eg."(", only these names are retained for further processing, others are discarded.  

    NOTE there are additional fields containing potential "mean" data, but they look a bit odd so were ignored. 
    They can be included using an optional parameter to the "read_files()" function - set booInclude_all_mean_std_cols=TRUE  

Retained column names are modified for clarity as follows (semantic elements are separated and expanded)  

    *  the "t" and "f" prefixes are translated to "time_" and "freq_" respectively
    *  the "Accel" and "Gyro" literal elements are translated to "_Accelerometer" and "_Gyroscope" respectively
    *  the "Jerk" and "Mag" literal elements are translated to "_Jerk" and "_Magnitude" respectively
    *  the "-std" literal element is translated to "-stdeviation"
    *  the "-X" and "-Y" and "-Z" literal elements are translated to "-Xaxis", "-Yaxis" and "-Zaxis" respectively
    *  instances of "()" are removed
    *  all dashes ("-") are translated to underscores ("_") to be "parser safe" whilst retaining readability

The Train "subject" and "y" data files were "bound" together as additional columns to the "X" file, along with a new column containing a literal "train" (column named "sourcecategory")  

Similarly the Test "subject" and "y" data files were "bound" together as additional columns to the "X" file, along with a new column containing a literal "test" (column named "sourcecategory")  

The appropriate column headings were applied ("sourcecategory", subject" and "activity" prepended to the previously processed column names)  

The consolidated Train and Test data were then further consolidated into a single "long" dataset  

Additionally the "activity" column was decoded, substituting descriptions for the original numeric code  

The above transformations produce the intermediate file on which summary processing is performed  

The above data is then summarised as

*  The average of each variable for each activity and each subject
*  Additionally the sourcecategory column is dropped


FIELD (Column) Definitions For Output File (wearable_summary_tidy.txt)
-----------------------------------------------------------------------
The first 2 fields (columns) are defined here as they are the "key" data whereas the rest are all measurement data  

Field Name | Description | Class | Values
---------- | ----------- | ----- | ------
activity | Describes the activity attributed to this observation. | Character | WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING  
subject  | Code number referring to the subject (coded for privacy) this observation was gathered from | Character | numbers in the range 1-30 as characters)  

  
The following fields (columns) are all numeric. And they contain data as defined by their name elements, as follows  

------------------------------------------------------
Element | Description  
------- | -----------
time_    | time based measurement in seconds (normalized and bounded within [-1,1])  
freq_    | frequency based measurement in hz (normalized and bounded within [-1,1])  
 Body_            | Data attributed to body movement  
 Gravity_         | Data attributed to force of gravity  
 Accelerometer_   | Data collected from the accelerometer  
 Gyroscope_       | Data collected from the gyroscope  
 Jerk_            | Observation of a recognised "Jerk" signal  
 Magnitude_       | Magnitude of the signal in the designated axis  
 _stdeviation     | The source is a standard deviation  
 _mean            | The source is a mean  
 _Xaxis           | Data measured on the X axis  
 _Yaxis           | Data measured on the Y axis  
 _Zaxis           | Data measured on the Z axis  

    Thus "time_Body_Accelerometer_mean_Xaxis" is a time based metric, from the accelerometer, attributed to body movement and this is the mean of the X-axis movement  
  
IN EACH CASE THE VALUE IS ACTUALLY THE MEAN OF SUPPLIED OBSERVATIONS PER ACTIVITY AND SUBJECT  
  
Remaining field (column) names ==>  

Field Name | Class | Values | Metric  
---------- | ----- | ------ | ------
time_Body_Accelerometer_mean_Xaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Accelerometer_mean_Yaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Accelerometer_mean_Zaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Accelerometer_stdeviation_Xaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Accelerometer_stdeviation_Yaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Accelerometer_stdeviation_Zaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Gravity_Accelerometer_mean_Xaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Gravity_Accelerometer_mean_Yaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Gravity_Accelerometer_mean_Zaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Gravity_Accelerometer_stdeviation_Xaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Gravity_Accelerometer_stdeviation_Yaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Gravity_Accelerometer_stdeviation_Zaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Accelerometer_Jerk_mean_Xaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Accelerometer_Jerk_mean_Yaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Accelerometer_Jerk_mean_Zaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Accelerometer_Jerk_stdeviation_Xaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Accelerometer_Jerk_stdeviation_Yaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Accelerometer_Jerk_stdeviation_Zaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_mean_Xaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_mean_Yaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_mean_Zaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_stdeviation_Xaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_stdeviation_Yaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_stdeviation_Zaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_Jerk_mean_Xaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_Jerk_mean_Yaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_Jerk_mean_Zaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_Jerk_stdeviation_Xaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_Jerk_stdeviation_Yaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_Jerk_stdeviation_Zaxis| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Accelerometer_Magnitude_mean| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Accelerometer_Magnitude_stdeviation| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Gravity_Accelerometer_Magnitude_mean| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Gravity_Accelerometer_Magnitude_stdeviation| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Accelerometer_Jerk_Magnitude_mean| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Accelerometer_Jerk_Magnitude_stdeviation| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_Magnitude_mean| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_Magnitude_stdeviation| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_Jerk_Magnitude_mean| Numeric | Number In Range [-1,1] | Time (normalised)  
time_Body_Gyroscope_Jerk_Magnitude_stdeviation| Numeric | Number In Range [-1,1] | Time (normalised)  
freq_Body_Accelerometer_mean_Xaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Accelerometer_mean_Yaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Accelerometer_mean_Zaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Accelerometer_stdeviation_Xaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Accelerometer_stdeviation_Yaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Accelerometer_stdeviation_Zaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Accelerometer_Jerk_mean_Xaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Accelerometer_Jerk_mean_Yaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Accelerometer_Jerk_mean_Zaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Accelerometer_Jerk_stdeviation_Xaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Accelerometer_Jerk_stdeviation_Yaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Accelerometer_Jerk_stdeviation_Zaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Gyroscope_mean_Xaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Gyroscope_mean_Yaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Gyroscope_mean_Zaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Gyroscope_stdeviation_Xaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Gyroscope_stdeviation_Yaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Gyroscope_stdeviation_Zaxis| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Accelerometer_Magnitude_mean| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_Body_Accelerometer_Magnitude_stdeviation| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_BodyBody_Accelerometer_Jerk_Magnitude_mean| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_BodyBody_Accelerometer_Jerk_Magnitude_stdeviation| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_BodyBody_Gyroscope_Magnitude_mean| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_BodyBody_Gyroscope_Magnitude_stdeviation| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_BodyBody_Gyroscope_Jerk_Magnitude_mean| Numeric | Number In Range [-1,1] | Frequency (normalised)  
freq_BodyBody_Gyroscope_Jerk_Magnitude_stdeviation| Numeric | Number In Range [-1,1] | Frequency (normalised)  


