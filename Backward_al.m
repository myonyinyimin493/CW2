function log_beta = Backward_al(features, hmm)
    num_states = size(hmm.transition, 1);
    num_frames = size(features, 2);
    num_features = size(features, 1);

    % Initialize log_beta matrix
    log_beta = -inf(num_states, num_frames); % Logarithm of probabilities

    % Initialize log_beta for t = T (final frame)
    log_beta(:, end) = 0; % Log(1) = 0

    % Recursively calculate log_beta for t < T
    for t = num_frames-1:-1:1
        for i = 1:num_states
            log_probs = zeros(num_states, 1);
            for j = 1:num_states
                obs_prob = -0.5 * sum(((features(:, t+1) - hmm.mean(:, j)).^2) ./ (hmm.variance(:, j) + eps)) - ...
                           0.5 * num_features * log(2 * pi) - 0.5 * sum(log(hmm.variance(:, j) + eps));
                log_probs(j) = log(hmm.transition(i, j) + eps) + obs_prob + log_beta(j, t+1);
            end
            log_beta(i, t) = logsumexp(log_probs);
        end
    end
end
