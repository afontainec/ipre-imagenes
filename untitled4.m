f1_alg = {'MED_013'};
f1_params = {''};
images = [51 52];
fixed = true;
index = 0;
c = {};
filename = 'demo_result.csv';
for if1 = 1:length(f1_alg)
    for jf1 = 1:length(f1_params)
        for kima = 1:length(images)
            index = index + 1;
            alg1 = f1_alg{if1};
            f1 = [num2fixstr(images(kima),2) '/comparison/' alg1 f1_params{jf1}];
            f2s = {[num2fixstr(images(kima),2) '/blurred/TONY*']};
            io_series
            f2parts =strsplit(f2, '/');
            c{index, 1} = alg1;
            c{index, 2} = f2parts{3};
            c{index, 3} = f2parts{1};
            c{index, 4} =  myp;
        end
    end
end
fid = fopen('test.csv', 'w');
for wc = 1:size(c)
fprintf(fid, '%s,', c{wc,1:end-1}) ;
fprintf(fid, '%s\n', c{wc,end}) ;
end
fclose(fid) ;


