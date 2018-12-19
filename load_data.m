clear;
clc;
close all;

filename = fullfile('data', 'data_audio.mat');

if exist(filename, 'file') == 2
    delete(filename);
end

path_sehat = dir(fullfile('data', 'sehat', '*.wav'));
path_sakit = dir(fullfile('data', 'sakit', '*.wav'));

for i = 1:numel(path_sehat)
    filename_sehat = fullfile(path_sehat(i).name);
    y_sehat{i} = 'sehat';
    full_path = fullfile('data', 'sehat', filename_sehat);
    data_sehat{i} = audioread(full_path);
end

for j = 1:numel(path_sakit)
    filename_sakit = fullfile(path_sakit(j).name);
    y_sakit{j} = 'sakit';
    full_path = fullfile('data', 'sakit', filename_sakit);
    data_sakit{j} = audioread(full_path);
end

y = [y_sehat y_sakit];
data_pasien = [data_sehat data_sakit];

% shuffle data
y = y';
data_pasien = data_pasien';
index_shuffle = randperm(numel(data_pasien));
y = y(index_shuffle);
data_pasien = data_pasien(index_shuffle);

% pisahkan data menjadi data latih dan data uji
data_latih = data_pasien(1:100,:);
data_uji = data_pasien(101:125,:);
y_latih = y(1:100,:);
y_uji = y(101:125,:);
data_latih = data_latih';
data_uji = data_uji';
y_latih = y_latih';
y_uji = y_uji';

% simpan data dalam bentuk .mat
save(filename, 'data_latih', 'data_uji' , 'y_latih', 'y_uji');