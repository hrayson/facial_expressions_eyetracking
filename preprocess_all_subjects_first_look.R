# Increases memory limit (by default R is restricted to using a certaint amount of RAM)
memory.limit(size=100000)

# Reads file (change path accordingly) containing preprocessed data from all subjects
data <-read.csv(file= "/data/child_anxiety/EyeTracking/data/all_subjects_no_reinspections.csv")

# All subjects
subj_ids<-unique(data$Subject)

# Create a new empty dataframe for first look data
first_look_data <- data.frame()

# Process data from each subject
for(i in 1:length(subj_ids)) {
	# Get subject ID
	subj_id <- subj_ids[i]
	print(subj_id)
	# Get only the rows for this subject from the dataframe containing all subject data
	subj_data <- data[data$Subject==subj_id,]
	
	# Get trial IDs
	#trial_ids <- unique(data[data$Subject==subj_id,]$TrialId)
	trial_ids <- unique(subj_data$TrialId)

	# Process each trial for this subject
	for(j in 1:length(trial_ids)) {
		# Get trial ID
		trial_id <- trial_ids[j]
		print(trial_id)

		# Get only the rows for this trial from the dataframe containing all trials for this subject
		trial_data <- subj_data[subj_data$TrialId==trial_id,]

		# Find the first row where Emotion is true (first look to emotion face)
		first_look_emotion <- which.max(trial_data$Emotion)
		#first_look_emotion <- which.max(data$Subject==subj_id & data$TrialId==trial_id & data$Emotion==TRUE)

		# Find the first row where Neutral is true (first look to neutral face)
		first_look_neutral <- which.max(trial_data$Neutral)
		#first_look_neutral <- which.max(data$Subject==subj_id & data$TrialId==trial_id & data$Neutral==TRUE)

		# If looked at both at least once
		#if(length(first_look_emotion)>0 && data$Emotion[first_look_emotion] && length(first_look_neutral)>0 && data$Neutral[first_look_neutral]) {
		if(length(first_look_emotion)>0 && trial_data$Emotion[first_look_emotion] && length(first_look_neutral)>0 && trial_data$Neutral[first_look_neutral]) {
			# If looked at emotion face first - set neutral to false
			if(first_look_emotion < first_look_neutral) {
				trial_data$Neutral <- FALSE
				#data$Neutral[data$Subject==subj_id & data$TrialId==trial_id]<-FALSE
			}
			# If looked at neutral face first - set emotion to false
			else {
				trial_data$Emotion <- FALSE
				#data$Emotion[data$Subject==subj_id & data$TrialId==trial_id]<-FALSE
			}		
		}

		# Add trial data to dataframe
		first_look_data <- rbind(first_look_data, trial_data)
	}
}

# Have to reset Neutral and Emotion columns to NA where Trackloss is TRUE (because we set all rows following initial inspection to FALSE above)
first_look_data$Neutral[first_look_data$Trackloss == TRUE] <- NA
first_look_data$Emotion[first_look_data$Trackloss == TRUE] <- NA
#data$Neutral[data$Trackloss == TRUE] <- NA
#data$Emotion[data$Trackloss == TRUE] <- NA

# Save pre-processed data frame to csv (change path accordingly) so don't have to run every time
write.csv(first_look_data, file = "/data/child_anxiety/EyeTracking/data/all_subjects_first_look.csv")
