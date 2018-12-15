function [audio_mfcc] = ekstraksi_ciri(audio, fs, koeff, window_length, overlap_length)
alpha = 0.97;
R = [ 0 4000 ];
M = 20;
L = 0.6;
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

for ii = 1:size(audio,2)
    temp_audio_mfcc = mfcc(audio{ii}, fs, window_length, overlap_length, alpha, hamming, R, M, koeff, L);
    temp_audio_mfcc = temp_audio_mfcc';
    audio_mfcc{ii} = temp_audio_mfcc;
end

end