library("eyetrackingR")

# Reads file containing preprocessed data from all subjects.
data <-read.csv(file= "/data/child_anxiety/EyeTracking/data/all_subjects.csv")

# Converts data into eyetrackingR format.
eyetrackingr_data <- make_eyetrackingr_data(data, participant_column = "Subject", trial_column = "TrialId", time_column = "TETTime", trackloss_column = "Trackloss", aoi_columns = c('Neutral', 'Emotion'), treat_non_aoi_looks_as_missing = FALSE, item_columns = c('EmotionType'))

# Re-zero times when StimulusStart message appears - beginning of face stimulus
eyetrackingr_data <- subset_by_window(eyetrackingr_data, window_start_msg = "StimulusStart", msg_col = "Message", rezero = TRUE)

# Only use up to 1500ms after start of face stimulus
response_window <- subset_by_window(eyetrackingr_data, window_start_time = 0, window_end_time=1500, remove = TRUE)

# Compute trackloss for each trial
(trackloss <- trackloss_analysis(data=response_window))
# Write pre-filtering trackloss to file
write.csv(trackloss, file="/data/child_anxiety/EyeTracking/output/all_subjects_per_trial_trackloss_prefiltering.csv")

# Assess mean trackloss for each participant
(trackloss_subjects <- unique(trackloss[, c('Subject','TracklossForParticipant')]))
# Write pre-filtering trackloss to file
write.csv(trackloss_subjects, file="/data/child_anxiety/EyeTracking/output/all_subjects_trackloss_prefiltering.csv")


# Remove trials with over 40% trackloss
response_window_clean <- clean_by_trackloss(data = response_window, trial_prop_thresh = .4)

# Compute trackloss for each trial after getting rid of trials
(trackloss <- trackloss_analysis(data=response_window_clean))
# Write post-filtering trackloss to file
write.csv(trackloss, file="/data/child_anxiety/EyeTracking/output/all_subjects_per_trial_trackloss_postfiltering.csv")

# Assess mean trackloss for each participant
(trackloss_subjects <- unique(trackloss[, c('Subject','TracklossForParticipant')]))
# Write pre-filtering trackloss to file
write.csv(trackloss_subjects, file="/data/child_anxiety/EyeTracking/output/all_subjects_trackloss_postfiltering.csv")

# Mean samples contributed per trial, with SD
mean_samples_per_trial<-mean(1-trackloss_subjects$TracklossForParticipant)
sd_samples_per_trial<-sd(1-trackloss_subjects$TracklossForParticipant)
print(sprintf('Samples per trial (%%), M=%.3f, SD=%.3f', mean_samples_per_trial, sd_samples_per_trial))

# Get number of trials per participant
(final_summary <- describe_data(response_window_clean, 'Emotion', 'Subject'))
print(final_summary)

# Summarize number of trials contributed
mean_trials_per_subject<-mean(final_summary$NumTrials)
sd_trials_per_subject<-sd(final_summary$NumTrials)
print(sprintf('Trials per subject, M=%.3f, SD=%.3f', mean_trials_per_subject, sd_trials_per_subject))

