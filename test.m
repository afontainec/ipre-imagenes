for j  = 1:7
    X = zeros(100, 1);
    for i  = 1:100
    str = ['images/faces_ar_lq/face_' num2fixstr(i, 3) '_' num2fixstr(j, 2) '.png' ];
    I = imread(str);
    X(i) =  fmeasure(I, 'LAPE');
    end
    figure(j);
    plot(X);
    disp('-----------------------');
    disp(j);
    disp(max(X));
    disp(min(X));
end

%% >31 solo 1 y 2
%% >20 1, 2 y 3
%% >18.3 solo 3
%% >17.6 3 y 4
%% >10.3 solo 4
%% >7.86 solo 4 y 5
%% >5.1 solo 5 
%% >3.6 5 y 6
%% >2.9 solo 6
%% >1.66 6 y 7
%% else solo 7