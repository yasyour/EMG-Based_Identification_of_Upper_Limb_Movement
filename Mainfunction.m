clc;
clear;
close all;

format long;

%% Main processing function

% Data folder path
data_folder = 'Data/';  
    
fprintf('Looking for data in: %s\n', data_folder);

% Check if Data folder exists
if ~exist(data_folder, 'dir')
    error('Data folder "%s" not found!', data_folder);
end

% Find all CSV files
csv_files = dir(fullfile(data_folder, '*.csv'));

if isempty(csv_files)
    error('No CSV files found in %s', data_folder);
end

% Create full paths
all_files = cell(1, length(csv_files));
for i = 1:length(csv_files)
    all_files{i} = fullfile(data_folder, csv_files(i).name);
end

% Sort files
all_files = sort(all_files);

fprintf('Found %d CSV files:\n', length(all_files));
for i = 1:length(all_files)
    [~, name, ~] = fileparts(all_files{i});
    fprintf('  %d. %s\n', i, name);
end

fprintf('\n=============================================\n');
fprintf('Processing %d files\n', length(all_files));
fprintf('=============================================\n\n');

% Track results
correct_count = 0;

% Process each file
for file_idx = 1:length(all_files)
    filename = all_files{file_idx};
    [~, basename, ~] = fileparts(filename);
    
    fprintf('\nProcessing: %s (%d/%d)\n', basename, file_idx, length(all_files));
    
    try
        % Load data
        [emg_data, time, fs] = Data_Loading_(filename);
        
        % Preprocess
        processed_data = Preprocessing_(emg_data, fs, basename);
        
        % Rectify
        rectified_data = Rectification_(processed_data, fs, basename);
        
        % Extract features
        [biceps_mean, triceps_mean, channel_means] = Feature_Extractions_(rectified_data);
        
        % Classify
        movement = Classification_(biceps_mean, triceps_mean);
        
        % Determine expected movement
        if contains(basename, 'flexing', 'IgnoreCase', true)
            expected = 'Flex';
        elseif contains(basename, 'extending', 'IgnoreCase', true)
            expected = 'Extend';
        else
            expected = 'Unknown';
        end
        
        % Display results
        fprintf('  Biceps: %.2f μV | Triceps: %.2f μV\n', biceps_mean, triceps_mean);
        fprintf('  Detected: %s | Expected: %s\n', movement, expected);
        
        % Check correctness
        if strcmp(movement, expected)
            fprintf('  Correct\n');
            correct_count = correct_count + 1;
        else
            fprintf('  Incorrect\n');
        end
        
        % Generate visualization figures
        Visualization_(biceps_mean, triceps_mean, channel_means, movement, basename);
        
    catch ME
        fprintf('  Error: %s\n', ME.message);
    end
end

%% Summary
fprintf('\n=============================================\n');
fprintf('SUMMARY\n');
fprintf('=============================================\n');
fprintf('Files processed: %d\n', length(all_files));
fprintf('Correct: %d | Incorrect: %d\n', correct_count, length(all_files) - correct_count);

if length(all_files) > 0
    accuracy = (correct_count / length(all_files)) * 100;
    fprintf('Accuracy: %.1f%%\n', accuracy);
end


fprintf('Figures: %d files × 5 figures = %d figures\n', ...
    length(all_files), length(all_files) * 5);
fprintf('=============================================\n');