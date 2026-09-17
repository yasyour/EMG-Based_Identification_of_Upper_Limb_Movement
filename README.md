# EMG-Based_Identification_of_Upper_Limb_Movement

A MATLAB program that processes 8 channel EMG signals and classifies upper arm movement as flexion or extension.

## Overview
Detecting arm movement using EMG in real life can be tricky, since raw muscle signals are often contaminated with noise, interference from other muscles and baseline shifts. This program processes EMG signals recorded with a MindRove EMG armband and classifies whether a recorded movement is flexion or extension, while also displaying the processed signals and reporting metrics on classification performance.

## How it works
1. Data loading: It reads an 8 channel CSV file and returns the EMG matrix, time vector, and sampling frequency (500 Hz)
2. Preprocessing: demeans each channel, applies a 10 to 225 Hz 4th order Butterworth band-pass filter, then a 10 sample moving average filter
3. Rectification: full wave rectification to capture the EMG energy envelope
4. Feature extraction: mean amplitude for the Biceps group (channels 3,4,5,6) and Triceps group (channels 1,2,7,8)
5. Classification: It is rule based, using reciprocal inhibition: flexion if biceps mean > 15.0 μV and triceps mean < 10.0 μV (and vice versa for extension); ambiguous cases go to the higher muscle mean
6. Visualization: a bar chart of all 8 channel means and a decision plot comparing biceps/triceps/overall means against their thresholds
7. Evaluation: It batch processes all trial files and reports a confusion matrix with Accuracy, Precision, and Recall

## Results
The program correctly classified all 10 provided test trials (5 flexing, 5 extending).

## How to run
Place the CSV trial files in a `Data/` folder, then run `Mainfunction.m` in MATLAB.

## Documentation
Full write-up with test cases and algorithm design:
[EMG-Based_Identification_of_Upper_Limb_Movement_Report.pdf](https://github.com/user-attachments/files/32325966/EMG-Based_Identification_of_Upper_Limb_Movement_Report.pdf)
