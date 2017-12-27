% This example extract some LBP features of image and image 01 and 
% out-of-focus image 01 and compare them using precision-recall curves
clt
batchtable = 'batch_demo.xlsx';
batch_test % <- all descriptors to be extracted are defined in batchtable 
% io_series  % <- all comparison are defined in f1 and f2s in io_series.m

