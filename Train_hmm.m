function Train_hmm()
    words = {'heed', 'hid', 'head', 'had', 'hard', 'hud', 'hod', 'hoard', 'hood', 'whod', 'heard'};
    train_features_folder = 'features/Train_MFCC';
    hmm_folder = 'Train_hmm_folder';
    trained_hmm_folder = 'Train_hmm_folder_trained';

    if ~isfolder(trained_hmm_folder)
        mkdir(trained_hmm_folder);
    end

    num_iterations = 10;

    for i = 1:length(words)
        word = words{i};
        disp(['Training HMM for the word: ', word]);

        % Aggregate features
        feature_files_struct = dir(fullfile(train_features_folder, ['*', word, '*.mat']));
        aggregated_features = [];
        for j = 1:length(feature_files_struct)
            load(fullfile(feature_files_struct(j).folder, feature_files_struct(j).name), 'mfccs');
            aggregated_features = [aggregated_features, mfccs];
        end

        disp(['Aggregated Features for ', word, ': ', mat2str(size(aggregated_features))]);
        disp(['Feature Values Range: [', num2str(min(aggregated_features(:))), ', ', num2str(max(aggregated_features(:))), ']']);

        % Load initialized HMM
        prototype_hmm_file = fullfile(hmm_folder, [word, '_hmm.mat']);
        load(prototype_hmm_file, 'prototype_hmm');

        % Train HMM using Baum-Welch
        trained_hmm = baum_welch(aggregated_features, prototype_hmm, num_iterations);

        % Save trained HMM
        trained_hmm_file = fullfile(trained_hmm_folder, [word, '_trained_hmm.mat']);
        save(trained_hmm_file, 'trained_hmm');
        disp(['Trained HMM saved for the word: ', word]);
    end
end