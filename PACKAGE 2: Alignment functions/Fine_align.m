% Copyright 2022 University of Illinois Board of Trustees. All Rights Reserved.
% These codes were authored by Melanie A. Brunet and Brittney L. Gorman under the supervision of Mary L. Kraft. 
% This file is part of KraftLab.github.io repository, which is released under specific terms.  See file License.txt file or go to https://creativecommons.org/licenses/by/4.0/ for full license details.


function [FalignData,Trans] = Fine_align(Data,Max,Min,Iter)
%Data: Data to be drift corrected
%Max: Maximum possible final move distance, decreasing this number should
%achieve a more precise alignment at the expenses of computational power
%and not moving as quickly. If you're not sure what willbe needed the
%standard distance should be set to 6.25.

% Align each image to the previous image based on intensity
L=size(Data,3);
[optimizer,metric]= imregconfig('monomodal');
maxstep = Max/100;
optimizer.MinimumStepLength = Min;
optimizer.MaximumStepLength = maxstep;
optimizer.MaximumIterations = Iter;
FalignData(:,:,1) = Data(:,:,1);

for p= 1:(L-1)
    r = p+1;
    Matrix = FalignData(:,:,p);
    Matrix_move = Data(:,:,r);
    
    fixedRefObj = imref2d(size(Matrix));
    movingRefObj = imref2d(size(Matrix_move));
    
    tform = imregtform(Matrix_move,movingRefObj, Matrix,fixedRefObj, 'translation',optimizer, metric);
    Trans(:,:,r) = tform.T;
    
        FalignData(:,:,r) = imwarp(Data(:,:,r), tform,'OutputView', fixedRefObj);    
end
