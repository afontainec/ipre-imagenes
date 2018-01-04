f1_alg = {'MED_013'};
f1_params = {''};
images = [51 52 53 54 55];
fixed = true;

for if1 = 1:length(f1_alg)
    for jf1 = 1:length(f1_params)
        for kima = 1:length(images)
            f1 = [num2fixstr(images(kima),2) '/comparison/' f1_alg{if1} f1_params{jf1}];
            f2s = {[num2fixstr(images(kima),2) '/blurred/TONY*']};
            io_series
        end
    end
end