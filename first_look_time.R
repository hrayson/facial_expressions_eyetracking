# Loads eyetrackingR library so can use software
library("eyetrackingR")

# Reads file containing preprocessed data from all subjects
data <-read.csv(file= "/data/child_anxiety/EyeTracking/data/all_subjects.csv")
	
# Converts data into eyetrackingR format.
eyetrackingr_data <- make_eyetrackingr_data(data, participant_column = "Subject", trial_column = "TrialId", time_column = "TETTime", trackloss_column = "Trackloss", aoi_columns = c('Emotion','Neutral'), treat_non_aoi_looks_as_missing = FALSE, item_columns = c('EmotionType'))

# Re-zero times when StimulusStart message appears - beginning of face stimulus
eyetrackingr_data <- subset_by_window(eyetrackingr_data, window_start_msg = "StimulusStart", msg_col = "Message", rezero = TRUE)

# Only use up to 1500ms after start of face stimulus
response_window <- subset_by_window(eyetrackingr_data, window_start_time = 0, window_end_time=1500, remove = TRUE)

# Analyse amount of trackloss by subjects and trials
(trackloss <- trackloss_analysis(data=response_window))

# Remove trials with over 40% trackloss
response_window_clean <- clean_by_trackloss(data = response_window, trial_prop_thresh = .4)

# All subjects
subj_ids<-unique(data$Subject)

# Create a new empty dataframe for first look data
first_look_time_data <- data.frame()

# Process data from each subject
for(i in 1:length(subj_ids)) {
	# Get subject ID
	subj_id <- subj_ids[i]

	# Get only the rows for this subject from the dataframe containing all subject data
	subj_data <- response_window_clean[response_window_clean$Subject==subj_id,]
	
	# Get trial IDs
	trial_ids <- unique(subj_data$TrialId)

	# Process each trial for this subject
	for(j in 1:length(trial_ids)) {
		# Get trial ID
		trial_id <- trial_ids[j]
			
		# Get only the rows for this trial from the dataframe containing all trials for this subject
		trial_data <- subj_data[subj_data$TrialId==trial_id,]

		# Find the first row where Emotion is true (first look to emotion face)
		first_look_emotion_time <- NA
		first_look_emotion <- which.max(trial_data$Emotion)
		if(length(first_look_emotion)>0 && trial_data$Emotion[first_look_emotion]) {
			first_look_emotion_time <- trial_data$TETTime[first_look_emotion]
		}
			
		# Find the first row where Neutral is true (first look to neutral face)
		first_look_neutral_time <- NA
		first_look_neutral <- which.max(trial_data$Neutral)
		if(length(first_look_neutral)>0 && trial_data$Neutral[first_look_neutral]) {
			first_look_neutral_time <- trial_data$TETTime[first_look_neutral]
		}

		first_look_time_trial_data <- data.frame(Subject=subj_id, Trial=trial_id, FirstLookEmotion=first_look_emotion_time, FirstLookNeutral=first_look_neutral_time, EmotionType=trial_data$EmotionType[1])

		# Add trial data to dataframe
		first_look_time_data <- rbind(first_look_time_data, first_look_time_trial_data)
	}
}

# Save
write.csv(first_look_time_data, file = '/data/child_anxiety/EyeTracking/output/all_subjects_first_look_times.csv')

