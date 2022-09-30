%% Defining important variables used in the morphology reconstruction
%---SIMS 1---- (uncomment when using SIMS data)------------------------------
file_num = size(D_add_2,3); %change this if the data is not masked
for i =1:file_num %Normalizing each plane
file(:,:,i) = D_add_2(:,:,i)/max(D_add_2(:,:,i),[],'all');
end
depth = 0.0037; %amount of material removed per plane %0.01 (FIB) 0.0033(SIMS)
height_bottom = 2; %height of the bottom layer (0.03 um)
times = 1.5;
bs = 51; %this means pyramid bottom layer smoothing (bs = bottom smoothing)
C = 0.003; %.004 SIMS %0.08 FIB%This is the weight the pyramid will have (how much similar to the pyramid will the morphology be)
d = C; %this variable is used in the next section

%%---FIB 6---- (uncomment when using FIB data)------------------------------
% file_num = size(M_FIB,3); %Normalizing each plane
% for i =1:file_num
% file(:,:,i) = M_FIB(:,:,i)/max(M_FIB(:,:,i),[],'all'); %This works for the FIB data
% end
% depth = 0.0098; %amount of material removed per plane %0.01
% height_bottom = 0.1; %height of the bottom layer (0.03 um)
% times = 2;
% bs =25; %51_6,81_7 %this means pyramid bottom layer smoothing (bs = bottom smoothing)
% C = 0.04; %.004 SIMS %0.08 FIB%This is the weight the pyramid will have (how much similar to the pyramid will the morphology be)
% d = C; %this variable is used in the next section

% %%---FIB 7---- (uncomment when using FIB data)------------------------------
% file_num = size(M_FIB,3); %Normalizing each plane
% for i =1:file_num
% file(:,:,i) = M_FIB(:,:,i)/max(M_FIB(:,:,i),[],'all'); %This works for the FIB data
% end
% depth = 0.0098; %amount of material removed per plane %0.01
% height_bottom = 0.4; %height of the bottom layer (0.03 um)
% times = 1.5;
% bs =81; %51_6,81_7 %this means pyramid bottom layer smoothing (bs = bottom smoothing)
% C = 0.04; %.004 SIMS %0.08 FIB%This is the weight the pyramid will have (how much similar to the pyramid will the morphology be)
% d = C; %this variable is used in the next section
%---------------------------------------------------------------------------
%% Morphology Reconstruction: Step Pyramid and Base

dimx=size(file,1);
dimy=size(file,2);

val = 0.0691*depth; %0.00023/0.00333=0.0691 (dont change)
weight = height_bottom/depth; % don't change. The weight is how many times greater that layer is compared to the rest (dont change)

% %Make mask (Convert Secondary electron image to cell (1)/ not cell (0))
N = file;
N(N>0)=1;
N(N<0)=0;

%For the bottom layer only (smoothing bottom layer to create base with no texture)
% bot = Pixel_Smoothing(file(:,:,file_num),bs); %This value (bs) will vary from set to set
bot_1(:,:,1) = file(:,:,file_num-1);
bot_1(:,:,2) = file(:,:,file_num);
bot = smooth3(bot_1,'box', [bs bs 1]);

%Add the botom layer to the mask 3D matrix
N(:,:,file_num) = bot(:,:,2); %bot means bottom layer

%This part is to give the last layer a different weight
A = N(:,:,file_num);
Maxx = max(A,[],'all');
c = weight/Maxx;
bot_2 = bot(:,:,2)*c; %giving the bottom layer a different weight (1/frac=0.01 and 2/frac=0.02). Making the maximum equal to weight
N(:,:,file_num) = bot_2;

file_flip = flip(file,3);
N_flip = flip(N,3); % I flip this so that I can begin constructing the pyramid from bottom to top (just thew pyramid)

