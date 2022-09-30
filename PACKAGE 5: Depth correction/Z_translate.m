% Copyright 2022 University of Illinois Board of Trustees. All Rights Reserved.
% These codes were authored by Melanie A. Brunet and Brittney L. Gorman under the supervision of Mary L. Kraft. 
% This file is part of KraftLab.github.io repository, which is released under specific terms.  
% See file License.txt file or go to https://creativecommons.org/licenses/by/4.0/ for full license details.

function ZTrans = Z_translate(M,depth,Topo,Multi)
%% Depth correction of ion images   
% written by Brittney Gorman
%    M: ion image to be depth corrected
%    depth: The depth of each plane in micronmeters or a conversion...
%    factor from units to planes
%    Multi: The multiplication factor to expand the data into more. This
%    increases the accuracy of the position of the voxels after depth
%    correction. (ie. original layer depth .0033 um, Multi = 2, the
%    accuracy of the depth corrected positions is .00167 um.
%    Topo: Topography matrix *must be the same size as the data set
    l=size(M,3);
    conv = 1/depth;  % converts height to matix number 
%    T is the topography matrix expanded times Multi (ie. Original number
%    of planes = 10. Multi = 2. 20 layers in the final depth corrected
%    matrix)
    T(:,:,1:Multi:l*Multi) = round(Topo*Multi*conv); 
    M(:,:,1:Multi:l*Multi) = M;
    
    [m,n,p]=size(M);
    
    [I,J,K]=ndgrid(1:m,1:n,1:p); % create the x,y,z positions for the ion matrix
    
    Knew = T+1; % Redefine the Z positions of adds a plane so that there is no zero
    P = max(Knew,[],'all');
    
    ZTrans_N = accumarray([I(:),J(:),Knew(:)],M(:),[],@max,-1);
    
    clear I J K Knew l m n p P 
% This section expands the voxels to fill the empty space using values in M(:) 
l = size(ZTrans_N,3);
ZTrans_new = ZTrans_N;

for i = 1:l
     A = ZTrans_new(:,:,i);
     if i < 50
         for k=1:(i-1)
            B = ZTrans_new(:,:,k);
            B(A >= 0 & B == -1)= A(A >= 0 & B == -1);
            ZTrans_new(:,:,k) = B; 
         end
     else
          for k=(i-49):(i-1)
            B = ZTrans_new(:,:,k);
            B(A >= 0 & B == -1)= A(A >= 0 & B == -1);
            ZTrans_new(:,:,k) = B; 
          end
     end
end
ZTrans_new(ZTrans_new < 0) = 0;
ZTrans = ZTrans_new; 
% Deletes any pixels that lie outside the range of the topography matrix
Low = T(:,:,size(T,3));
for i = 1:size(ZTrans,1)
    for j = 1:size(ZTrans,2)
        ZTrans(i,j,1:Low(i,j)) = 0;
    end
end
