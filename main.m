clc;
clear;
close all;

addpath('lib/mfcc/');
addpath('lib/sap-voicebox/voicebox');

path = fullfile('data', 'data_audio.mat');
load(path);
%% Lakukan preprocessing

% konversi audio stereo tiap data menjadi mono
for ii = 1:size(data_latih,2)
    audio_mono_latih{ii} = sum(data_latih{ii},2) / size(data_latih{ii},2);
end

for n = 1:size(data_uji,2)
    audio_mono_uji{n} = sum(data_uji{n},2) / size(data_uji{n},2);
end
%% Ekstraksi fitur audio dengan menggunakan MFCC
ciri_latih = [];
ciri_uji = [];

fs = 44100;
window_length = round(fs*0.012);
overlap_length = round(fs*0.008);
koeff = 13;

disp('Loading.. Feature extraction is processing..');
audio_mfcc_latih = ekstraksi_ciri(audio_mono_latih, fs, koeff, window_length, overlap_length);
audio_mfcc_uji = ekstraksi_ciri(audio_mono_uji, fs, koeff, window_length, overlap_length);

%% pilih koeff
filter = [2 3 5 7 10];
for ii = 1:size(audio_mfcc_latih,2)
    koeff_mfcc_latih{ii} = audio_mfcc_latih{ii}(:,filter(:));
end

for ii = 1:size(audio_mfcc_uji,2)
    koeff_mfcc_uji{ii} = audio_mfcc_uji{ii}(:,filter(:));
end

%% Parameter statistik
for jj = 1:size(koeff_mfcc_latih,2)
    for m = 1:size(filter,2)
        temp_koeff_latih = koeff_mfcc_latih{jj}(:,m);
        ent_latih(jj,m) = real(entropy(temp_koeff_latih));
    end
end

for jj = 1:size(koeff_mfcc_uji,2)
    for m = 1:size(filter,2)
        temp_koeff_uji = koeff_mfcc_uji{jj}(:,m);
        ent_uji(jj,m) = real(entropy(temp_koeff_uji));
    end
end

%%
for kk = 1:size(koeff_mfcc_latih,2)
    ciri_temp = [mean(koeff_mfcc_latih{kk}) std(koeff_mfcc_latih{kk}) var(koeff_mfcc_latih{kk}) skewness(koeff_mfcc_latih{kk})...
        kurtosis(koeff_mfcc_latih{kk}) ent_latih(kk,:)];
    ciri_latih = [ciri_latih; ciri_temp];
end
ciri_latih = real(ciri_latih);

for b = 1:size(koeff_mfcc_uji,2)
    ciri_temp = [mean(koeff_mfcc_uji{b}) std(koeff_mfcc_uji{b}) var(koeff_mfcc_uji{b}) skewness(koeff_mfcc_uji{b})...
        kurtosis(koeff_mfcc_uji{b}) ent_uji(b,:)];
    ciri_uji = [ciri_uji; ciri_temp];
end
ciri_uji = real(ciri_uji);

%% Konversi cell ke char
for c = 1:size(y_latih,2)
    y_latih{c} = char(y_latih{c});
end

for d = 1:size(y_uji,2)
    y_uji{d} = char(y_latih{d});
end

%% Fit binary classification tree
y_latih = y_latih';
y_uji = y_uji';

disp('Please wait.. Still fitting model..');
dt = fitctree(ciri_latih,y_latih);
view(dt, 'Mode', 'Graph');
prediction = dt.predict(ciri_uji);

%% Hitung akurasi
counter = 0;
for ll = 1:size(y_uji,1)
    if (isequal(prediction{ll}, y_uji{ll}))
        counter = counter + 1;
    end
end

akurasi = counter / size(y_uji,1) * 100;
fprintf('Akurasi model : %s persen\n', num2str(akurasi));