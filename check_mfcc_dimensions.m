% Path to the directory containing .mat files
mfcc_dir = 'features/Train_MFCC'; % Replace with the actual directory path

% List all .mat files in the directory
mfcc_files = dir(fullfile(mfcc_dir, '*.mat'));

% Initialize a cell array to store file names and dimensions
file_data = cell(length(mfcc_files), 2);

% Iterate over each .mat file
for i = 1:length(mfcc_files)
    % Get the full path of the file
    file_path = fullfile(mfcc_dir, mfcc_files(i).name);
    
    % Load the MFCC matrix
    loaded_data = load(file_path); % Adjust variable name as needed
    if isfield(loaded_data, 'mfccs') % Check if 'mfccs' exists
        mfccs = loaded_data.mfccs; % Replace 'mfccs' with the actual variable name
        [num_frames, num_coefficients] = size(mfccs);
        
        % Store the file name and dimensions
        file_data{i, 1} = mfcc_files(i).name; % File name
        file_data{i, 2} = [num_frames, num_coefficients]; % Dimensions
    else
        fprintf('MFCC matrix not found in file: %s\n', mfcc_files(i).name);
        file_data{i, 1} = mfcc_files(i).name; % File name
        file_data{i, 2} = 'Not Found'; % Indicate missing data
    end
end

% Convert to a table for easy visualization
file_table = cell2table(file_data, 'VariableNames', {'FileName', 'Dimensions'});

% Display the table
disp(file_table);

% Optionally, save the table as a CSV for documentation
writetable(file_table, 'MFCC_Dimensions.csv');
