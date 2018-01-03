c = [];
for k = 51:66
    c(k) = 0;
end
for i = 1:100
    str = ['images/faces_ar_lq/face_' num2fixstr(i,3) '_' num2fixstr(1, 2) '.png'];
    J = imread(str); %% comparison image
    for j = 2:12
        str = ['images/faces_ar_lq/face_' num2fixstr(i,3) '_' num2fixstr(j, 2) '.png'];
        I = imread(str);
        blurIndex = blur_index(I);
        c(blurIndex) = c(blurIndex) + 1;
        newPath = ['images/batches/' num2fixstr(blurIndex, 2) '/blurred/' num2fixstr(c(blurIndex),3) '.png'];
        imwrite(I, newPath);
        comparisonPath = ['images/batches/' num2fixstr(blurIndex, 2) '/comparison/' num2fixstr(c(blurIndex),3) '.png'];
        imwrite(J, comparisonPath);
    end
end
