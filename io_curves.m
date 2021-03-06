% It computes curves and performance metrics by comparing the 100 descriptors
% of one set of images with the 100 descriptors of the another set. There
% are 100x100 comparisons: 100 positive and 9900 negative comparisons.
% The descritors are stored in op.descriptor'/'f1.mat and 
% op.descriptor'/'f2.mat respectivelly. This function is called by
% io_series.m

close all

if not(exist('show','var'))
    show = 1;
end
disp(f2)
data = load(['results/' descriptor '/' f1]); op1 = data.op;
data = load(['results/' descriptor '/' f2]); op2 = data.op;



xn1 = Bft_uninorm(op1.x);
xn2 = Bft_uninorm(op2.x);


% n=100;nq=n;D = distxy(Xn(1:nq,:),Xn(101:100+n,:));D=D/max2(D);[~,jj]=min(D,[],2);Bev_performance(jj,(1:nq)'),
% G = zeros(100,100);for i=1:100;for j=1:100;G(i,j) = Bfa_dXi2(xn1(i,:),xn2(j,:));end;end

n=100;nq=n;
D = xn2*xn1';
nr = 100;
Rk = zeros(100,nr);
for i=1:100
    s = D(i,:);
    [~,jj] = sort(s,'descend');
    kk = find(jj==i);
    q = kk(1);
    if q<=nr
        Rk(i,q:nr) = Rk(i,q:nr)+1;
    end
end



%D=D/max2(D);
[~,jj]=max(D,[],2);pp=Bev_performance(jj,(1:nq)');

if show == 1
    figure(1);clf
    %D = D.*D;
    %D = D/max2(D);
    Bio_showconfusion(D,0);
end
z = zeros(n*n,1);
d = z;
z(:) = D;
ii = (1:(n+1):n*n); % diagonal of D
d(ii) = 1;          % positive class

if show == 1
    figure(2);clf
    io_plotfeatures(z,d+1,'distance')
end
% GT = sum(d==1);
% FT = sum(d==0);
% FPR = zeros(101,1);
% TPR = zeros(101,1);
% for th=0:0.01:1
%     q = q+1;
%     TP = sum(and(z<th,d==1));
%     FP = sum(and(z<th,d==0));
%     FPR(q) = FP/FT;
%     TPR(q) = TP/GT;
% end
% figure(3)
% clf
% Bio_plotroc(FPR,TPR)

labels = d;
labels(d==0) = -1;

if show==1
    figure(3)
    clf
    [TPR,TNR,info] = vl_roc(labels,z,'plot','fptp');
end
% th = 0.5;



Pre = zeros(101,1);
Rec = zeros(101,1);
q = 0;
s = 0;
for th=0:0.01:1
    q = q+1;
    ds = z>th;
    TP = sum(and(ds==1,d==1));
    Pos = sum(d==1);
    De = sum(ds==1);
    Pre(q) = TP/De;
    Rec(q) = TP/Pos;
    if q>1
        % area under Pr-Re curve
        if and(not(isnan(Pre(q))),not(isnan(Rec(q))))
            s = s+(Rec(q-1)-Rec(q))*(Pre(q-1)+Pre(q))/2;
        end
    end
end

APrRe = s;


if show == 1
    figure(4)
    plot(Rec,Pre);axis([0 1 0 1])
    xlabel('Recall')
    ylabel('Precision')
    grid
end
xp = 0.5;
ii = find(and(Rec>=xp-0.025,Rec<=xp+0.025));
x = Rec(ii);
y = Pre(ii);
X = [x ones(length(ii),1)];
warning off
th = (X'*X)\X'*y;
warning on
yp = [xp 1]*th;
fprintf('%10s/%-25s: Pr = %5.2f @ Re = %5.2f APR = %5.4f\n',f1,f2,yp,xp,APrRe)
%fprintf('Rank:\n');
cc = sum(Rk);
ct = [0 cc]';
if show == 1
    figure(5)
    plot((0:nr),ct)
    axis([0 nr 0 100])
    xlabel('rank')
    ylabel('cumulative score')
end
if show==1
    enterpause
end
