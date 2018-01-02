% XX matrix of descriptions of 100 images of AR dataset after degradation
% and restoration. See comments below
function XX = fx_descriptor(op,opfx)


% parameters of degradation
opdeg.par1 = op.degpar1;
opdeg.par2 = op.degpar2;
opdeg.par3 = op.degpar3;


% parameters of restoration
opres.par1 = op.respar1;
opres.par2 = op.respar2;
% opres.par3 = op.respar3;


% op.deg and op.res are the degaradtion and restoration method? name
deg = not(strcmp(op.deg,'nothing')); % 'nothing' means no degradation
res = not(strcmp(op.res,'nothing')); % 'nothing' means no restoration


% all 100 images op.img of AR are extracted
sq = ['_' num2fixstr(op.img,op.imgdig) '.png'];

N  = 100; % numer of images

% if op.ini==1 % op.ini must be 1 to extract the features
%     XX = zeros(N,op.size);
% else
%     XX = op.x;
% end

if op.ini==0 % op.ini must be 1 to extract the features %% HELP: QUE ES ESTO
    XX = op.x;
end

ft = Bio_statusbar('extracting features');
for i=1:N
    ft = Bio_statusbar(i/N,ft);
    
    if op.ini
        % read image op.img of subject i
        st = [op.fpath op.prefix num2fixstr(i,op.subdig) sq];
        I = imread(st);
        if op.gray == 1
            if size(I,3) == 3
                I = rgb2gray(I);
            end
        end
        % first image is displayed
        if i==1
            figure(1);imshow(I,[]);title('original');
        end
        % in case of degradation
        if deg
            I = im_preprocessing(I,op.deg,opdeg);
            if i==1
                figure(2);imshow(I,[]);title('degraded');
            end
        end
        % in case of restoration
        if res
            I = im_preprocessing(I,op.res,opres);
            if i==1
                figure(3);imshow(I,[]);title('restored');
            end
        end
        % row i contains the descriptrion of image op.img of subject i
        % the description is extracted using function op.fx_function with
        % parameters opfx
        x = feval(op.fx_function,I,opfx);
        if op.size == 0 %% QUE ES ESTO
            op.size = length(x);
            XX = zeros(N,op.size);
            fprintf('descriptor has %d elements.\n',op.size);
        end
        XX(i,:) = x;
    end
    
end
delete(ft)




