% Copyright 2022 University of Illinois Board of Trustees. All Rights Reserved.
% These codes were authored by Melanie A. Brunet and Brittney L. Gorman under the supervision of Mary L. Kraft. 
% This file is part of KraftLab.github.io repository, which is released under specific terms.  See file License.txt file or go to https://creativecommons.org/licenses/by/4.0/ for full license details.

function [Matrix_masked] = Masking_Pixels(Data,percentage,varargin)

%Data: is the data that needs to be masked
%percentage is the percent of the maximum that should remain in the image.
   % write percentage in units of % (ie. 10% is 10)
%varargin: data name you are working with (ie. 'N14', 'O16')
%Pixel Masking - This program masks the pixels that are below a threshold value
%This will be applied to the denominator data i.e. 16O and 14N data before ratio.

% dirNameMask = uigetdir(); %Opens a window to select the folder where the data will be read from
% %dirNameMask = '/Users/melanie.brunet/Desktop/SIMS/O-18'; % Sub-folder 1 path (Specify your folder)
% H = dir( fullfile(dirNameMask,'*.txt'));
% file_numMask = length(H);
% 
% Filenumber1 = (141-1);

L = length(Data(1,1,:));
ThreeD = zeros(size(Data,1),size(Data,2),L);
Matrix_masked = zeros(size(Data,1),size(Data,2),L);

P = percentage/100;
for i = 1:L

    Max = max(Data(:,:,i),[],'all'); % ThreeD Determines the maximum value on each z plane for each loop (z=1, z=2,..)
    Threshold = (Max * P); % 10% is used for CHOLESTEROL (10% of the maximum counts)[See Ashley's paper for reference]
                          % 5% is used for SPHINGOLIPIDS (5% of the maximum counts)
                          
    for j = 1:size(Data,1)       % j=x values
        for k = 1:size(Data,2)   % k=y values
            Matrix = Data(j,k,i); %This variable stores the matrix for example j=1:512 k=1:512 i=1,2,3... in each loop.
            if Matrix <= Threshold 
                Matrix_masked(j,k,i) = 0; %If the cell value is less or equal than the threshold value, set the value to zero.
            else
                Matrix_masked(j,k,i) = Matrix; %If the cell value is greater than the threshold value, set the value to the same as in the 'Matrix' matrix.
            end
        end
    end
end

end