% --------------------------------------------------------------------------------------------------------------------------%%
%Loop to create the whole pyramid (it's easier to already have the pyramid created for the morphology reconstruction)
for i = 1:file_num
    cur(:,:,i) = N_flip(:,:,i); % I begin the pyramid construction in the last file (single block)
    Sum_flip(:,:,i) = sum(cur,3); %Sum the z dimension (This creates the pyramid for each loop)
end
Sum = flip(Sum_flip,3);
%Sum = smooth3(Sum,'box',[9 9 1]); %smooth the pyramid - for the GUI we can give the use this option. If they don't want to do it they don't need to.
clearvars cur

% Does the cell portion of the Sum matrix have holes? If yes, uncomment below.
%COMMENT BELOW IF NOT NEEDED
% Use if the Sum matrix has holes in the cell area (if not leave these lines commented)
% Sum2 = Sum;
% clearvars Sum
% for i = 1:file_num
%     Sum(:,:,i) = imfill(Sum2(:,:,i),'holes'); % I begin the pyramid construction in the last file (single block)
% end

clearvars A bot bot_1 bot_2 bs
%% Morphology Reconstruction: Capping, Overlap Correction, Scaling
%In this next part I will just need to cap each pyramid plane with its corresponding SE image plane

for i = 1:file_num %loops through planes file_num-1 (bottom to top)
    i
    %In this part I will just need to cap each pyramid plane with its corresponding SE image plane
    if i == 1 % I needed to add this part in order for the line Mbelow = M3(:,:,i-1); to work (in the else portion)
     
        %C = 0.08; %C is defined in the previous section
        K = 1 - C; %weighting of the Pixel Intensity
        
        c(i) = C;
        k(i) = K;
        
        Data(:,:,i) = file(:,:,i); %Defining a new variable Data
        M4 = (Sum(:,:,i)*C) + Data(:,:,i)*K; %This is the capping step.
        M3(:,:,i) = M4;
        M4_check(:,:,i) = M4;

    else
        %-----------
        %d = 0.08; %defined in the previous section %d is just C % I had to define a new variable because C was changing with each loop.

        b = (d*times - d)/(file_num-1); %In here, as we move to the bottom, the weighting of the pyramid increases by the amount "times" (ej double, or triple) (same as saying the weighting of the PI decreases). 
        %The -1 is because I am not counting the first plane in the if portion. I am doing this calculation for the planes remaining
        %This step calculates the amount that C will get added to achieve
        %the value calculated in times (ej: C=0.08, times=2, finalC = 0.16, b is the step increase to get to 0.16)
        
        C = C + b; %C increases because the PI decreases as qwe move down (same as increasing PI as we move up) % Pyramid Contribution %0.003 for SIMS (uncomment for more weight on the bottom)
        K = 1 - C; %PI contribution decreases as we move down(increases as we move up)
        c(i) = C; %this is just saving the C in each loop in this variable
        k(i) = K;
        %-----------
        %Now we should be interested in Mabove instead of Mbelow
        Mabove = M3(:,:,i-1); %I had to leave the if 1==1 part for this line to work. If not, M3 would not be defined.
        Data(:,:,i) = file(:,:,i); %Defining a new variable Data
        
        M4 = (Sum(:,:,i)*C) + Data(:,:,i)*K; %This is the capping step.
        M4_check(:,:,i) = M4;
     
        Delta(:,:,i) = M3(:,:,(i-1)) - M4; %M4 is the current layer, M3 variable is the above layer. This solved the negative part
        
        mean_delta = nanmean(Delta(:,:,i),'all'); %Calculate the average of the Delta pixel intensity.
        M4(isnan(M4)) = 0;
        Delta(isnan(Delta)) = 0;
        diff = (mean_delta - Delta(:,:,i)); %Calculate the difference between the average of the Delta pixel intensity anf the Delta pixel intensity.
        max_diff = max(diff,[],'all'); %Calculate the maximum value of the diff matrix.
        
        Delta_i = Delta(:,:,i); %Delta matrix corresponfding to this loop.
        M3_i = M3(:,:,(i-1)); % Layer above (now) [was layer below in old code]
        
        Delta_i(Delta_i > 0) = (depth/100)*abs(diff(Delta_i>0)/max_diff); %If a value on the Delta pixel intensity matrix is >0 (positive) add values in the range of 3-6nm.
        
        x = zeros(dimx,dimy); %setting dimensions for x.
        x(Delta_i < 0) = (depth/100) - (val)*abs(diff(Delta_i < 0)/max_diff); %If a value on the Delta pixel intensity matrix is <0 (negative) it will be changed to a value in the range of 0-3nm.
        Abs(:,:,i) = abs(Delta_i);%Take the absolute value of the Delta pixel intensity matrix.

        M2 = M4 - (Abs(:,:,i) + x); 
        
        %For verification purposes
        %Mean2(i) = nanmean(M2(Mbelow>0),'all'); %Mean calculation of this matrix
        Mean2(i) = nanmean(M2(Mabove>0),'all'); %Mean calculation of this matrix
        Stdev(i) = nanstd(M2,0,'all');%Standard deviation calculation
        MeanSub(i) = Mean2(i)-Mean2(i-1); %This is supposed to be 0.00333, let's see
        
        M2(isnan(M2)) = 0; %Convert NaN values back to zero
        M3(:,:,i) = M2; % Add the plane Log10_2 to the 3D matrix.

    end
end

M5 = M3;
Topo1 = smooth3(M5,'box',[3 3 1]);
Sum_flip = flip(Sum,3);
% Topo2= (Topo1/max(Topo1(:)))*(depth*file_num+height_bottom); % Weight the Final topography to the cell height 
z1 = height_bottom/ max(Topo1(:,:,file_num),[],'all'); %normalized height of the bottom layer (5.2/5.0)
z2 = ((depth*file_num)+height_bottom)/ max(Topo1(:,:,1),[],'all'); %normalized bottom layer (y intercept) bottom height (2.0 MDCK)
m = (z1-z2)/(file_num); %write down what this value is. (slope)
for i=1:file_num
Topo2(:,:,i)= Topo1(:,:,i)*(m*(i-1)+z2);
end

Topo2(Topo2<0)=0; % There is like a "shadow" of the material that was sputtered (see in layers below), those numbers are going to small (-) values, this line fixes it. The negative numbers are NOT in the cell part, they are in the substrate.

% Note: Topo2 is your final morphology reconstruction matrix.

clearvars N o p Data cur frac M5
clearvars Aa Aflip M1 Mean Mean2 M3 Mcurrent Mbelow diff max_diff x M2 M3_i M5 iter