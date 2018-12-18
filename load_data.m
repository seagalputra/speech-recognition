function [data_audio, y] = load_data(folder)

if nargin < 1
    folder = 'data';
end

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
end