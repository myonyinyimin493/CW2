% Test loading and displaying an HMM
hmm_file = 'Train_hmm_folder/head_hmm.mat'; % Path to the HMM file

% Check if the file exists
if exist(hmm_file, 'file')
    % Load the HMM
    load(hmm_file, 'prototype_hmm');
    
    % Display the HMM structure
    disp('HMM structure for the word "had":');
    disp(prototype_hmm);
else
    warning(['HMM file not found: ', hmm_file]);
end
