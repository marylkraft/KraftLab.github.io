%% Crop out charging regions of SI Matrix
N14(:,:,521:530)=[]; %Crop planes 521-530 out because on that file there was a signal loss
N14(:,:,505) = N14(:,:,504); %Eliminate plane 505 and copy plane 504 into plane 504.
N14(:,:,506) = N14(:,:,507); %Eliminate plane 506 and copy plane 507 into plane 504.

N15(:,:,521:530)=[]; %Crop planes 521-530 out because on that file there was a signal loss
N15(:,:,505) = N15(:,:,504); %Eliminate plane 505 and copy plane 504 into plane 504.
N15(:,:,506) = N15(:,:,507); %Eliminate plane 506 and copy plane 507 into plane 504.

O16(:,:,521:530)=[]; %Crop planes 521-530 out because on that file there was a signal loss
O16(:,:,505) = O16(:,:,504); %Eliminate plane 505 and copy plane 504 into plane 504.
O16(:,:,506) = O16(:,:,507); %Eliminate plane 506 and copy plane 507 into plane 504.

O18(:,:,521:530)=[]; %Crop planes 521-530 out because on that file there was a signal loss
O18(:,:,505) = O18(:,:,504); %Eliminate plane 505 and copy plane 504 into plane 504.
O18(:,:,506) = O18(:,:,507); %Eliminate plane 506 and copy plane 507 into plane 504.

%% Align SI Matrixes
% Determine the translations using the alignment app
% Export the translations into file

%SE_align = alignment(SE_Matrix);
O16_a = alignment(O16); O18_a = alignment(O18);
N14_a = alignment(N14); N15_a = alignment(N15);

%% Smooth data usign a boxcar smooth algorithm (Moving average smoothing) 
% This function also imports the data from a selected folder into the
% workspace and smooths it
% Data is then saved to the open directory

%Format:
%S mooth = Pixel_Smoothing(Width,first_file_num,'name');
S_N15 = smooth3(N15_a,'box', [3 3 1]);
S_N14 = smooth3(N14_a,'box', [3 3 1]);

S_O18 = smooth3(O18_a, 'box', [3 3 1]);
S_O16 = smooth3(O16_a, 'box', [3 3 1]);

% S_N15 = Pixel_Smoothing(5);
% S_N14 = Pixel_Smoothing(5);
% 
% O18 = Pixel_Smoothing(5);
% O16 = Pixel_Smoothing(5);
%% Masking for enrichment images: 
%Masks (sets the value to NaN) the pixels that do not exceed a set percentage of the maximum

%Format:
% Masked = Masking_pixels(Data,masking_percentage,'name');

SM_N14 = Masking_Pixels(S_N14,4,'N14');
SM_O16 = Masking_Pixels(S_O16,5,'O16');

%% Ratioing & computing enrichment
%Computes the ratio value at each pixel (num/den) for secondary ions where
%the terrestrial abundance is known (oxygen, nitrogen) the enrichment can
%also be calculated by entering the elements abbreviation into 'element'
%(ie. N = Nitrogen, O = Oxygen)

%Format:
%[Ratio Enrichment] = Ratio_Matrices(numerator,denominator,'name','element');

[E_S_N15, R_S_N14] = Ratio_Matrices(S_N15,SM_N14,'N');
[E_S_O18, R_S_O18] = Ratio_Matrices(S_O18,SM_O16,'O');

%% DO NOT RUN Align matrices based on SE alignment data 
%Alignment of SIMS data was previously done with Secondary electron images.
%These (x,y) translations are applied to teh specified data.

%Format:
% Aligned = alignment(Data);

% A_S_N15 = alignment(E_S_N15);
% A_S_O18 = alignment(E_S_O18);

%% Z translation based  on SE contour map [OLD needs updating]
%Z translation of the data to fit the selected topography map

%Format:
% ZTranslated = Z_Translation(Data, Topography);

ZTrans_1 = Z_Translation(Ave_N15, Topography); % simple version (2D topography matrix)


