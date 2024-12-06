function log_likelihood = viterbi_algorithm(features, hmm)
    % Initialize dimensions
    num_states = size(hmm.transition, 1);
    num_frames = size(features, 2);

    % Convert transition probabilities to log-space for numerical stability
    log_transition = log(hmm.transition + eps);
    log_likelihood_matrix = zeros(num_states, num_frames);

    % Compute log-likelihoods for each frame
    for t = 1:num_frames
        for j = 1:num_states
            log_likelihood_matrix(j, t) = -0.5 * sum(((features(:, t) - hmm.mean(:, j)).^2) ./ ...
                (hmm.variance(:, j) + eps)) - 0.5 * log(2 * pi * prod(hmm.variance(:, j) + eps));
        end
    end

    % Compute overall log-likelihood normalized by sequence length
    log_likelihood = max(log_likelihood_matrix(:)) / num_frames; % Sequence length normalization
end
