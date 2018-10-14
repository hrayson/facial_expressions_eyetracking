library('foreign')
data<-read.spss('/data/child_anxiety/EyeTracking/data/ALL_PAS_Scores_10.07.18.sav',to.data.frame=TRUE)
write.csv(data,file='/data/child_anxiety/EyeTracking/data/ALL_PAS_Scores_10.07.18.2.csv')

