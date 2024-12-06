function save_results(accuracy, conf_matrix, likelihoods, output_folder)
    if ~isfolder(output_folder)
        mkdir(output_folder);
    end
    
    % Save metrics
    save(fullfile(output_folder, 'accuracy.mat'), 'accuracy');
    save(fullfile(output_folder, 'conf_matrix.mat'), 'conf_matrix');
    save(fullfile(output_folder, 'likelihoods.mat'), 'likelihoods');
    
    % Save textual summary
    summary_file = fullfile(output_folder, 'summary.txt');
    fid = fopen(summary_file, 'w');
    fprintf(fid, 'Recognition Accuracy: %.2f%%\n\n', accuracy * 100);
    fprintf(fid, 'Confusion Matrix:\n');
    fclose(fid);
    dlmwrite(summary_file, conf_matrix, '-append', 'delimiter', '\t');
end
