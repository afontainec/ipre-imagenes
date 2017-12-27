f = '/Users/domingomery/Dropbox/Mingo/Matlab/images/faces/faces_ar_LQ/';

L = {'C1','C0','B1','B2','B3','B4','B5','L1','L2','L3','L4','L5'};

for i=1:100
    for j=1:12
        st = [f 'face_' num2fixstr(i,3) '_' L{j} '.png'];
        I = imread(st);
        st = ['face_' num2fixstr(i,3) '_' num2fixstr(j,2) '.png'];
        imwrite(I,st,'png');
    end
end
    
