c = zeros(66, 1);
for i = 1:100
    i
    for j = 1:12
        for k = 50:66
            str = ['images/faces_ar_lq/face_' num2fixstr(i, 3) '_' num2fixstr(j, 2) '_' num2fixstr(k, 2) '.png' ];
            c(k) = c(k) +  exist(str);
        end
    end
end
c = c/2