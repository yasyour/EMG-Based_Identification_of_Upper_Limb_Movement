function [biceps_mean, triceps_mean, channel_means] = Feature_Extractions_(rectified_data)
    % Extracts statistical features from rectified EMG data
   
    
    fprintf('\nExtracting features...\n');
    
    % Define muscle groups
    biceps_channels = [3, 4, 5, 6];  % Columns 3,4,5,6
    triceps_channels = [1, 2, 7, 8]; % Columns 1,2,7,8
    
    % Calculate mean for biceps group
    biceps_data = rectified_data(:, biceps_channels);
    biceps_mean = mean(biceps_data(:));
    
    % Calculate mean for triceps group
    triceps_data = rectified_data(:, triceps_channels);
    triceps_mean = mean(triceps_data(:));
    
    % Calculate individual channel means
    channel_means = mean(rectified_data, 1);
    
    fprintf('  Biceps Group (Channels 3,4,5,6): %.2f μV\n', biceps_mean);
    fprintf('  Triceps Group (Channels 1,2,7,8): %.2f μV\n', triceps_mean);
    
    % Display individual channel means
    fprintf('  Individual Channel Means:\n');
    for ch = 1:8
        if ismember(ch, biceps_channels)
            group = 'Biceps';
        else
            group = 'Triceps';
        end
        fprintf('    Channel %d (%s): %.2f μV\n', ch, group, channel_means(ch));
    end
    
    % Additional features (optional, for analysis)
    rms_values = sqrt(mean(rectified_data.^2, 1));
    
    fprintf('  Additional Features:\n');
    fprintf('    Channel RMS: [%s] μV\n', sprintf('%.1f ', rms_values));
end