# -----------------------------------------------------------#
# Getting & Cleaning Data - Final Project
# R script file
#
# This software is provided under the GPL licence
# This is free software and comes with ABSOLUTELY NO WARRANTY
# Use this software at your own risk, no responsibility is accepted for issues or problems arising from use of this software
#
# Downloads & Saves data from the internet - FUNCTION obtain_data()
#    Creates a new SubDirectory "data" (if it doesn't already exist)
#    Saves the files
#    Decompresses the files
#    NOTE will only perform steps which do NOT appear to have been performed previously
#
# Reads downloaded data & pre-processes it - FUNCTION read_files (booInclude_all_mean_std_cols=FALSE, booWrite_output_file=TRUE)
#    Parameter - booInclude_all_mean_std_cols
#                Should we include ALL columns containing "mean" or "std" (TRUE)
#                Or just those those containing "mean()" or "std()" ie. the ones that look like "real" means ans std's. (FALSE, default)
#
#    Parameter - booWrite_output_file
#                Should we write our working data to a text file in the output directory (TRUE)
#                Or not write anything. (FALSE, default)
#
#    NOTE Files must have been downloaded and decompressed into the ./data directory before executing this function (run obtain_data() first)
#
#    Reads all the files of interest ie.
#        Reference data => features (column names), activity code descriptions, subject ids
#        Experimental data => subject, activity, observations - for each of Train and Test
#
#    Selects the column names of interest
#    Translate column names into something more readable
#
#    Translates experimental activity codes into readable activity names
#    Composes and formats the working dataset as a tidy dataframe by combining the data
#
#    If appropriate writes data to text file
#
# Summarises and writes summary to text file - FUNCTION write_summary (dfInput)
#    Parameter - dfInput
#                Data frame (output from read_files() ) containing the data to be summarised
#                Must contain columns "activity" "subject" "sourcecategory"
#
#    Data is summarised and sorted, then written to a text file
#
#
#
# Each function defined in this file is "safe" to call directly,
#    Provided the base directory is set appropriately (could overwrite the callers ./data directory)
#
# NORMAL USAGE
#    Just initiate using source("run_analysis.R"), functions will be called automagically
#
# -----------------------------------------------------------#
# Specify libraries
library("data.table")
library("dplyr")
#
# Set constants
chrData_subdir           <- "./data"  # Must contain "./" as first 2 characters
chrDownload_address      <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" # Web source data
chrDownload_filename     <- "wearables_data.zip"                                                                     # downloaded filename
#
chrFile_features_data    <- "./UCI HAR Dataset/features.txt"
chrFile_activity_labels  <- "./UCI HAR Dataset/activity_labels.txt"
chrFile_test_subject_id  <- "./UCI HAR Dataset/test/subject_test.txt"
chrFile_test_data        <- "./UCI HAR Dataset/test/X_test.txt"
chrFile_test_activity    <- "./UCI HAR Dataset/test/y_test.txt"
chrFile_train_subject_id <- "./UCI HAR Dataset/train/subject_train.txt"
chrFile_train_data       <- "./UCI HAR Dataset/train/X_train.txt"
chrFile_train_activity   <- "./UCI HAR Dataset/train/y_train.txt"

