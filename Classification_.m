function [movement] = Classification_(biceps_mean, triceps_mean)
 
    
    fprintf('\nClassifying movement...\n');
    
    % Define thresholds
    biceps_threshold = 15.0;
    triceps_threshold = 10.0;
    
    fprintf('  Thresholds: Biceps > %.1f μV, Triceps > %.1f μV\n', ...
        biceps_threshold, triceps_threshold);
    
    % Apply decision rules
    if (biceps_mean > biceps_threshold) && (triceps_mean < triceps_threshold)
        movement = 'Flex';
        fprintf('  Rule 1: Biceps active, Triceps inhibited → FLEX\n');
        
    elseif (triceps_mean > triceps_threshold) && (biceps_mean < biceps_threshold)
        movement = 'Extend';
        fprintf('  Rule 2: Triceps active, Biceps inhibited → EXTEND\n');
        
    else
        % Ambiguous case: classify based on higher muscle mean
        fprintf('  Ambiguous case: Classifying based on higher muscle mean\n');
        if biceps_mean > triceps_mean
            movement = 'Flex';
            fprintf('    Biceps mean (%.2f) > Triceps mean (%.2f) → FLEX\n', ...
                biceps_mean, triceps_mean);
        else
            movement = 'Extend';
            fprintf('    Triceps mean (%.2f) >= Biceps mean (%.2f) → EXTEND\n', ...
                triceps_mean, biceps_mean);
        end
    end
end