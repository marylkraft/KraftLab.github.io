% Copyright 2022 University of Illinois Board of Trustees. All Rights Reserved.
% These codes were authored by Melanie A. Brunet and Brittney L. Gorman under the supervision of Mary L. Kraft. 
% This file is part of KraftLab.github.io repository, which is released under specific terms.  
% See file License.txt file or go to https://creativecommons.org/licenses/by/4.0/ for full license details.

function Data_aligned = alignment(Data)
%Written by Brittney Gorman
%Translate the data set based on the translations determined with the Drift
%correction

fileName=uigetfile(); %Opens a window to select the folder where the data will be read from
file = load(fileName); %Loads the translations previously encoded by the SE alignment
Drift_Trans= cell2mat(struct2cell(file));
L = length(Data(1,1,:));
Data_aligned(:,:,1) = Data(:,:,1);
for i = 1:(L-1)
    j = i + 1;
    
    Matrix = Data_aligned(:,:,i); %Loads each file 
    Matrix_move = Data(:,:,j); %Loads the following file
    
    fixedRefObj = imref2d(size(Matrix)); %defines the 1st file as a fixed object
    movingRefObj = imref2d(size(Matrix_move)); %defines the second file as the moving object
    tform = affine2d(Drift_Trans(:,:,j)); %defines the shifts for this pair of images
    
    Data_aligned(:,:,j) = imwarp(Data(:,:,j), tform,'OutputView', fixedRefObj); %Apply the shifts
    
end
