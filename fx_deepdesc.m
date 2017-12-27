% descriptor extracted using a deep learning net and matconvnet
% net = load('/Users/domingomery/Matlab/nets/vgg-face.mat');
% im = imread('mlena.bmp');
% x = fx_deepdesc(im,net);

function x = fx_deepdesc(im,net)

[N,M,P]       = size(im);
if P==1
    im3           = zeros(N,M,3);
    im3(:,:,1)    = im;
    im3(:,:,2)    = im;
    im3(:,:,3)    = im;
else
    im3 = im;
end
imavg         = net.meta.normalization.averageImage;
im_           = single(im3) ; % note: 255 range
im_           = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
if numel(imavg) == 3
    vgg_avg = zeros(size(im_));
    vgg_avg(:,:,1) = imavg(1);
    vgg_avg(:,:,2) = imavg(2);
    vgg_avg(:,:,3) = imavg(3);
else
    vgg_avg = imavg;
end
im_ = im_ - vgg_avg ;
res = vl_simplenn(net, im_) ;
scores = squeeze(gather(res(end-2).x)) ;
x = scores(:)';
