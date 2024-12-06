function initialize_hmm()
    % Vocabulary words
    words = {'heed', 'hid', 'head', 'had', 'hard', 'hud', 'hod', 'hoard', 'hood', 'whod', 'heard'};

    % Input/output folders
    train_features_folder = 'features/Train_MFCC';
    hmm_folder = 'Train_hmm_folder';
    if ~isfolder(hmm_folder)
        mkdir(hmm_folder);
    end

    % Loop through words to initialize HMMs
    for i = 1:length(words)
        word = words{i};
        disp(['Initializing HMM for the word: ', word]);

        % Construct the file pattern to match your naming convention
        pattern = fullfile(train_features_folder, ['*_w*_', word, '.mat']);
        disp(['Pattern: ', pattern]); % Debugging

        % Collect feature files for the word
        feature_files_struct = dir(pattern);
        disp(['Aggregating features for word: ', word]);
        disp(['Number of files for ', word, ': ', num2str(length(feature_files_struct))]);

        if isempty(feature_files_struct)
            warning(['No feature files found for word: ', word]);
            continue;
        end

        % Load and aggregate features
        aggregated_features = [];
        for j = 1:length(feature_files_struct)
            disp(['Loading file: ', feature_files_struct(j).name]); % Debugging
            load(fullfile(feature_files_struct(j).folder, feature_files_struct(j).name), 'mfccs');
            aggregated_features = [aggregated_features, mfccs]; %#ok<AGROW>
        end

        % Compute global statistics
        global_mean = mean(aggregated_features, 2);
        global_variance = var(aggregated_features, 0, 2);

        % Initialize HMM
        num_states = 8;
        prototype_hmm.mean = repmat(global_mean, 1, num_states);
        prototype_hmm.variance = repmat(global_variance, 1, num_states);
        prototype_hmm.transition = diag(ones(num_states, 1) * 0.8) + diag(ones(num_states-1, 1) * 0.2, 1);
        prototype_hmm.transition(end, end) = 1;

        % disp(['Initializing HMM for word: ', word]);
        % disp(['Aggregated Features Size: ', mat2str(size(aggregated_features))]);
        % disp(['Mean Size: ', mat2str(size(prototype_hmm.mean))]);
        % disp(['Variance Size: ', mat2str(size(prototype_hmm.variance))]);
        % disp(['Transition Matrix Size: ', mat2str(size(prototype_hmm.transition))]);


        % Save the initialized HMM
        output_file = fullfile(hmm_folder, [word, '_hmm.mat']);
        save(output_file, 'prototype_hmm');
        disp(['HMM initialized and saved for the word: ', word]);
    end
end