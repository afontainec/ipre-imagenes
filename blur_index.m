function k = blur_index(I)
[W, H] = size(I);
if(W == 66)
    k = 51;
elseif(W == 33)
    k = 52;
elseif(W == 22)
    k = 53;
elseif(W == 11)
    k = 54;
elseif(W == 7)
    k = 55;
else
    blur = fmeasure(I, 'LAPE');
    if(blur >= 31)
        k = 56;
    elseif(blur >= 20)
        k = 57;
    elseif(blur >= 18.3)
        k = 58;
    elseif(blur >= 17.6)
        k = 59;
    elseif(blur >= 10.3)
        k = 60;
    elseif(blur >= 7.86)
        k = 61;
    elseif(blur >= 5.1)
        k = 62;
    elseif(blur >= 3.6)
        k = 63;
    elseif(blur >= 2.9)
        k = 64;
    elseif(blur >= 1.66)
        k = 65;
    else
       k = 66;
    end
end
