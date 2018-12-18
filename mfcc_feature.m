function audio_mfcc = mfcc_feature(audio, fs, koeff, window_length, overlap_length)

alpha = 0.97;      % preemphasis coefficient
R = [ 0 4000 ];  % frequency range to consider
M = 20;            % number of filterbank channels
L = 0.6;            % cepstral sine lifter parameter
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

% audio_mfcc = mfcc(audio, fs, window_length, overlap_length, alpha, hamming, R, M, C, L);
audio_mfcc = mfcc(audio,fs,'NumCoeffs',koeff,'windowlength',window_length,'overlaplength',overlap_length);
end

