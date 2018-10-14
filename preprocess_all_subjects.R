# Increases memory limit (by default R is restricted to using a certaint amount of RAM in Windows)
memory.limit(size=10000)

# Goes to directory containing R scripts (change accordingly). Note, Windows uses \ but need to change to / to work in R.
setwd('/data/child_anxiety/EyeTracking/src/R')

# Load preprocess_subject function
source('preprocess_subject.R')

# All subjects to pre-process (just add new ones to list)
# 202 -has two recordings - using 2nd one because 1st only has 3 trials
subj_ids<- c('1D', '2D', '4D', '8D', '9D', '10D', '13D', '18D', '19D', '21D', '23R', '26R', '29R', '31R', '32R', '40R', '41R', '46R', '49R', '53R', '57D', '59D', '62D', '63D', '64D', '64R', '65R', '66R', '67R', '69R', '70R', '71R', '74D', '75D', '76D', '77D', '78D', '79D', '80D', '83D', '84D', '85R', '86R', '87R', '88D', '89D', '90D', '97R', '98R', '99R', '100R', '101R', '102R', '103R', '108D', '109D', '111R', '112R', '114R', '115R', '118R', '119R', '120R', '128R', '132R', '150R', '151R', '155R', '156R', '168R', '170R', '171R', '173R', '174R', '175R', '179R', '180R', '184R', '186R', '187R', '190R', '191R', '192R', '193R', '194D', '195R', '196R', '198R', '199R', '202R', '203R', '204R', '205R', '206R', '209R', '210R', '212Z', '213Z', '215Z', '217Z', '218Z', '222Z', '223Z', '224Z', '225Z', '226Z', '227Z', '228Z', '233Z', '236Z', '239Z', '243Z', '244Z', '245Z', '246Z', '247Z', '252Z', '258Z', '259Z', '260Z', '262Z', '263Z', '264Z', '265Z', '268Z', '270Z', '272Z', '273Z', '275Z', '276Z', '277Z', '278Z', '279Z', '280Z', '282D', '283Z', '288Z', '291Z', '292Z', '293D', '294Z', '295Z', '297Z', '298Z', '299Z', '300Z', '303Z', '304Z', '305Z', '309Z', '310Z', '311Z', '312Z', '314Z', '317Z', '318Z', '319Z', '320Z', '321Z', '322Z', '323Z', '325Z', '326D', '327Z', '328Z', '329Z', '330Z', '332Z', '333Z', '334Z', '335Z', '336Z', '337Z', '338Z', '339Z', '342D', '344Z')

# Construct empty data frame (will hold the preprocessed data from all subjects)
data<- data.frame()

# Pre-process data from each subject, then adds data to the empty 'data' data frame
for(i in 1:length(subj_ids)) {
	subj_id <- subj_ids[i]
	print(subj_id)
	# Passes subject ID and anxiety level to the preprocess_subject function
	subj_data<- preprocess_subject(subj_id)
	# Data from running preprocess_subject function added to data frame
	data<- rbind(data, subj_data)
}

# Saves pre-processed data frame to csv so don't have to run every time (change path accordingly)
write.csv(data, file = "/data/child_anxiety/EyeTracking/data/all_subjects.csv")
