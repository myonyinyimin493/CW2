    function mel_filterbank = melFilterBank(fs, fft_size, num_filters)
        % Frequency range
        low_freq = 0; % Minimum frequency in Hz
        high_freq = fs / 2; % Nyquist frequency in Hz
    
        % Convert frequency to Mel scale
        low_mel = hz2mel(low_freq);
        high_mel = hz2mel(high_freq);
    
        % Compute Mel scale points
        mel_points = linspace(low_mel, high_mel, num_filters + 2);
        hz_points = mel2hz(mel_points); % Convert back to Hz
    
        % Map frequencies to FFT bin indices
        bin_points = floor((fft_size + 1) * hz_points / fs);
    
        % Clamp bin_points to valid range
        bin_points = max(1, min(bin_points, fft_size / 2)); % Ensure indices are valid
    
        % Create filterbank matrix
        mel_filterbank = zeros(num_filters, fft_size / 2);
        for i = 1:num_filters
            % Ensure indices are valid integers and within range
            start_idx = bin_points(i);
            center_idx = bin_points(i+1);
            end_idx = bin_points(i+2);
    
            % Apply triangular filter
            mel_filterbank(i, start_idx:center_idx) = ...
                linspace(0, 1, center_idx - start_idx + 1);
            mel_filterbank(i, center_idx:end_idx) = ...
                linspace(1, 0, end_idx - center_idx + 1);
        end
    end
    
    function mel = hz2mel(hz)
        % Convert frequency from Hz to Mel scale
        mel = 2595 * log10(1 + hz / 700);
    end
    
    function hz = mel2hz(mel)
        % Convert frequency from Mel scale to Hz
        hz = 700 * (10.^(mel / 2595) - 1);
    end
