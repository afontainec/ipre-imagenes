function k = blur_index(I)
[W, H] = size(I);
if(W == 66)
    k = 1;
elseif(W == 33)
    k = 2;
elseif(W == 22)
    k = 3;
elseif(W == 11)
    k = 4;
elseif(W == 7)
    k = 5;
else
    blur = fmeasure(I, 'LAPE');
    if(blur >= 31)
        k = 6;
    elseif(blur >= 20)
        k = 7;
    elseif(blur >= 18.3)
        k = 8;
    elseif(blur >= 17.6)
        k = 9;
    elseif(blur >= 10.3)
        k = 10;
    elseif(blur >= 7.86)
        k = 11;
    elseif(blur >= 5.1)
        k = 12;
    elseif(blur >= 3.6)
        k = 13;
    elseif(blur >= 2.9)
        k = 14;
    elseif(blur >= 1.66)
        k = 15;
    else
       k = 16;
    end
end
