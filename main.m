clc;
clear;
close all;

addpath('lib/mfcc/');
addpath('lib/sap-voicebox/voicebox');

load 'data/data_pasien.mat';
%% Lakukan preprocessing
audio_mono = {};
for i = 1:size(data_audio,2)
    % konversi audio stereo ke mono
    audio_stereo = data_audio{i};
    audio_mono{i} = sum(audio_stereo,2) / size(audio_stereo,2);
end
%% Ekstraksi fitur audio dengan menggunakan MFCC
audio_mfcc = {};
fs = 44100;
for i = 1:size(audio_mono,2)
    % audio_mfcc{i} = mfcc_feature(audio_mono{i}, fs, 13, 256);
    audio_mfcc{i} = melfcc(audio_mono{i}, fs);
    audio_mfcc{i} = reshape(audio_mfcc{i},1,[]);
end