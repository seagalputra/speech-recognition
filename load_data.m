clc;
clear;
close all;

folder = 'data';
audio_files = dir(fullfile(folder, '**/*.wav'));
data_audio = {};
for i = 1:numel(audio_files)
    path = audio_files(i).folder;
    filename = strcat('/', audio_files(i).name);
    label = split(path, '/');
    y(i) = label(7);
    full_path = strcat(path, filename);
    data_audio{i} = audioread(full_path);
end

save('data/data_pasien.mat','data_audio','y');