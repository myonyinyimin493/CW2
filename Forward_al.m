function log_alpha = Forward_al(features, hmm)
    num_states = size(hmm.transition, 1);
    num_frames = size(features, 2);
    num_features = size(features, 1);

    % Initialize log_alpha matrix
    log_alpha = -inf(num_states, num_frames); % Logarithm of probabilities

    % Initialize log_alpha for t = 1
    for j = 1:num_states
        obs_prob = -0.5 * sum(((features(:, 1) - hmm.mean(:, j)).^2) ./ (hmm.variance(:, j) + eps)) - ...
                   0.5 * num_features * log(2 * pi) - 0.5 * sum(log(hmm.variance(:, j) + eps));
        log_alpha(j, 1) = log(hmm.transition(1, j) + eps) + obs_prob;
    end

    % Recursively calculate log_alpha for t > 1
    for t = 2:num_frames
        for j = 1:num_states
            obs_prob = -0.5 * sum(((features(:, t) - hmm.mean(:, j)).^2) ./ (hmm.variance(:, j) + eps)) - ...
                       0.5 * num_features * log(2 * pi) - 0.5 * sum(log(hmm.variance(:, j) + eps));
            log_alpha(j, t) = obs_prob + logsumexp(log_alpha(:, t-1) + log(hmm.transition(:, j) + eps));
        end
    end
end
