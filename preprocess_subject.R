preprocess_subject <- function(subj_id) {
	# Reads one subjects data into a data frame (change path accordingly).
	data <-read.csv(file= paste("/data/child_anxiety/EyeTracking/data/", subj_id, ".csv", sep=''),header=TRUE,sep=",")

	# Maintain unique subject IDs (i.e. 1D rather than 1 (letters not specified in the csv file, but is in the name of that file).
	data$Subject=subj_id

	# Add another column to the data frame called Message, set Message column equal to TrialStart when the TrialId column changes value. 
	data$Message <- ''
	data$Message[1] <- 'TrialStart'
	data$Message[1+which(!!diff(as.numeric(data$TrialId)))] <- 'TrialStart' 

	# Get rid of first few practice trials.
	# Find 5th instance of trial start (end of practice trials).
	trial_starts <- 0
	for(i in 1:nrow(data)) {
		if(data$Message[i] == 'TrialStart') {
			trial_starts <- trial_starts+1
		}
		if(trial_starts==5) {
			break
		}
	}
	
	# Only use rows after practice columns - cuts off practice rows.
	data <- data[i:nrow(data),]

	# Set StmulusStart in Message column for the first appearance of Target (the faces) in CurrentObject column after trial start.
	# in_trial is a flag that tells us whether or not we are looking for a line with Target (only looking after TrialStart and before first Target appears in that trial).
	in_trial <- FALSE
	for(i in 1:nrow(data)) {
		if(data$Message[i] == 'TrialStart') {
			in_trial <- TRUE
		}

		if(in_trial & data$CurrentObject[i] == 'Target') {
			data$Message[i] <- 'StimulusStart'
			in_trial <- FALSE
		}
	}

	# Creates 'Trackloss' column in data (rows will say TRUE where data lost and FALSE where data recorded).
	data$Trackloss <- data$ValidityLeftEye>1 & data$ValidityRightEye>1

	# Creates a 'Neutral' column in data (rows will say TRUE where AOI looked at was neutral or Neutral)- then will put NA in any rows where there was trackloss. 
	data$Neutral <- data$AOIStimulus == 'neutral' | data$AOIStimulus == 'Neutral'
	data$Neutral[data$Trackloss == TRUE] <- NA

	# Creates an 'Emotion' column in data (rows will say TRUE where AOI looked at was angry, Angry, happy or Happy)- then will put NA in any rows where there was trackloss. 
	data$Emotion <- data$AOIStimulus == 'angry' | data$AOIStimulus == 'Angry' | data$AOIStimulus == 'happy' | data$AOIStimulus == 'Happy'
	data$Emotion[data$Trackloss == TRUE] <- NA
 
	# Creates an empty 'EmotionType' column in data. Then fills in rows of EmotionType column to denote whether the neutral-emotion pair for that trial includes an angry/Angry or happy/Happy image.
	data$EmotionType <- ''
	data$EmotionType[data$Left_Image == 'angry' | data$Left_Image == 'Angry' | data$Right_Image == 'angry' | data$Right_Image == 'Angry'] <- 'angry'
	data$EmotionType[data$Left_Image == 'happy' | data$Left_Image == 'Happy' | data$Right_Image == 'happy' | data$Right_Image == 'Happy'] <- 'happy'

	# To check that the Trackloss, Neutral, or Emotion columns have been added correctly to the data frame, use the below line of code to write data frame to csv file (change participant ID accordingly in the path specified).
	#write.csv(data, file = "C:/Users/Holly/Dropbox/Post PhD Amazingness/Helen job/EyeTracking/data/86R_test.csv")
	
	# Return data frame.
	data

}