chrData_output_subdir    <- "./$OUTPUT"
chrFile_output_base      <- "./$OUTPUT/wearable_base.txt"
chrFile_output_summary   <- "./$OUTPUT/wearable_summary.txt"
#
obtain_data <- function() {
    # Remember working directory
    chrWd_initial <- getwd()
    # assume data is in "data" subdirectory
    if (! file.exists(chrData_subdir)) {
        dir.create(chrData_subdir)
    }
    # dir we want must exist now, so go to it
    setwd(substr(chrData_subdir,3,nchar(chrData_subdir)))
    # Do we have the expected file ?
    if (! file.exists(chrDownload_filename)) {
        # download the input data
        download.file(chrDownload_address,destfile=chrDownload_filename,method="curl")
    }
    # Is the file already available and decompressed ? (just check for a key file)
    if (! (file.exists(chrFile_features_data) & file.exists(chrFile_test_data) & file.exists(chrFile_train_data) ) ) {
        # Not already present, so decompress the zip file
        unzip (chrDownload_filename)  # Unzip using default routine and names specified in archive, to archive specified directory
    }
    # Restore working directory
    setwd(chrWd_initial)
}
read_files <- function(booInclude_all_mean_std_cols=FALSE, booWrite_output_file=FALSE){
    # Remember working directory
    chrWd_initial <- getwd()
    # dir we want should exist now, so go to it
    setwd(substr(chrData_subdir,3,nchar(chrData_subdir)))

    # Read the data file Column names
    dfFeature_names <- fread(chrFile_features_data,sep=" ",header=FALSE)
    names(dfFeature_names) <- c("colid","colname")
    # Pick out the fields we want ie. mean and standard deviation- EXCLUDING meanFreq()
    if (booInclude_all_mean_std_cols) {
        # Pick out the fields we want ... ANY with mean or std
        booName_ind  <- t(grepl("*-[mM]ean|*-[sS]td|Mean", dfFeature_names$colname))  # Accept labels with number or character after "mean" / "std"
    } else {
        booName_ind  <- t(grepl("*-[mM]ean[^0-9a-zA-Z]|*-[sS]td[^0-9a-zA-Z]", dfFeature_names$colname))  # Exclude labels with number or character after "mean" / "std"
    }
    chrCol_names <- dfFeature_names$colname[booName_ind]   # Remember the column names (as they will become)

    # Clean the column names - make them more readable
    chrCol_names <- gsub("^t","time_",chrCol_names)               # Translate the first character t
    chrCol_names <- gsub("^f","freq_",chrCol_names)               # Translate the first character f
    chrCol_names <- gsub("Acc","_Accelerometer",chrCol_names)     # Translate
    chrCol_names <- gsub("Gyro","_Gyroscope",chrCol_names)        # Translate
    chrCol_names <- gsub("Jerk","_Jerk",chrCol_names)             # Translate
    chrCol_names <- gsub("Mag","_Magnitude",chrCol_names)         # Translate Mag to Magnitude
    chrCol_names <- gsub("-std","-stdeviation",chrCol_names)      # Translate std to stdeviation
    chrCol_names <- gsub("-X","-Xaxis",chrCol_names)              # Translate axis name
    chrCol_names <- gsub("-Y","-Yaxis",chrCol_names)              # Translate axis name
    chrCol_names <- gsub("-Z","-Zaxis",chrCol_names)              # Translate axis name
    chrCol_names <- gsub("\\(\\)","",chrCol_names)                # Remove brackets from mean and std

    numCol_ids   <- as.numeric(dfFeature_names$colid[booName_ind])

    # Read the activity ids and names
    dfActivity_labels <- fread(chrFile_activity_labels,sep=" ",header=FALSE)
    names(dfActivity_labels) <- c("activityid","activitylabel")

    # Now read the Training data
    dfTrain_subject     <- (fread(chrFile_train_subject_id,sep=" ",header=FALSE,colClasses="character"))
    names(dfTrain_subject) <- c("subject")

    dfTrain_activity_id <- (fread(chrFile_train_activity,sep=" ",header=FALSE))
    names(dfTrain_activity_id) <- c("activity")
    dfTrain_activity <- dfTrain_activity_id
    for (i in 1:length(dfActivity_labels$activityid)){dfTrain_activity$activity[dfTrain_activity$activity==dfActivity_labels$activityid[i]]<-dfActivity_labels$activitylabel[i]}

    dfTrain_data        <- fread(chrFile_train_data,sep=" ",header=FALSE)
    names(dfTrain_data) <- dfFeature_names$colname

    # And the Test data
    dfTest_subject      <- (fread(chrFile_test_subject_id,sep=" ",header=FALSE,colClasses="character"))
    names(dfTest_subject) <- c("subject")

    dfTest_activity_id  <- (fread(chrFile_test_activity,sep=" ",header=FALSE))
    dfTest_activity     <- replace(dfTest_activity_id,dfActivity_labels$activityid,dfActivity_labels$activitylabel) #[,1]
    names(dfTest_activity_id) <- c("activity")
    dfTest_activity <- dfTest_activity_id
    for (i in 1:length(dfActivity_labels$activityid)){dfTest_activity$activity[dfTest_activity$activity==dfActivity_labels$activityid[i]]<-dfActivity_labels$activitylabel[i]}

    dfTest_data         <- fread(chrFile_test_data,sep=" ",header=FALSE)
    names(dfTest_data)  <- dfFeature_names$colname

    dfData <- rbind(cbind("train", as.factor(dfTrain_subject$subject),as.factor(dfTrain_activity$activity),select(dfTrain_data,numCol_ids)),cbind("test",as.factor(dfTest_subject$subject),as.factor(dfTest_activity$activity),select(dfTest_data,numCol_ids)))  # Combine person id and our columns of interest
    names(dfData) <- c("sourcecategory","subject","activity",chrCol_names)
    dfData$sourcecategory <- as.factor(dfData$sourcecategory)

    if (booWrite_output_file){
        # Create directory for output files, if necessary
        if (! file.exists(chrData_output_subdir)) {dir.create(chrData_output_subdir)}
        # Write output file
        write.table(dfData,file=chrFile_output_base,row.names=FALSE)
    }

    # Restore working directory
    setwd(chrWd_initial)

    return(dfData)
}
write_summary <- function(dfInput) {
    # Remember working directory
    chrWd_initial <- getwd()
    # dir we want should exist now, so go to it
    setwd(substr(chrData_subdir,3,nchar(chrData_subdir)))

    dfSummary <- aggregate.data.frame(dfInput, list(dfInput$activity,dfInput$subject), FUN=mean)
    # Remove useless columns (these produced warnings)
    dfSummary$sourcecategory <- NULL
    dfSummary$activity       <- NULL
    dfSummary$subject        <- NULL
    # Rename summary indexes
    names(dfSummary)[1]      <- "activity"
    names(dfSummary)[2]      <- "subject"
    # Create sort column
    dfSummary$subject_num    <- as.numeric(as.character(dfSummary$subject))
    # Sort data into more readbale format ie. subject by number rather than subject by character
    dfSummary_sorted <- dfSummary[with(dfSummary,order(activity,subject_num)),]
    # Remove the sort key
    dfSummary_sorted$subject_num    <- NULL

    # Create directory for output files
    if (! file.exists(chrData_output_subdir)) {dir.create(chrData_output_subdir)}
    # Write output files
    write.table(dfSummary_sorted,file=chrFile_output_summary,row.names=FALSE)

    # Restore working directory
    setwd(chrWd_initial)

    return()
}

# -------------------------------------------- #
# Remember working directory
chrWd_initial <- getwd()

# Download requried files, and decompress them
obtain_data()

# Read the input files and create our working data frame
dfInput <- read_files(booInclude_all_mean_std_cols=FALSE, booWrite_output_file=FALSE) # Include ONLY columns with mean and std followed by a special character (usually a bracket) - DEFAULT
#dfInput <- read_files(booInclude_all_mean_std_cols=TRUE)  # Include ALL columns with mean and std in name

# Write the final summary
write_summary(dfInput)

# Restore original working directory
setwd(chrWd_initial)
