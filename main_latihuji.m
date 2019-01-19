%% Hapus semua variable, tutup window dan load data audio

% sebelum menjalankan file main_latihuji.mat, terlebih dahulu jalankan file
% load_data.mat
clc;
clear;
close all;

load(fullfile('data', 'data_audio.mat'));

%% Lakukan preprocessing dengan mengkonversi audio stereo menjadi mono
for ii = 1:size(data_latih,2)
    % konversi audio stereo ke mono untuk data latih
    audio_stereo = data_latih{ii};
    audio_mono_latih{ii} = sum(audio_stereo,2) / size(audio_stereo,2);
end

for ii = 1:size(data_uji,2)
    % konversi audio stereo ke mono untuk data uji
    audio_stereo = data_uji{ii};
    audio_mono_uji{ii} = sum(audio_stereo,2) / size(audio_stereo,2);
end

%% Ekstraksi fitur audio dengan menggunakan MFCC

% input parameter yang dibutuhkan mfcc
fs = 44100;
koeff = 13;
window_length = round(fs*0.012);
overlap_length = round(fs*0.008);

disp('Loading.. Feature extraction is processing..');
for jj = 1:size(audio_mono_latih,2)
    audio_mfcc_latih{jj} = mfcc_feature(audio_mono_latih{jj}, fs, koeff, window_length, overlap_length);
    fprintf('audio latih %s extracted..\n ',num2str(jj));
end

for jj = 1:size(audio_mono_uji,2)
    audio_mfcc_uji{jj} = mfcc_feature(audio_mono_uji{jj}, fs, koeff, window_length, overlap_length);
    fprintf('audio uji %s extracted..\n ',num2str(jj));
end
%% Pilih koeff dengan mengubah variabel filter sebanyak nilai koeff
ciri_latih = [];
ciri_uji = [];
filter = [1:14]; % ubah nilai array berikut
for m = 1:size(audio_mfcc_latih,2)
    koeff_mfcc_latih{m} = audio_mfcc_latih{m}(:,filter(:));
end

for m = 1:size(audio_mfcc_uji,2)
    koeff_mfcc_uji{m} = audio_mfcc_uji{m}(:,filter(:));
end

for kk = 1:size(audio_mfcc_latih,2)
    ciri_temp = [mean(koeff_mfcc_latih{kk}) std(koeff_mfcc_latih{kk}) var(koeff_mfcc_latih{kk}) skewness(koeff_mfcc_latih{kk})...
        kurtosis(koeff_mfcc_latih{kk}) entropy(koeff_mfcc_latih{kk})];
    ciri_latih = [ciri_latih; ciri_temp];
end
ciri_latih = real(ciri_latih);

for kk = 1:size(audio_mfcc_uji,2)
    ciri_temp = [mean(koeff_mfcc_uji{kk}) std(koeff_mfcc_uji{kk}) var(koeff_mfcc_uji{kk}) skewness(koeff_mfcc_uji{kk})...
        kurtosis(koeff_mfcc_uji{kk}) entropy(koeff_mfcc_uji{kk})];
    ciri_uji = [ciri_uji; ciri_temp];
end
ciri_uji = real(ciri_uji);
%% Lakukan prediksi dengan menggunakan decision tree
disp('Please wait.. Still fitting model..');
y_latih = y_latih';
y_uji = y_uji';
dt = fitctree(ciri_latih,y_latih); % proses learning untuk data latih
prediction = dt.predict(ciri_uji); % prediksi label untuk data uji
view(dt, 'Mode', 'Graph');
saveCompactModel(dt, 'model_decision_tree');

%% Menghitung akurasi dari data uji yang dipilih
for ll = 1:size(y_uji,1)
    if (isequal(prediction(ll),y_uji(ll)))
        right_label(ll) = 1;
    else
        right_label(ll) = 0;
    end
end
akurasi = sum(right_label) / size(y_uji,1) * 100;
fprintf('Akurasi model : %s\n', num2str(akurasi));