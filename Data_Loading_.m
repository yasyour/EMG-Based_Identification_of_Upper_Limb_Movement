function [emg_data, time, fs] = Data_Loading_(filename)
    % Loads EMG data from CSV file and validates format
    
 
    
    % Read CSV file
    data = readmatrix(filename);
    
    % Validate data has exactly 8 channels
    if size(data, 2) ~= 8
        error('CSV file must contain exactly 8 channels of data');
    end
    
    % Set sampling frequency
    fs = 500; % Hz
    
    % Create time vector
    num_samples = size(data, 1);
    time = (0:num_samples-1)' / fs;
    
    % Assign EMG data
    emg_data = data;
   
    fprintf('Data loaded successfully:\n');
    fprintf('  Samples: %d\n', num_samples);
    fprintf('  Duration: %.2f seconds\n', time(end));
    fprintf('  Sampling Frequency: %d Hz\n', fs);
end