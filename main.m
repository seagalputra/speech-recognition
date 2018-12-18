clc;
clear;
close all;

% addpath('lib/mfcc/');
% addpath('lib/sap-voicebox/voicebox');
% addpath('lib');

% [data_audio, y] = load_data();
[data_audio, y] = load_data_windows();
%% Lakukan preprocessing
audio_mono = {};
for ii = 1:size(data_audio,2)
    % konversi audio stereo ke mono
    audio_stereo = data_audio{ii};
    audio_mono{ii} = sum(audio_stereo,2) / size(audio_stereo,2);
end
%% Ekstraksi fitur audio dengan menggunakan MFCC
ciri = [];
fs = 44100;
koeff = 13;
window_length = round(fs*0.012);
overlap_length = round(fs*0.008);

disp('Loading.. Feature extraction is processing..');
for jj = 1:size(audio_mono,2)
    audio_mfcc{jj} = mfcc_feature(audio_mono{jj}, fs, koeff, window_length, overlap_length);
    % temp_audio_mfcc = temp_audio_mfcc';
    % audio_mfcc{jj} = temp_audio_mfcc;
    fprintf('audio %s extracted..\n ',num2str(jj));
end

%% Pilih koeff
filter = [2,3,10];
for m = 1:size(audio_mfcc,2)
    koeff_mfcc{m} = audio_mfcc{m}(:,filter(:));
end

for kk = 1:size(audio_mfcc,2)
    ciri_temp = [mean(koeff_mfcc{kk}) std(koeff_mfcc{kk}) var(koeff_mfcc{kk}) skewness(koeff_mfcc{kk})...
        kurtosis(koeff_mfcc{kk}) entropy(koeff_mfcc{kk})];
    ciri = [ciri; ciri_temp];
end
ciri = real(ciri);

%% Shuffle data serta membagi data menjadi data training dan testing

% Random data training dan data testing
y = y';
[m, n] = size(y);
idx = randperm(m);
y_data = y(idx,:);
ciri_data = ciri(idx,:);

% Split data training dan data testing
X_training = ciri_data(1:100,:);
X_testing = ciri_data(101:125,:);
Y_training = y_data(1:100,:);
Y_testing = y_data(101:125,:);

%% Fit binary classification tree
disp('Please wait.. Still fitting model..');
dt = fitctree(X_training,Y_training);
prediction = dt.predict(X_testing);
view(dt, 'Mode', 'Graph');

%% Hitung akurasi
for ll = 1:size(Y_testing,1)
    if (isequal(prediction(ll),Y_testing(ll)))
        right_label(ll) = 1;
    else
        right_label(ll) = 0;
    end
end
akurasi = sum(right_label) / size(Y_testing,1) * 100;
fprintf('Akurasi model : %s\n', num2str(akurasi));