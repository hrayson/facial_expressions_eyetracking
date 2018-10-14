# Goes to directory containing R scripts (change accordingly). Note, Windows uses \ but need to change to / to work in R.
setwd('/data/child_anxiety/EyeTracking/src/R')

# Preprocess all subjects - concatenates all subject data into one file - all_subjects.csv
#source('preprocess_all_subjects.R')

# Remove reinspections from all data - reads all_subjects.csv, creates all_subjects_no_reinspections.csv
source('preprocess_all_subjects_remove_reinspections.R')

# Remove everything but first look from all data - reads all_subjects_no_reinspections.csv, creates all_subjects_first_look.csv
source('preprocess_all_subjects_first_look.R')

# Remove everything but second look from all data - reads all_subjects_no_reinspections.csv, creates all_subjects_second_look.csv
source('preprocess_all_subjects_second_look.R')

# Analyze amount of recorded gaze, per subject and per trial, before and after removing trials with excess trackloss,
# reads all_subjects.csv, creates all_subjects_per_trial_trackloss_prefiltering.csv, all_subjects_trackloss_prefiltering.csv, 
# all_subjects_per_trial_trackloss_postfiltering.csv, and all_subjects_trackloss_postfiltering.csv
source('analyze_recorded_gaze.R')

# Extract dwell times for each AOI, reads all_subjects.csv, creates all_subjects_aois_dwell_per_trial-wide.csv and
# all_subjects_aois_dwell_per_trial-long.csv
source('analyze_recorded_gaze_aois.R')

# Extract the time of first look to each AOI, reads all_subjects.csv, creates all_subjects_first_look_times.csv
source('first_look_time.R')

