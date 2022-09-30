%% Coarse Align 
% Copyright 2022 University of Illinois Board of Trustees. All Rights Reserved.
% These codes were authored by Melanie A. Brunet and Brittney L. Gorman under the supervision of Mary L. Kraft. 
% This file is part of KraftLab.github.io repository, which is released under specific terms.  See file License.txt file or go to https://creativecommons.org/licenses/by/4.0/ for full license details.

function [CalignData,Trans] = Coarse_align(Data,num,Max,Min,Iter)
%Data: Data that needs to be aligned due to drift
%num: number of files that should be shift at one time
          %max: The maximum distance that an image can move during alignment
%CalignData: Data course aligned
%Trans: Translations taken to align the data
length = size(Data,3);
[optimizer, metric] = imregconfig('monomodal');
maxstep = Max/100;
optimizer.MaximumStepLength = maxstep;
optimizer.MinimumStepLength = Min;
optimizer.MaximumIterations = Iter;
Trans = zeros(3,3,length);
Trans(1,1,:) = 1;
Trans(2,2,:) = 1;
Trans(3,3,:) = 1;

CalignData(:,:,1:num) = Data(:,:,1:num);
for p= num:num:(length-num)
    r = p+round(num/2);
    Matrix = CalignData(:,:,p);
    Matrix_move = Data(:,:,r);
    
    fixedRefObj = imref2d(size(Matrix));
    movingRefObj = imref2d(size(Matrix_move));
    
    tform = imregtform(Matrix_move,movingRefObj, Matrix,fixedRefObj, 'translation',optimizer, metric);
    
    p1 = p+1;
    p2 = p + num;
    CalignData(:,:,p1:p2) = imwarp(Data(:,:,p1:p2), tform,'OutputView', fixedRefObj);
    for i = p1:p2
    Trans(:,:,i) = tform.T;
    end
end

if isinteger(length/num)
else
    for i=(length-rem(length,num)+1):(length)
        tform = affine2d(Trans(:,:,(length-num))); 
        CalignData(:,:,i) = imwarp(Data(:,:,i), tform,'OutputView', fixedRefObj);
        Trans(:,:,i) = tform.T;
    end
end 
