# Increases memory limit (by default R is restricted to using a certaint amount of RAM)
memory.limit(size=100000)

# Reads file containing preprocessed data from all subjects (change path accordigly).
data <-read.csv(file= "/data/child_anxiety/EyeTracking/data/all_subjects.csv")

# Creates variable listing all subject IDs to process
subj_ids<- unique(data$Subject)

# Creates a new empty dataframe for new data. 
new_data <- data.frame()

# Process data from each subject.
for(i in 1:length(subj_ids)) {
	# Get subject ID
	subj_id <- subj_ids[i]
	print(subj_id)
	# Get only the rows for this subject from the dataframe containing all subject data.
	subj_data <- data[data$Subject==subj_id,]
	
	# Get trial IDs for that subject.
	trial_ids <- unique(subj_data$TrialId)

	# Process each trial for this subject
	for(j in 1:length(trial_ids)) {
		# Get trial ID
		trial_id <- trial_ids[j]
		print(trial_id)

		# Get only the rows for this trial from the dataframe containing all trials for this subject
		trial_data <- subj_data[subj_data$TrialId==trial_id,]
                #trial_end_idx=which.min(data$Subject==subj_id & data$TrialId==trial_id)-1
		# Find the first row where Emotion is true (first look to emotion face)
		#first_look_emotion <- which.max(data$Subject==subj_id & data$TrialId==trial_id & data$Emotion==TRUE)
		first_look_emotion <- which.max(trial_data$Emotion==TRUE)
		# If Emotion is never true, first_look_emotion will be 1, so need to tell whether or not the first row is TRUE, or its just never TRUE
		if(length(first_look_emotion)>0 && trial_data$Emotion[first_look_emotion]) {
	   		# Find the first row after the initial look to emotional face where Emotion is false (end of initial inspection of emotional face)
			#end_look_emotion <- first_look_emotion+which.min(data$Subject[first_look_emotion:trial_end_idx]==subj_id & data$TrialId[first_look_emotion:trial_end_idx]==trial_id & data$Emotion[first_look_emotion:trial_end_idx]==TRUE)-1
			end_look_emotion <- first_look_emotion+which.min(trial_data$Emotion[first_look_emotion:nrow(trial_data)])-1
			# Only have to set remaining rows to FALSE, when the inspection of emotional face doesn't go until the end of the trial
			if(end_look_emotion > first_look_emotion) {
				# Set Emotion columns equal to false for all rows after initial inspection of emotional face
				trial_data$Emotion[end_look_emotion:nrow(trial_data)] <- FALSE
				#data$Emotion[end_look_emotion:trial_end_idx]<-FALSE
			}
		}
		
		# Find the first row where Neutral is true (first look to neutral face)
		first_look_neutral <- which.max(trial_data$Neutral)
		#first_look_neutral <- which.max(data$Subject==subj_id & data$TrialId==trial_id & data$Neutral==TRUE)
		# If Neutral is never true, first_look_neutral will be 1, so need to tell whether or not the first row is TRUE, or its just never TRUE
		if(length(first_look_neutral)>0 && trial_data$Neutral[first_look_neutral]) {
			# Find the first row after the initial look to neutral face where Neutral is false (end of initial inspection of neutral face)
			#end_look_neutral <- first_look_neutral+which.min(data$Subject[first_look_neutral:trial_end_idx]==subj_id & data$TrialId[first_look_neutral:trial_end_idx]==trial_id & data$Neutral[first_look_neutral:trial_end_idx]==TRUE)-1
			end_look_neutral <- first_look_neutral+which.min(trial_data$Neutral[first_look_neutral:nrow(trial_data)])-1
			# Only have to set remaining rows to FALSE, when the inspection of neutral face doesn't go until the end of the trial
			if(end_look_neutral > first_look_neutral) {
				# Set Neutral columns equal to false for all rows after initial inspection of neutral face
				trial_data$Neutral[end_look_neutral:nrow(trial_data)] <- FALSE
				#data$Neutral[end_look_neutral:trial_end_idx]<-FALSE
			}
		}

		# Add trial data to dataframe
		new_data <- rbind(new_data, trial_data)
	}
}

# Have to reset Neutral and Emotion columns to NA where Trackloss is TRUE (because we set all rows following initial inspection to FALSE above)
new_data$Neutral[new_data$Trackloss == TRUE] <- NA
new_data$Emotion[new_data$Trackloss == TRUE] <- NA
#data$Neutral[data$Trackloss == TRUE] <- NA
#data$Emotion[data$Trackloss == TRUE] <- NA

# Save pre-processed data frame to csv (change path accordingly) so don't have to run every time
write.csv(new_data, file = "/data/child_anxiety/EyeTracking/data/all_subjects_no_reinspections.csv")
