T = readtable(batchtable);
n = height(T);
nT = sum(T.Compute);
clb

clear op
op.fpath       = 'images/batches/';
op.subdig      = 3;
op.imgdig      = 2;
op.ini         = 1;
op.gray        = 1;
if not(exist('net_loaded','var'))
    net_loaded = false;
end
disp(op);

for t=1:n
    disp('column');
    disp(t);
    if T.Compute(t) == 1
        op.img          = T.Image(t);
        op.prefix          = [lower(char(T.Prefix(t))) '/'];
        op.deg          = lower(char(T.Degradation(t)));
        op.degpar1      = T.ParDeg1(t);
        op.degpar2      = T.ParDeg2(t);
        op.degpar3      = T.ParDeg3(t);
        op.res          = lower(char(T.Restoration(t)));
        op.respar1      = T.ParRes1(t);
        op.respar2      = T.ParRes2(t);
        fname           = char(T.Output(t));
        if strcmp(fname,'auto')==1
            fname = [num2fixstr(op.img,2) '/' op.prefix];
            if strcmp(op.deg,'nothing')==0
                fname = [fname upper(op.deg)];
                if op.degpar1>0
                    fname = [fname '_' num2fixstr(op.degpar1,3)];
                    if op.degpar2>0
                        fname = [fname '_' num2fixstr(op.degpar2,3)];
                        if op.degpar3>0
                            fname = [fname '_' num2fixstr(op.degpar3,3)];
                        end
                    end
                    
                end
            end
            
            if and(op.img>26,op.img<32)
                fname = ['01_OOF_' num2fixstr(op.img-26,3)];
            end
           
            if strcmp(op.res,'nothing')==0
                fname = [fname '_' upper(op.res)];
                if op.respar1>0
                    fname = [fname '_' num2fixstr(op.respar1,3)];
                    if op.respar2>0
                        fname = [fname '_' num2fixstr(op.respar2,3)];
                    end
                end
            end
        end
        
        
        op.descriptor      = lower(char(T.Descriptor(t)));
        op.prefix
        dir_results = ['results/' op.descriptor '/' num2fixstr(op.img,2) '/' op.prefix]; 
        disp(dir_results);
        if not(exist(dir_results,'dir'))
            fprintf('making directory %s...\n',op.descriptor)
            mkdir(dir_results)
        end
        fst = [op.descriptor '/' fname];
        fst = strrep(fst,'.',',');
        fst
        fprintf('computing %3d/%3d > %s...\n',t,nT,fst);
        switch op.descriptor
            % case 'sift','dsift','surf','bow' ???
            case 'vgg'
                op.fx_function   = 'fx_deepdesc';
                op.size          = 4096;
                if not(net_loaded)
                    disp('loading vgg-face.mat...');
                    opfx = load('/Users/domingomery/Matlab/nets/vgg-face.mat');
                    net_loaded   = true;
                end
            case 'ivgg' % very bad
                op.fx_function   = 'fx_deepdesc';
                op.size          = 2048;
                if not(net_loaded)
                    disp('loading imagenet-vgg-m-2048...');
                    opfx = load('/Users/domingomery/Matlab/nets/imagenet-vgg-m-2048');
                    net_loaded   = true;
                end
            case 'alex' % very bad
                op.fx_function   = 'fx_deepdesc';
                op.size          = 4096;
                if not(net_loaded)
                    disp('loading imagenet-caffe-alex...');
                    opfx = load('/Users/domingomery/Matlab/nets/imagenet-caffe-alex');
                    net_loaded   = true;
                end
            case 'lbp'
                op.fx_function   = 'fx_lbp';
                opfx.vdiv        = 6;
                opfx.hdiv        = 6;
                opfx.samples     = 8;
                opfx.mappingtype = 'u2';
                opfx.resize      = [165 120];
                op.size = 59*opfx.vdiv*opfx.hdiv;
            case 'gabor'
                op.fx_function   = 'fx_gabor';
                opfx.d1   = 16;   % factor of downsampling along rows.
                opfx.d2   = 16;   % factor of downsampling along columns.
                opfx.u    = 6;   % number of scales
                opfx.v    = 8;   % number of orientations
                opfx.mm   = 31;  % rows of filter bank
                opfx.nn   = 31;  % columns of filter bank
                opfx.show = 0;   % display gabor masks            
                opfx.resize      = [256 256];
                op.size = 0;
            case 'int'
                op.fx_function   = 'fx_int';
                opfx.hight        = 50;
                opfx.width        = 45;
                op.size = opfx.hight*opfx.width;
        end
        XX = fx_descriptor(op,opfx);
        op.x = single(XX);
        if not(isempty(fname))
            save(['results/' fst],'op');
        end
    end
end