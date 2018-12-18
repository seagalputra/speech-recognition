function [data_pasien, y] = load_data_windows()

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