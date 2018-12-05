clc;
clear;
close all;

%% Load dataset pada folder
folder = 'dataset';
audio_files = dir(fullfile(folder, '**/*.wav'));

for i = 1:numel(audio_files)
    path = audio_files(i).folder;
    filename = strcat('/', audio_files(i).name);
    full_path = strcat(path, filename);
    data = audioread(full_path);
end

%% Ekstraksi fitur audio dengan menggunakan MFCC
addpath('lib/mfcc/');

[y, fs] = audioread('dataset/data_sakit/4.wav');
fs_mfcc = 44100;
hasil_mfcc = melfcc(y(:,1), fs_mfcc);
figure(1);
specgram(y(:,1), 256, fs);
% area(y);
title 'Pasien Sakit'
figure(2);
area(hasil_mfcc);
title 'Hasil MFCC Pasien Sakit';