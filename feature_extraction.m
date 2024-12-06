function feature_extraction(input_folder, output_folder)
    % List all subfolders (e.g., heed, heard, head, etc.)
    subfolders = dir(input_folder);
    subfolders = subfolders([subfolders.isdir]); % Keep only directories
    subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'})); % Exclude . and ..

    for i = 1:length(subfolders)
        word_folder = fullfile(input_folder, subfolders(i).name);
        files = dir(fullfile(word_folder, '*.mp3')); % Get all .mp3 files in the subfolder

        for j = 1:length(files)
            audio_file = fullfile(files(j).folder, files(j).name);
            [~, name, ~] = fileparts(files(j).name);
            output_file = fullfile(output_folder, [name, '.mat']);
            
            % Process audio file to extract MFCCs
            [audio_signal, fs] = audioread(audio_file);
            frame_duration = 0.03; % 30 ms
            hop_duration = 0.01; % 10 ms
            frame_length = round(frame_duration * fs);
            hop_length = round(hop_duration * fs);

            % Frame the signal with overlap
            frames = buffer(audio_signal, frame_length, frame_length - hop_length, 'nodelay');
            window = hamming(frame_length);
            windowed_frames = bsxfun(@times, frames, window);

            % Compute FFT and Mel filterbank
            fft_size = 512;
            spectrogram = abs(fft(windowed_frames, fft_size));
            spectrogram = spectrogram(1:fft_size/2, :);

            num_mel_filters = 26;
            mel_filterbank = melFilterBank(fs, fft_size, num_mel_filters);
            mel_energies = mel_filterbank * spectrogram;
            log_mel_energies = log(mel_energies + eps);
            mfccs = dct(log_mel_energies);
            mfccs = mfccs(1:13, :); % Only the first 13 coefficients
            disp(['Feature file: ', output_file]);
            disp(['MFCCs size: ', mat2str(size(mfccs))]);
            disp(['MFCC dimensions for ', audio_file, ': ', mat2str(size(mfccs))])


            % Save the MFCC features
            save(output_file, 'mfccs');
            disp(['MFCC features saved to ', output_file]);
        end
    end
end