function [precision, recall, f1_score] = calculate_metrics(conf_matrix)
    % Calculate Precision, Recall, and F1-Score for a confusion matrix.
    num_classes = size(conf_matrix, 1);
    precision = zeros(1, num_classes);
    recall = zeros(1, num_classes);
    f1_score = zeros(1, num_classes);

    for i = 1:num_classes
        true_positive = conf_matrix(i, i);
        false_positive = sum(conf_matrix(:, i)) - true_positive;
        false_negative = sum(conf_matrix(i, :)) - true_positive;

        precision(i) = true_positive / (true_positive + false_positive + eps);
        recall(i) = true_positive / (true_positive + false_negative + eps);
        f1_score(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i) + eps);
    end
end
