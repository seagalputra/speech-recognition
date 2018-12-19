function [data_latih, data_uji, y_latih, y_uji] = load_data_latihuji()

folder_latih = dir(fullfile('data','latih', '*.wav'));
folder_uji = dir(fullfile('data', 'uji', '*.wav'));

for i = 1:numel(folder_latih)
    filename_latih = fullfile(folder_latih(i).folder, folder_latih(i).name);
    label = split(folder_latih(i).name, '_');
    data_latih{i} = audioread(filename_latih);
    y_latih{i} = label{1};
end

for j = 1:numel(folder_uji)
    filename_uji = fullfile(folder_uji(j).folder, folder_uji(j).name);
    label = split(folder_uji(j).name, '_');
    data_uji{j} = audioread(filename_uji);
    y_uji{j} = label{1};
end

