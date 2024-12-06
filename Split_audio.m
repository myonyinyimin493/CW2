% Set paths
source_folder = 'EEEM030cw2-DevelopmentSet-2024';
output_folder = ''; % Replace with your desired output folder
mkdir(output_folder); % Create the output folder if it doesn't exist

% Vocabulary and split ratios
words = {'heed', 'hid', 'head', 'had', 'hard', 'hud', 'hod', 'hoard', 'hood', 'whod', 'heard'};
train_ratio = 0.7; % 70% training
test_ratio = 0.2;  % 20% testing
custom_ratio = 0.1; % 10% custom

% Loop through each word
for i = 1:length(words)
    word = words{i};
    % Get all files for this word
    files = dir(fullfile(source_folder, ['*_' word '.mp3'])); % Find all files with the word
    num_files = length(files);
    
    % Ensure enough files are available
    if num_files < 3
        error(['Not enough files for the word: ', word]);
    end
    
    % Shuffle files for randomness
    files = files(randperm(num_files));
    
    % Calculate split indices
    num_train = round(train_ratio * num_files);
    num_test = round(test_ratio * num_files);
    num_custom = num_files - num_train - num_test;
    
    % Split files
    train_files = files(1:num_train);
    test_files = files(num_train+1:num_train+num_test);
    custom_files = files(num_train+num_test+1:end);
    
    % Create output subfolders
    train_folder = fullfile(output_folder, 'Train', word);
    test_folder = fullfile(output_folder, 'Test', word);
    custom_folder = fullfile(output_folder, 'Custom', word);
    mkdir(train_folder);
    mkdir(test_folder);
    mkdir(custom_folder);
    
    % Copy train files
    for j = 1:length(train_files)
        copyfile(fullfile(train_files(j).folder, train_files(j).name), train_folder);
    end
    
    % Copy test files
    for j = 1:length(test_files)
        copyfile(fullfile(test_files(j).folder, test_files(j).name), test_folder);
    end
    
    % Copy custom files
    for j = 1:length(custom_files)
        copyfile(fullfile(custom_files(j).folder, custom_files(j).name), custom_folder);
    end
    
    disp(['Processed ', word, ': ', ...
          num2str(length(train_files)), ' train, ', ...
          num2str(length(test_files)), ' test, ', ...
          num2str(length(custom_files)), ' custom']);
end

disp('Data split into Train, Test, and Custom folders successfully!');