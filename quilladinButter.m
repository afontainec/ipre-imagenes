function I2 = quilladinButter(I20, param1, param2, A)

%param1 = Do
%param2 = n
%A = amplitud


J = imresize(I20,[165 120]);
[P, Q] = size(J);
J = im2double(J);
F = fftshift(fft2(J));

H = zeros(P,Q);
m = 2*param2;

Do= param1;


for u=1:P
    for v=1:Q
        H(u,v) = 1/(1+((sqrt((u-P/2)^2+(v-Q/2)^2))/Do)^m);
    end
end

ma = max(H(:));
H = 1-H/ma;
H = H*A+1;


K = H.*F;

k = real(ifft2(ifftshift(K)));
k(k<0) = 0;
k(k>1) = 1;
I2 = uint8(k * 255);