function m = mfcc_feature(x, fs, koef, nframe)

bank = v_melbankm(koef, nframe, fs, 0, 0.5, 't');
bank = full(bank);
bank = bank/max(bank(:));

for k = 1:koef
    n = 0:koef-1;
    dctcoef(k,:) = cos((2*n+1)*k*pi/(2*2*koef));
end

w = 1 + 6 * sin(pi * [1:koef] ./ koef);
w = w/max(w);

xx = double(x);
xx = filter([1 -0.9375], 1, xx);

xx = enframe(xx, nframe, nframe/2);

for i = 1:size(xx, 1)
    y = xx(i,:);
    s = y' .* hamming(nframe);
    t = abs(fft(s));
    t = t.^2;
    c1 = dctcoef * log(bank * t(1:nframe/2+1));
    c2 = c1.*w';
    m(i,:) = c2';
end

end


