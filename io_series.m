% It compares the results of descriptor of image f1 with all images
% mentioned in f2s.

% Example 1: f1 = '14'; f2s = {'01_OOF_001'}; % comparison with only one
% Example 1: f1 = '14'; f2s = {'01_OOF*'};    % comparison with many

f1   = '01';  % Cambiar aca el nombre del archivo
f2s = { '03_REG*'};
descriptor = 'lbp';

show = 0;

sortcurves = 0;

x = strfind(f1,'_');
f1t = f1;
f1t(x) = '-';

f2o = f2s{1};
if f2o(end)=='*'
    dl = dir(['results/' descriptor '/' f2o]);
    n2 = length(dl);
    f2dir = 1;
else
    n2 = length(f2s);
    f2dir = 0;
end



l2 = cell(n2,1);
RRec = [];
PPre = [];
CC   = [];
APR = [];
for i2=1:n2
    if f2dir==1
        f2 = dl(i2).name;
        f2(end-3:end) = [];
    else
        f2 = f2s{i2};
    end
    x = strfind(f2,'_');
    f2t = f2;
    f2t(x) = '-';
    l2{i2} = f2t;
    io_curves
    RRec  = [RRec   Rec];
    PPre  = [PPre   Pre];
    CC    = [CC     ct];
    APR   = [APR; APrRe];
end


figure(4)
jjj = 1:length(APR);
if sortcurves==1
    [iii,jjj] = sort(APR,'descend');
end
plot(RRec(:,jjj),PPre(:,jjj),'linewidth',2)
legend(l2{jjj});
title([f1t ' vs.'])
grid on
axis([0 1 0 1])
xlabel('Recall');ylabel('Precision')

figure(5)
plot((0:nr),CC(:,jjj),'linewidth',2)
legend(l2{jjj});
title([f1t ' vs.'])
grid on
axis([0 nr 0 100])
xlabel('rank')
ylabel('cumulative score')

% APR(1) = 0; %% WHAT IS THIS LINE FOR?

[myp,jj] = max(APR);
fprintf('Best:\n');
if f2dir==1
    f2 = dl(jj).name;
    f2(end-3:end) = [];
else
    f2 = f2s{jj};
end

fprintf('%10s/%-25s: Pr = %5.2f @ Re = %5.2f APR = %5.4f\n',f1,f2,yp,xp,myp)


% jjj = [1 jj];
%
% figure(6)
% plot(RRec(:,jjj),PPre(:,jjj))
% legend(l2{jjj});
% title([f1 ' vs.'])
% grid on
% axis([0 1 0 1])
% xlabel('Recall');ylabel('Precision')
%
% figure(7)
% plot((0:nr),CC(:,jjj))
% legend(l2{jjj});
% title([f1 ' vs.'])
% grid on
% axis([0 nr 0 100])
% xlabel('rank')
% ylabel('cumulative score')
%
