function [frame, nframe, pframe] = frameblocking(y, wframe, woverlap)
%FRAMEBLOCKING2 Summary of this function goes here
%   Detailed explanation goes here
if nargin<3, woverlap = 20; end
if nargin<2, wframe   = 30; end

pframe = floor(16000*(wframe/1000));
poverlap = floor(16000*(woverlap/1000));
jframe = pframe - poverlap;

nframe = floor((length(y)-poverlap)/jframe);
frame = zeros(pframe, nframe);
for i=1:nframe
    startIndex = (i-1)*jframe + 1;
    frame(:,i) = y(startIndex:(startIndex+pframe-1 ));
end

end

