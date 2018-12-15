function [data_pasien, y] = load_data_windows()

path_sehat = dir(fullfile('data', 'sehat', '*.wav'));
path_sakit = dir(fullfile('data', 'sakit', '*.wav'));

for i = 1:numel(path_sehat)
    filename_sehat = fullfile(path_sehat(i).name);
    label_sehat = 'sehat';
    y_sehat{i} = label_sehat;
    full_path = fullfile('data', label_sehat, filename_sehat);
    data_sehat{i} = audioread(full_path);
end

for j = 1:numel(path_sakit)
    filename_sakit = fullfile(path_sakit(j).name);
    label_sakit = 'sakit';
    y_sakit{j} = label_sakit;
    full_path = fullfile('data', label_sehat, filename_sakit);
    data_sakit{j} = audioread(full_path);
end

y = [y_sehat y_sakit];
data_pasien = [data_sehat data_sakit];