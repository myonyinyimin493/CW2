function evaluate_recognizer(true_labels, predicted_labels)
    % Evaluate recognition performance and calculate metrics.
    [conf_matrix, order] = confusionmat(true_labels, predicted_labels);

    % Display the confusion matrix
    disp('Confusion Matrix:');
    disp(array2table(conf_matrix, 'VariableNames', order, 'RowNames', order));

    % Plot confusion matrix as heatmap
    figure;
    heatmap(order, order, conf_matrix, 'Title', 'Confusion Matrix', ...
        'XLabel', 'Predicted Labels', 'YLabel', 'True Labels');
    colormap('cool');
    colorbar;

    % Calculate evaluation metrics
    disp('Calculating Metrics...');
    [precision, recall, f1_score] = calculate_metrics(conf_matrix);

    % Display metrics
    disp('Class-wise Precision:');
    disp(array2table(precision, 'VariableNames', order));
    disp('Class-wise Recall:');
    disp(array2table(recall, 'VariableNames', order));
    disp('Class-wise F1-Score:');
    disp(array2table(f1_score, 'VariableNames', order));

    % Save metrics
    save('evaluation_metrics.mat', 'conf_matrix', 'precision', 'recall', 'f1_score');
end
