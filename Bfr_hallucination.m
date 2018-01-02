% Igt  = imread('mlena.bmp');
% Igt  = imresize(Igt,[200 200]);
% Ilr = imresize(Igt,0.2);
% Ihr  = Bfr_hallucination(Ilr,5,'scn');
% figure(1);imshow(Igt);title('Ground truth');
% figure(2);imshow(Ilr);title('Low resolution');
% figure(3);imshow(Ihr);title('Hi resolution');
% PSNR = compute_psnr(Igt,Ihr);
% fprintf('PSNR = %f dB\n', PSNR);



function J = Bfr_hallucination(I,s,method)



switch lower(method)
    case 'scn'
        % these files are on SCN directory (see model's subdirectory)
        load('weights_srnet_x2_52.mat');
        load('conv_h1.mat');
        load('conv_h2.mat');
        load('conv_g2.mat');
        model.conv_h1 = conv_h1;
        model.conv_h2 = conv_h2;
        model.conv_g2 = conv_g2;
        
        im_l = I;
        
        up_scale = s;
        use_gpu = 0;
        
        im_l  = double(im_l) / 255.0;
        
        [H,W,C] = size(im_l);
        if C == 3
            im_l_ycbcr = rgb2ycbcr(im_l);
        else
            KK = zeros(H,W,C);
            KK(:,:,1) = im_l;
            KK(:,:,2) = im_l;
            KK(:,:,3) = im_l;
            im_l_ycbcr = rgb2ycbcr(KK);
            %im_l_ycbcr = zeros(H,W,C);
            %im_l_ycbcr(:,:,1) = im_l;
            %im_l_ycbcr(:,:,2) = im_l;
            %im_l_ycbcr(:,:,3) = im_l;
        end
        
        im_l_y = im_l_ycbcr(:,:,1);
        im_h_y = SCN_Matconvnet(im_l_y, model,up_scale,use_gpu);
        im_h_y = im_h_y * 255;
        
        im_h_ycbcr = imresize(im_l_ycbcr,up_scale,'bicubic');
        im_h_ycbcr(:,:,1) = im_h_y / 255.0;
        im_h  = ycbcr2rgb(im_h_ycbcr) * 255.0;
        J = uint8(im_h);
        if C==1
            J = rgb2gray(J);
            % J = J(:,:,1);
        end
        
        
    case 'scsr'
        
        D = round(log(s)/log(2));
        sd = s/2^D;
        % set parameters
        lambda = 0.2;                   % sparsity regularization
        overlap = 4;                    % the more overlap the better (patch size 5x5)
        % up_scale = 2;                 % scaling factor, depending on the trained dictionary
        maxIter = 20;                   % if 0, do not use backprojection
        
        % load dictionary % see folder ScSR
        load('D_1024_0.15_5.mat');
        % load('D_512_0.15_5.mat');
        
        im_l = I;
        
        for i=1:D
            
            fprintf('computing iteration %d/%d...\n',i,D);
            
            % change color space, work on illuminance only
            [H,W,C] = size(im_l);
            
            if C == 3
                im_l_ycbcr = rgb2ycbcr(im_l);
            else
                KK = uint8(zeros(H,W,C));
                KK(:,:,1) = im_l;
                KK(:,:,2) = im_l;
                KK(:,:,3) = im_l;
                im_l_ycbcr = rgb2ycbcr(KK);
                %im_l_ycbcr = zeros(H,W,C);
                %im_l_ycbcr(:,:,1) = im_l;
                %im_l_ycbcr(:,:,2) = im_l;
                %im_l_ycbcr(:,:,3) = im_l;
            end
            
            
            % im_l_ycbcr = rgb2ycbcr(im_l);
            im_l_y = im_l_ycbcr(:, :, 1);
            im_l_cb = im_l_ycbcr(:, :, 2);
            im_l_cr = im_l_ycbcr(:, :, 3);
            
            % image super-resolution based on sparse representation
            [im_h_y] = ScSR(im_l_y, 2, Dh, Dl, lambda, overlap);
            [im_h_y] = backprojection(im_h_y, im_l_y, maxIter);
            
            % upscale the chrominance simply by "bicubic"
            [nrow, ncol] = size(im_h_y);
            im_h_cb = imresize(im_l_cb, [nrow, ncol], 'bicubic');
            im_h_cr = imresize(im_l_cr, [nrow, ncol], 'bicubic');
            
            im_h_ycbcr = zeros([nrow, ncol, 3]);
            im_h_ycbcr(:, :, 1) = im_h_y;
            im_h_ycbcr(:, :, 2) = im_h_cb;
            im_h_ycbcr(:, :, 3) = im_h_cr;
            im_h = ycbcr2rgb(uint8(im_h_ycbcr));
            
            if C == 1;
                im_h = rgb2gray(im_h);
            end
            
            im_l = im_h;
        end
        if abs(sd-1)>0.0001
            fprintf('adjusting size...\n');
            im_h = imresize(im_h,sd,'bicubic');
        end
        J = uint8(im_h);
%        if C==1
%            J = rgb2gray(J);
%            % J = J(:,:,1);
%        end

    otherwise
        J = imresize(I,s,method);
end


