function [ciri, audio_mfcc] = ekstraksi_ciri(audio_data)

fs = 44100;
koeff = 13;
window_length = round(fs*0.012);
overlap_length = round(fs*0.008);

audio_mfcc = mfcc_feature(audio_data, fs, koeff, window_length, overlap_length);
ciri = [mean(audio_mfcc) std(audio_mfcc) var(audio_mfcc) skewness(audio_mfcc)...
    kurtosis(audio_mfcc) entropy(audio_mfcc)];
end