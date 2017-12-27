function W = tony(I, n, y)
I = im2double(I);
%% SHARPEN
F = conv2(I,ones(n,n)/n^2,'same');
J = I + y*(I-F);
W = J;
W(J>1) = 1;
W = uint8(J * 255);
end