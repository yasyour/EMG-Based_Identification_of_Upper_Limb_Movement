function [rectified_data] = Rectification_(processed_data, fs, basename)
    % Applies full-wave rectification to EMG data and plots the results
    
   
    
    fprintf('\nRectifying EMG signal...\n');
    
    % Full-wave rectification (absolute value)
    rectified_data = abs(processed_data);
    fprintf('  Full-wave rectification applied\n');
    
    % Create time vector
    time = (0:size(processed_data,1)-1)' / fs;
    
    %% FIGURE: Rectified EMG - 8 Subplots (One per Channel)
    figure('Position', [150, 150, 1400, 900], ...
           'Name', [basename ' - Rectified EMG (All Channels)'], ...
           'NumberTitle', 'off');
    
    % Define colors for each channel
    channel_colors = lines(8);
    
    for ch = 1:8
        subplot(4, 2, ch); % 4 rows, 2 columns
        plot(time, rectified_data(:, ch), '-', 'LineWidth', 1.5, ...
             'Color', channel_colors(ch,:));
        
        title(sprintf('Channel %d', ch), 'FontSize', 11, 'FontWeight', 'bold');
        xlabel('Time (s)', 'FontSize', 9);
        ylabel('Amplitude (μV)', 'FontSize', 9);
        grid on;
        
        % Add channel statistics
        ch_mean = mean(rectified_data(:, ch));
        text(0.02, 0.95, sprintf('Mean: %.1f μV', ch_mean), ...
             'Units', 'normalized', 'FontSize', 8, 'BackgroundColor', [1, 1, 1, 0.7], ...
             'VerticalAlignment', 'top');
    end
    
    % Overall title for the figure
    sgtitle(['Rectified EMG Signals - All 8 Channels - ' basename], 'FontSize', 14, 'FontWeight', 'bold');
    
    % Add rectification info at the bottom
    annotation('textbox', [0.02, 0.01, 0.96, 0.04], ...
               'String', 'Full-wave rectification: Signal = |Processed EMG|', ...
               'HorizontalAlignment', 'center', 'FontSize', 9, ...
               'EdgeColor', 'none', 'BackgroundColor', [0.95, 0.95, 0.95]);
    
    saveas(gcf, [basename '_3_Rectified_EMG_AllChannels.png']);
    fprintf('  Saved: %s_3_Rectified_EMG_AllChannels.png\n', basename);
end