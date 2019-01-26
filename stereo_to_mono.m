function audio_mono = stereo_to_mono(audio_stereo)
%STEREO_TO_MONO Summary of this function goes here
%   Detailed explanation goes here

audio_mono = sum(audio_stereo,2) / size(audio_stereo,2);
end

