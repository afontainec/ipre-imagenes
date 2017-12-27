% extraction of grayvalues of image I
% the image is resized and the matrix of the image is transformed to a
% column

function X = fx_gabor(I,opfx)
if size(I,3)==3
    I = rgb2gray(I);
end
I = imresize(I,opfx.resize);
X = Bfx_gaborfull(I,opfx);