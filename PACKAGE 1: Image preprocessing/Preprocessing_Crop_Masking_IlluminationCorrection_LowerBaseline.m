%% This is the code that was used to make the morphology for the DSR paper

%% Crop SIMS Data
% Crop Data (MDCK) to 600 planes (instead of 610) (Used for our data MDCK)

%A = A(55:504,64:463,:); %Crops so that only the regions in common are present.
A(:,:,521:530)=[]; %Crop planes 521-530 out because on that file there was a signal loss
A(:,:,505) = A(:,:,504); %Eliminate plane 505 and copy plane 504 into plane 504.
A(:,:,506) = A(:,:,507); %Eliminate plane 506 and copy plane 507 into plane 504.
A(:,:,561) = A(:,:,560); %Eliminate plane 561 and copy plane 560 into plane 561. Newest modification
A = A(55:504,64:463,:);

%% Crop FIB data
% Crop Masked FIB data to common areas (FIB DATA 6) [(30:510,:,:)]
%-----FIB6--------
M_FIB_= M_FIB; %renaming the variable
M_FIB = M_FIB_(30:510,:,:); %FIB data #6 croped
M_FIB(:,1:6,:)=[];

%-----FIB7--------
M_FIB_= M_FIB; %renaming the variable
M_FIB = M_FIB_(15:510,:,:); %FIB data #7 croped
M_FIB(:,751:768,:)=[];

%% SI Mask Creation for NanoSIMS data (used in paper)
A = N14;
B = O16;

A(A <= 0.05 * max(A,[],'all'))=0; %Threshold for N14
B(B <= 0.05 * max(B,[],'all'))=0; %Threshold for O16

a = A+B; %Sum

C = Pixel_Smoothing(a,3); %using our function to do a 3 x 3 smoothing
C(C>0)=1;

%Fix the regions that have "holes"
c = imfill(C,8,'holes'); %Fill in the 0 with 1 in the cell area
c1 = imcomplement(c); % Invert mask
c2 = imfill(c1,8,'holes'); % Fill the 
SIMask = imcomplement(c2);
%% Masking the SE images (used in paper)

%Mask the SE images
for i = 1:file_num
    M_SE = SE(:,:,i)*SIMask(:,:,i);
end

%% Lower baseline (used in SIMS and FIB data)

Data = M_FIB; %change this when using SIMS data (M_SE)
file_num = size(Data,3);

%AA = M_SE/max(M_SE,[],'all');
AA = Data/max(Data,[],'all');
for i = 1:file_num
    
    D = AA(:,:,i);
    ad = D;  
    ad(ad == 0) = NaN;
    Max = max(ad,[],'all');
    add = imadjust(ad,[.0055 Max],[0.0001 Max]); %[0.001 Max] [0 Max] %0,1 0,1 %The higher the value, the lower the cliff (0.001)  % decreases the contrast of the lower range so there is no gap between zero and the lowest value
    add(isnan(ad)) = 0;
    D_add_2(:,:,i) = add;
end
clearvars D AA  Max add step1 add_ad Data ad
%% Illumination Correction
Data = M_SE; %change this when using SIMS data (M_SE)
file_num = size(Data,3);

%AA = M_SE/max(M_SE,[],'all');
AA = Data/max(Data,[],'all');
for i = 1:file_num
    
    D = AA(:,:,i);
    ad = D;  
    ad(ad == 0) = NaN;
    Max = max(ad,[],'all');
    add = imadjust(ad,[.0055 Max],[0.0001 Max]); %[0.001 Max] [0 Max] %0,1 0,1 %The higher the value, the lower the cliff (0.001)  % decreases the contrast of the lower range so there is no gap between zero and the lowest value
    add(isnan(ad)) = 0;
    step1(:,:,i) = add;
end
 
for i = 1:file_num
    add = step1(:,:,i);
    Max = max(step1(:,:,1),[],'all');
    add_ad = imadjust(add,[.4*Max 1],[.4*Max .25]); % decreases contrast in the upper 50% by 1/2th. We might need to decrease it by more than half
    add(add>=.4*Max) = 0;
   % add1(:,:,i)= add;
    add_ad(add_ad == .4*Max) = 0;
    D_add_2(:,:,i) = add_ad+add;   % creates a 3D gamma filtered matrix
    
end

clearvars D AA  Max add step1 add_ad Data ad
