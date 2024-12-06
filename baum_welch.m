function trained_hmm = baum_welch(features, hmm, num_iterations)
    num_states = size(hmm.transition, 1);
    num_frames = size(features, 2);
    num_features = size(features, 1); % Number of features
    trained_hmm = hmm;

    for iteration = 1:num_iterations
        disp(['Iteration: ', num2str(iteration)]);

        % Expectation Step (E-Step)
        log_alpha = Forward_al(features, trained_hmm);
        log_beta = Backward_al(features, trained_hmm);

        gamma = zeros(num_states, num_frames);
        xi = zeros(num_states, num_states, num_frames-1);

        % Compute gamma and xi
        for t = 1:num_frames
            log_gamma = log_alpha(:, t) + log_beta(:, t);
            gamma(:, t) = exp(log_gamma - logsumexp(log_gamma)); % Normalize using logsumexp
        end

        for t = 1:num_frames-1
            for i = 1:num_states
                for j = 1:num_states
                    obs_prob = -0.5 * sum(((features(:, t+1) - trained_hmm.mean(:, j)).^2) ./ ...
                                 (trained_hmm.variance(:, j) + eps)) - ...
                                0.5 * num_features * log(2 * pi) - ...
                                0.5 * sum(log(trained_hmm.variance(:, j) + eps));
                    xi(i, j, t) = exp(log_alpha(i, t) + log(trained_hmm.transition(i, j)) + obs_prob + ...
                                      log_beta(j, t+1) - ...
                                      logsumexp(log_alpha(:, t) + log_beta(:, t)));
                end
            end
        end

        % Maximization Step (M-Step)
        trained_hmm.transition = sum(xi, 3) ./ (sum(gamma(:, 1:end-1), 2) + eps);
        for j = 1:num_states
            gamma_sum = sum(gamma(j, :));
            trained_hmm.mean(:, j) = sum(features .* gamma(j, :), 2) / gamma_sum;
            trained_hmm.variance(:, j) = max(sum(((features - trained_hmm.mean(:, j)).^2) .* gamma(j, :), 2) / gamma_sum, eps);
        end

        disp(['Updated Mean: ', mat2str(trained_hmm.mean)]);
        disp(['Updated Variance: ', mat2str(trained_hmm.variance)]);
        disp(['Updated Transition Matrix: ', mat2str(trained_hmm.transition)]);
    end
end
