# Eye tracking of facial expressions in early childhood

R scripts for preprocessing eye-tracking data and analysing gaze to emotional and neutral faces in the Reading longitudinal childhood anxiety study.

## Related paper and archive

Dodd, H. F., Rayson, H., Ryan, Z. J., Bishop, C., Parsons, S., & Stuijfzand, B. G. (2020). [Trajectories of anxiety when children start school: The role of behavioral inhibition and attention bias to angry and happy faces](https://doi.org/10.1037/abn0000623). *Journal of Abnormal Psychology*.

The [UK Data Service archive](https://reshare.ukdataservice.ac.uk/854493/) contains the study documentation and published R analysis code. This repository covers eye-tracking processing and gaze analyses.

## Code

- [`run_all_preprocessing.R`](run_all_preprocessing.R) and [`preprocess_subject.R`](preprocess_subject.R) organise data preparation.
- [`analyze_recorded_gaze.R`](analyze_recorded_gaze.R) and [`analyze_recorded_gaze_aois.R`](analyze_recorded_gaze_aois.R) analyse gaze trajectories and areas of interest.
- [`first_look_time.R`](first_look_time.R) analyses first-look timing.

Set the expected data paths locally. See [LICENSE](LICENSE) for the code licence.
