function [processed_data] = Preprocessing_(emg_data, fs, basename)
    % Preprocesses EMG data through multiple steps and plots raw vs preprocessed data
   
    
    fprintf('\nPreprocessing EMG data...\n');
    
    %% STEP 1: Demean (remove DC offset)
    fprintf('  Step 1: Removing DC offset (demeaning)...\n');
    demeaned_data = emg_data - mean(emg_data, 1);
    
    %% STEP 2: Band-pass filter (10-225 Hz, 4th order Butterworth)
    fprintf('  Step 2: Applying band-pass filter (10-225 Hz)...\n');
    
    % Design 4th-order Butterworth band-pass filter
    nyquist = fs / 2;
    low_cutoff = 10 / nyquist;
    high_cutoff = 225 / nyquist;
    
    if low_cutoff <= 0 || high_cutoff >= 1
        error('Filter cutoff frequencies are not valid for this sampling rate');
    end
    
    [b, a] = butter(4, [low_cutoff, high_cutoff], 'bandpass');
    
    % Apply zero-phase filtering using filtfilt
    filtered_data = zeros(size(demeaned_data));
    for ch = 1:8
        filtered_data(:, ch) = filtfilt(b, a, demeaned_data(:, ch));
    end
    
    %% STEP 3: Moving average filter (10-sample window = 20 ms at 500 Hz)
    fprintf('  Step 3: Applying moving average filter (10-sample window)...\n');
    
    window_size = 10; % Equivalent to 20 ms at 500 Hz sampling rate
    ma_filter = ones(window_size, 1) / window_size;
    
    smoothed_data = zeros(size(filtered_data));
    for ch = 1:8
        smoothed_data(:, ch) = conv(filtered_data(:, ch), ma_filter, 'same');
    end
    
    % Output processed data
    processed_data = smoothed_data;
    
    fprintf('  Preprocessing complete!\n');
    
    %% PLOTTING: Create 2 figures with 8 subplots each
    fprintf('  Generating preprocessing plots...\n');
    
    % Create time vector
    time = (0:size(emg_data,1)-1)' / fs;
    
    %% FIGURE 1: Raw EMG Signals , 8 Subplots (One per Channel)
    fig1 = figure('Position', [50, 50, 1400, 900], ...
                  'Name', [basename ' - Raw EMG (All Channels)'], ...
                  'NumberTitle', 'off');
    
    % Define colors for each channel
    channel_colors = lines(8);
    
    for ch = 1:8
        subplot(4, 2, ch); % 4 rows, 2 columns
        plot(time, emg_data(:, ch), '-', 'LineWidth', 1.5, ...
             'Color', channel_colors(ch,:));
        
        title(sprintf('Channel %d', ch), 'FontSize', 11, 'FontWeight', 'bold');
        xlabel('Time (s)', 'FontSize', 9);
        ylabel('Amplitude (μV)', 'FontSize', 9);
        grid on;
        
        % Add channel statistics
        ch_mean = mean(emg_data(:, ch));
        ch_std = std(emg_data(:, ch));
        text(0.02, 0.95, sprintf('Mean: %.1f μV\nStd: %.1f μV', ch_mean, ch_std), ...
             'Units', 'normalized', 'FontSize', 8, 'BackgroundColor', [1, 1, 1, 0.7], ...
             'VerticalAlignment', 'top');
    end
    
    % Overall title for the figure
    sgtitle(['Raw EMG Signals - All 8 Channels - ' basename], 'FontSize', 14, 'FontWeight', 'bold');
    
    saveas(fig1, [basename '_1_Raw_EMG_AllChannels.png']);
    
    %% FIGURE 2: Preprocessed EMG Signals - 8 Subplots (One per Channel)
    fig2 = figure('Position', [100, 100, 1400, 900], ...
                  'Name', [basename ' - Preprocessed EMG (All Channels)'], ...
                  'NumberTitle', 'off');
    
    for ch = 1:8
        subplot(4, 2, ch); % 4 rows, 2 columns
        plot(time, processed_data(:, ch), '-', 'LineWidth', 1.5, ...
             'Color', channel_colors(ch,:));
        
        title(sprintf('Channel %d', ch), 'FontSize', 11, 'FontWeight', 'bold');
        xlabel('Time (s)', 'FontSize', 9);
        ylabel('Amplitude (μV)', 'FontSize', 9);
        grid on;
        
        % Add channel statistics
        ch_mean = mean(processed_data(:, ch));
        ch_std = std(processed_data(:, ch));
        text(0.02, 0.95, sprintf('Mean: %.1f μV\nStd: %.1f μV', ch_mean, ch_std), ...
             'Units', 'normalized', 'FontSize', 8, 'BackgroundColor', [1, 1, 1, 0.7], ...
             'VerticalAlignment', 'top');
    end
    
    % Overall title for the figure
    sgtitle(['Preprocessed EMG Signals - All 8 Channels - ' basename], 'FontSize', 14, 'FontWeight', 'bold');
    
    % Add preprocessing steps info at the bottom
    annotation('textbox', [0.02, 0.01, 0.96, 0.04], ...
               'String', 'Preprocessing Steps: 1. Demean → 2. Band-pass filter (10-225 Hz) → 3. Moving average (10 samples)', ...
               'HorizontalAlignment', 'center', 'FontSize', 9, ...
               'EdgeColor', 'none', 'BackgroundColor', [0.95, 0.95, 0.95]);
    
    saveas(fig2, [basename '_2_Preprocessed_EMG_AllChannels.png']);
    
    fprintf('  Saved 2 preprocessing figures (all channels):\n');
    fprintf('    - %s_1_Raw_EMG_AllChannels.png\n', basename);
    fprintf('    - %s_2_Preprocessed_EMG_AllChannels.png\n', basename);
end