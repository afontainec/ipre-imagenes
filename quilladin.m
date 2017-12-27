function I2 = quilladin(I20, param1, param2)

J = imresize(I20,[165 120]);
[N, M] = size(J);
J = im2double(J);
F = fftshift(fft2(J));

sigma = min([N, M]) / param1;
gauss = fspecial('gaussian', [N, M], sigma);
m = max(gauss(:));
gauss = 1 - gauss / m;
gauss = gauss * param2 + 1;
K = gauss.*F;

k = real(ifft2(ifftshift(K)));
k(k<0) = 0;
k(k>1) = 1;
I2 = uint8(k * 255);