% Copyright 2022 University of Illinois Board of Trustees. All Rights Reserved.
% These codes were authored by Melanie A. Brunet and Brittney L. Gorman under the supervision of Mary L. Kraft. 
% This file is part of KraftLab.github.io repository, which is released under specific terms.  See file License.txt file or go to https://creativecommons.org/licenses/by/4.0/ for full license details.

function [RalignData,Trans] = ROI_align(Data,ROI,num,Max,Min,Iter)
    % Crop Data to ROI
    L = size(Data,3);
    for i =1:L
    Data_croped(:,:,i) = imcrop(Data(:,:,i), ROI.Position);
    end

[optimizer, metric] = imregconfig('monomodal');
maxstep = Max/100;
optimizer.MaximumStepLength = maxstep;
optimizer.MinimumStepLength = Min;
optimizer.MaximumIterations = Iter;

Crop(:,:,1:num) = Data_croped(:,:,1:num);
RalignData(:,:,1:num) = Data(:,:,1:num);
for p= num:num:(L-num)
    
    r = p+(round(num/2));
        Matrix = Crop(:,:,p);
        Matrix_move = Data_croped(:,:,r);
        %Default spatial referencing objects
        fixedRefObj = imref2d(size(Matrix));
        movingRefObj = imref2d(size(Matrix_move));

        % Phase correlation
        tform = imregtform(Matrix_move,movingRefObj,Matrix,fixedRefObj,'translation',optimizer,metric);
        
        p1 = p+1;
        p2 = p+num;
        Crop(:,:,p1:p2) = imwarp(Data_croped(:,:,p1:p2), movingRefObj, tform, 'OutputView', fixedRefObj, 'SmoothEdges', true);
        
        
        Mobj = imref2d(size(Data(:,:,p1)));
        f = Data(:,:,p);
        fobj = imref2d(size(f));
        RalignData(:,:,p1:p2) = imwarp(Data(:,:,p1:p2),Mobj,tform,'OutputView',fobj,'SmoothEdges',true);
        for i = p1:p2
            Trans(:,:,i) = tform.T;
        end
end

if isinteger(L/num)
else
    
    for i=(L-rem(L,num)+1):(L)
        tform = affine2d(Trans(:,:,(L-rem(L,num)))); 
        RalignData(:,:,i) = imwarp(Data(:,:,i),Mobj,tform,'OutputView',fobj, 'SmoothEdges',true);
        Trans(:,:,i) = tform.T;
    end
end 
