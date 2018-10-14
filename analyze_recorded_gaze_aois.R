# Must have run preprocess_all_subjects.R before running this!

# Loads eyetrackingR library so can use software
library("Matrix")
library("lme4")
library("ggplot2")
library("eyetrackingR")

# Reads file containing preprocessed data from all subjects.
data <-read.csv(file= "/data/child_anxiety/EyeTracking/data/all_subjects.csv")

# Creates a 'Centre' column in data (rows will say TRUE where centre looked at)- then will put NA in any rows where there was trackloss. 
data$Centre <- data$AOIStimulus == 'centre' | data$AOIStimulus == 'Centre'
data$Centre[data$Trackloss == TRUE] <- NA

# Creates an 'Other' column in data (rows will say TRUE where NOT looking at AOI 1, 2 or centre (i.e. blank row))- then will put NA in any rows where there was trackloss. 
data$Other <- data$AOIStimulus == '' | data$AOIStimulus == ' '
data$Other[data$Trackloss == TRUE] <- NA

# Converts data into eyetrackingR format.
eyetrackingr_data <- make_eyetrackingr_data(data, participant_column = "Subject", trial_column = "TrialId", time_column = "TETTime", trackloss_column = "Trackloss", aoi_columns = c('Neutral', 'Emotion', 'Centre', 'Other'), treat_non_aoi_looks_as_missing = FALSE, item_columns = c('EmotionType'))

# Re-zero times when StimulusStart message appears - beginning of face stimulus
eyetrackingr_data <- subset_by_window(eyetrackingr_data, window_start_msg = "StimulusStart", msg_col = "Message", rezero = TRUE)

# Only use up to 1500ms after start of face stimulus
response_window <- subset_by_window(eyetrackingr_data, window_start_time = 0, window_end_time=1500, remove = TRUE)

# Analyse amount of trackloss by subjects and trials
(trackloss <- trackloss_analysis(data=response_window))

# Remove trials with over 40% trackloss
response_window_clean <- clean_by_trackloss(data = response_window, trial_prop_thresh = .4)

neutral_dwell_time <- make_time_window_data(response_window_clean, aois = c('Neutral'), predictor_columns = c('EmotionType'))
emotion_dwell_time <- make_time_window_data(response_window_clean, aois = c('Emotion'), predictor_columns = c('EmotionType'))
centre_dwell_time <- make_time_window_data(response_window_clean, aois = c('Centre'), predictor_columns = c('EmotionType'))
other_dwell_time <- make_time_window_data(response_window_clean, aois = c('Other'), predictor_columns = c('EmotionType'))

aoi_dwell_time <- data.frame(Subject=neutral_dwell_time$Subject, TrialId=neutral_dwell_time$TrialId, EmotionType=neutral_dwell_time$EmotionType, SamplesTotal=neutral_dwell_time$SamplesTotal)

aoi_dwell_time$SamplesInNeutral <- neutral_dwell_time$SamplesInAOI
aoi_dwell_time$ProportionInNeutral <- aoi_dwell_time$SamplesInNeutral/aoi_dwell_time$SamplesTotal

aoi_dwell_time$SamplesInEmotion <- emotion_dwell_time$SamplesInAOI
aoi_dwell_time$ProportionInEmotion <- aoi_dwell_time$SamplesInEmotion/aoi_dwell_time$SamplesTotal

aoi_dwell_time$SamplesInCentre <- centre_dwell_time$SamplesInAOI
aoi_dwell_time$ProportionInCentre <- aoi_dwell_time$SamplesInCentre/aoi_dwell_time$SamplesTotal

aoi_dwell_time$SamplesInOther <- other_dwell_time$SamplesInAOI
aoi_dwell_time$ProportionInOther <- aoi_dwell_time$SamplesInOther/aoi_dwell_time$SamplesTotal

write.csv(aoi_dwell_time, file = "/data/child_anxiety/EyeTracking/output/all_subjects_aois_dwell_per_trial-wide.csv")


all_aoi_dwell_time <- make_time_window_data(response_window_clean, aois = c('Neutral', 'Emotion', 'Centre', 'Other'), predictor_columns = c('EmotionType'))

aoi_dwell_time <- data.frame(Subject=all_aoi_dwell_time$Subject, TrialId=all_aoi_dwell_time$TrialId, EmotionType=all_aoi_dwell_time$EmotionType, SamplesTotal=all_aoi_dwell_time$SamplesTotal, AOI=all_aoi_dwell_time$AOI, SamplesInAOI=all_aoi_dwell_time$SamplesInAOI)

aoi_dwell_time$ProportionInAOI<- aoi_dwell_time$SamplesInAOI/aoi_dwell_time$SamplesTotal

write.csv(aoi_dwell_time, file = "/data/child_anxiety/EyeTracking/output/all_subjects_aois_dwell_per_trial-long.csv")


