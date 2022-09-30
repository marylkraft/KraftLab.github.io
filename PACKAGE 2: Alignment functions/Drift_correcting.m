%% Load the data
% Copyright 2022 University of Illinois Board of Trustees. All Rights Reserved.
% These codes were authored by Melanie A. Brunet and Brittney L. Gorman under the supervision of Mary L. Kraft. 
% This file is part of KraftLab.github.io repository, which is released under specific terms.  See file License.txt file or go to https://creativecommons.org/licenses/by/4.0/ for full license details.

dir1 = '/Users/admin/Box Sync/Melanie and Brittney shared Box/Depth/Text files 100 -160';
D = dir(fullfile(dir1,'*.txt'));
file_num = length(D);

Data = zeros(512,512,file_num);
for i = 1:file_num
    Data(:,:,i) = readmatrix(D(i).name);
end
[Data_smooth] = smooth_SIMS(Data,3,3); %smooths the data witha  3x3 boxcar algorithm
%exclude file 521-530 since it has a ton of drift
Data_smooth(:,:,521:530)=[];
Data_w = Data_smooth.^(1.3); %raises each location in the matrix to the 1.3 power


%% Coarse Align 
[CalignData,Trans] = Coarse_align(Data,num)
%Data: Data that needs to be aligned due to drift
%num: number of files that should be shift at one time
          %max: The maximum distance that an image can move during alignment
%CalignData: Data course aligned
%Trans: Translations taken to align the data

%% Manual Align
[MalignData,Trans_m] = Manual_align(Data,first,last)
%Data: data that needs to be drift corrected manually
%first: First file that needs to be manually aligned (Cannot be 1)
%last: Last file that nees to be corrected

%% Fine Align
[FalignData,Trans] = Fine_align(Data,Max)
%Data: Data to be drift corrected
%Max: Maximum possible final move distance, decreasing this number should
%achieve a more precise alignment at the expenses of computational power
%and not moving as quickly. If you're not sure what willbe needed the
%standard distance should be set to 6.25.


%% ROI ALign
[RalignData,Trans] = ROI_align(Data)


