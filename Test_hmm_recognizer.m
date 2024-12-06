function [accuracy, conf_matrix, likelihoods] = Test_hmm_recognizer(features_folder, words, trained_hmm_folder)
    % Initialize storage for results
    true_labels = {};
    predicted_labels = {};
    likelihoods = [];
    
    % Mapping of numeric labels to word labels
    label_mapping = containers.Map({'01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11'}, ...
                                   {'heed', 'hid', 'head', 'had', 'hard', 'hud', 'hod', 'hoard', 'hood', 'whod', 'heard'});
    
    % List all feature files
    feature_files = dir(fullfile(features_folder, '*.mat'));
    
    % Loop through each feature file
    for i = 1:length(feature_files)
        feature_file = fullfile(feature_files(i).folder, feature_files(i).name);
        [~, feature_file_name, ~] = fileparts(feature_files(i).name);
        
        % Extract true label from filename
        true_label = extractBetween(feature_file_name, '_w', '_');
        if isempty(true_label)
            true_labels{end+1} = 'unknown';
        else
            if isKey(label_mapping, true_label{1})
                true_labels{end+1} = label_mapping(true_label{1});
            else
                true_labels{end+1} = 'unknown';
                warning(['Unknown label: ', true_label{1}]);
            end
        end
        
        disp(['Processing file: ', feature_file_name, ' for true label: ', true_labels{end}]);
        
        % Load the MFCC features
        load(feature_file, 'mfccs');
        
        % Compute log-likelihoods for each trained HMM
        log_likelihoods = zeros(1, length(words));
        for j = 1:length(words)
            word = words{j};
            trained_hmm_file = fullfile(trained_hmm_folder, [word, '_trained_hmm.mat']);
            
            if ~isfile(trained_hmm_file)
                warning(['Trained HMM not found for word: ', word]);
                continue;
            end
            
            % Load the trained HMM
            load(trained_hmm_file, 'trained_hmm');
            
            % Compute the log-likelihood using the Viterbi algorithm
            log_likelihoods(j) = viterbi_algorithm(mfccs, trained_hmm);
        end
        
        % Recognize the word with the highest likelihood
        [~, predicted_index] = max(log_likelihoods);
        predicted_labels{end+1} = words{predicted_index};
        likelihoods(end+1) = max(log_likelihoods); % Save the likelihood
    end
    
    % Evaluate the recognizer performance
    conf_matrix = confusionmat(true_labels, predicted_labels, 'Order', words);
    accuracy = sum(strcmp(true_labels, predicted_labels)) / length(true_labels);
    
    % Display results
    disp(['Recognition Accuracy: ', num2str(accuracy * 100), '%']);
    disp('Confusion Matrix:');
    disp(conf_matrix);
    
    % Plot confusion matrix as heatmap
    plot_confusion_matrix(conf_matrix, words, 'Recognition Results');
    
    % Save results for reporting
    save_results(accuracy, conf_matrix, likelihoods, 'results/Test_Results');
    % Call evaluate_recognizer with true and predicted labels
    evaluate_recognizer(true_labels, predicted_labels);
end
