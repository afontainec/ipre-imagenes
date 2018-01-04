function k = blur_index(I)
[W, H] = size(I);
if(W == 66)
    k = 2;
elseif(W == 33)
    k = 3;
elseif(W == 22)
    k = 4;
elseif(W == 11)
    k = 5;
elseif(W == 7)
    k = 6;
else
    k = 1;
end
