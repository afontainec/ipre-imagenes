% pre-processing of image I using method 'method' with parameters
% options.par1 and options.par 2. There are image restoration, low
% resolution, super-resolution and filtering masks.

function I = im_preprocessing(I,method,options)
adjustHistogram = false;
if(endsWith(lower(method), '++'))
    adjustHistogram = true;
    method = extractBefore(method, '++');
end
switch lower(method)
    % IMAGE RESTORATION
    case 'reg'
        I = imresize(I,[165 120]);
        PSF = fspecial('gaussian',options.par1,options.par1/8.5);
        PSF = PSF/sum(PSF(:));
        I = deconvreg(I,PSF,options.par2);
    case {'imsharpen','sharp'}
        I = imresize(I,[165 120]);
        I = imsharpen(I,'Radius',options.par1,'Amount',options.par2/10);
    case 'lucy'
        I = imresize(I,[165 120]);
        PSF = fspecial('gaussian',options.par1,options.par1/8.5);
        PSF = PSF/sum(PSF(:));
        I = deconvreg(I,PSF,options.par2);
    case 'wiener'
        I = imresize(I,[165 120]);
        PSF = fspecial('gaussian',options.par1,options.par1/8.5);
        PSF = PSF/sum(PSF(:));
        I = deconvwnr(I,PSF,options.par2/100);
    case 'blind' % falta mas testing y definicion de este case
       I = imresize(I,[165 120]);
        PSF = fspecial('gaussian',options.par1,options.par1/8.5);
        %         WT = zeros(size(I,1),size(I,2));WT(5:end-4,5:end-4) = 1;
        %         INITPSF = ones(size(PSF));
        I=deconvblind(I,PSF,options.par2);
        % LOW RESOLUTION
    case 'lr'
        I = imresize(I,1/options.par1);
        % SUPER RESOLUTION
    case 'scn'
        I = Bfr_hallucination(I,options.par1,'scn');
       case 'scsr'
        I = Bfr_hallucination(I,options.par1,'scsr');
        % DEGRADATION
    case {'gaussian','gauss'}
        PSF = fspecial('gaussian',options.par1,options.par1/8.5);
        PSF = PSF/sum(PSF(:));
        I   = imfilter(I,PSF);
    case 'mask'
        I   = imfilter(I,options.par1);
    case 'quilladin'
        I = imresize(I,[165 120]);
        I = quilladin(I, options.par1, options.par2);
    case 'quilladinbutter'
        I = imresize(I,[165 120]);
        I = quilladinButter(I, options.par1, options.par2, options.par3);
    case 'tony'
        I = imresize(I,[165 120]);
        I = tony(I, options.par1, options.par2/10);
    case 'med'
        I = medfilt2(I, [options.par1 options.par1]);
end
if(adjustHistogram)
    I(I>255) = 255;
    I(I<0) = 0;
end
