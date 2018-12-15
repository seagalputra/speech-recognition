clc;
clear;
close all;

addpath('lib/mfcc/');
addpath('lib/sap-voicebox/voicebox');

[data_audio, y] = load_data();
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
Tw = 70;           % analysis frame duration (ms)
Ts = 10;           % analysis frame shift (ms)
alpha = 0.97;      % preemphasis coefficient
R = [ 0 4000 ];  % frequency range to consider
M = 20;            % number of filterbank channels 
C = 13;            % number of cepstral coefficients
L = 0.6;            % cepstral sine lifter parameter
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

disp('Loading.. Feature extraction is processing..');
for jj = 1:size(audio_mono,2)
    temp_audio_mfcc = mfcc(audio_mono{jj}, fs, Tw, Ts, alpha, hamming, R, M, C, L);
    temp_audio_mfcc = temp_audio_mfcc';
    audio_mfcc{jj} = temp_audio_mfcc;
    fprintf('audio %s extracted..\n ',num2str(jj));
end

for kk = 1:size(audio_mfcc,2)
    ciri_temp = [mean(audio_mfcc{kk}) std(audio_mfcc{kk}) var(audio_mfcc{kk}) skewness(audio_mfcc{kk})...
        kurtosis(audio_mfcc{kk}) entropy(audio_mfcc{kk})];
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

%% Hitung akurasi
for ll = 1:size(Y_testing,1)
    if (isequal(prediction(ll), Y_testing(ll)))
        right_label(ll) = 1;
    else
        right_label(ll) = 0;
    end
end
akurasi = sum(right_label) / size(Y_testing,1) * 100;
fprintf('Akurasi model : %s\n', num2str(akurasi));