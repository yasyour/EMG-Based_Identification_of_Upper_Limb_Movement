function Visualization_(biceps_mean, triceps_mean, channel_means, ...
                       movement, basename)
    % Generates visualization figures (2 separate figures)
 
    
    fprintf('\nGenerating visualization figures...\n');
    
    % Define muscle groups
    biceps_channels = [3, 4, 5, 6];
    triceps_channels = [1, 2, 7, 8];
    
    %% FIGURE 1: Bar Chart - 8 Channels (SEPARATE FIGURE)
    figure('Position', [200, 200, 1200, 600], ...
           'Name', [basename ' - Bar Chart'], ...
           'NumberTitle', 'off');
    
    % Create bar chart with 8 bars
    bar_handle = bar(channel_means, 'FaceColor', 'flat');
    
    % Color code by muscle group
    for ch = 1:8
        if ismember(ch, biceps_channels)
            % Biceps group - Blue color
            bar_handle.CData(ch, :) = [0, 0.4470, 0.7410]; % Blue
        else
            % Triceps group - Red color
            bar_handle.CData(ch, :) = [0.8500, 0.3250, 0.0980]; % Red
        end
    end
    
    % Customize bar chart
    xlabel('Channel Number', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Mean Amplitude (μV)', 'FontSize', 12, 'FontWeight', 'bold');
    title(['Mean Amplitude of Each EMG Channel - ' basename], ...
          'FontSize', 14, 'FontWeight', 'bold');
    
    % Add channel labels
    set(gca, 'XTick', 1:8, 'XTickLabel', {'1', '2', '3', '4', '5', '6', '7', '8'});
    grid on;
    
    % Add value labels on bars
    for ch = 1:8 
        text(ch, channel_means(ch), ...
            sprintf('%.1f', channel_means(ch)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
            'FontSize', 10, 'FontWeight', 'bold');
    end
    
    % Add legend
    hold on;
    biceps_patch = patch([NaN, NaN], [NaN, NaN], [0, 0.4470, 0.7410], ...
                         'DisplayName', 'Biceps (Ch 3-6)');
    triceps_patch = patch([NaN, NaN], [NaN, NaN], [0.8500, 0.3250, 0.0980], ...
                          'DisplayName', 'Triceps (Ch 1,2,7,8)');
    legend([biceps_patch, triceps_patch], 'Location', 'best', 'FontSize', 10);
    hold off;
    
    saveas(gcf, [basename '_Bar_Chart.png']);
    fprintf('  Saved: %s_Bar_Chart.png\n', basename);
    
    %% FIGURE 2: Decision Plot (SEPARATE FIGURE)
    figure('Position', [250, 250, 1000, 600], ...
           'Name', [basename ' - Decision Plot'], ...
           'NumberTitle', 'off');
    
    % Define thresholds from assignment
    biceps_threshold = 15.0;  % θ₁
    triceps_threshold = 10.0; % θ₂
    
    % Calculate overall mean
    overall_mean = mean(channel_means);
    
    % Create data for decision plot  Biceps, Triceps, and Overall
    muscle_means = [biceps_mean, triceps_mean, overall_mean];
    labels = {'Biceps', 'Triceps', 'Overall'};
    
    % Create bar chart
    bar_handle2 = bar(muscle_means, 'FaceColor', 'flat');
    
    % Set colors
    bar_handle2.CData(1, :) = [0, 0.4470, 0.7410]; % Blue for biceps
    bar_handle2.CData(2, :) = [0.8500, 0.3250, 0.0980]; % Red for triceps
    bar_handle2.CData(3, :) = [0.4660, 0.6740, 0.1880]; % Green for overall
    
    % Add threshold lines (WITHOUT DisplayName to avoid legend)
    hold on;
    
    % Biceps threshold line (θ1)  NO DisplayName
    plot([0.7, 1.3], [biceps_threshold, biceps_threshold], 'b--', ...
         'LineWidth', 2);
    
    % Triceps threshold line (θ2) -NO DisplayName
    plot([1.7, 2.3], [triceps_threshold, triceps_threshold], 'r--', ...
         'LineWidth', 2);
    
    hold off;
    
    % Customize plot
    xlabel('Muscle Group / Metric', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Mean Amplitude (μV)', 'FontSize', 12, 'FontWeight', 'bold');
    title(['Decision Plot - ' basename], 'FontSize', 14, 'FontWeight', 'bold');
    
    set(gca, 'XTickLabel', labels);
    grid on;
    
    % Add threshold labels directly on the plot (instead of legend)
    text(1, biceps_threshold + max(muscle_means)*0.05, ...
        sprintf('θ₁ = %.1f μV', biceps_threshold), ...
        'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', 'b', 'FontWeight', 'bold');
    
    text(2, triceps_threshold + max(muscle_means)*0.05, ...
        sprintf('θ₂ = %.1f μV', triceps_threshold), ...
        'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', 'r', 'FontWeight', 'bold');
    
    % Add value labels on bars
    for i = 1:3
        text(i, muscle_means(i), ...
            sprintf('%.1f μV', muscle_means(i)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
            'FontSize', 11, 'FontWeight', 'bold');
    end
    
    % Add detected movement
    text(0.02, 0.98, sprintf('Detected Movement: %s', movement), ...
         'Units', 'normalized', 'FontSize', 12, 'FontWeight', 'bold', ...
         'VerticalAlignment', 'top', 'BackgroundColor', [0.9, 0.9, 0.9]);
    
   
    
    saveas(gcf, [basename '_Decision_Plot.png']);
    fprintf('  Saved: %s_Decision_Plot.png\n', basename);
    
    fprintf('  Generated 2 visualization figures\n');
end