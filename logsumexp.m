function result = logsumexp(log_values)
    % Computes log(sum(exp(log_values))) in a numerically stable way
    max_log = max(log_values); % Find the maximum log value for stability
    result = max_log + log(sum(exp(log_values - max_log)));
end
