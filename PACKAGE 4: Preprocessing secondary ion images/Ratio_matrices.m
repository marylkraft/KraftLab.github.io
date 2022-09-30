% Copyright 2022 University of Illinois Board of Trustees. All Rights Reserved.
% These codes were authored by Melanie A. Brunet and Brittney L. Gorman under the supervision of Mary L. Kraft. 
% This file is part of KraftLab.github.io repository, which is released under specific terms.  
% See file License.txt file or go to https://creativecommons.org/licenses/by/4.0/ for full license details.

function [Enrichment, Ratio] = Ratio_Matrices(num,den,Type,varargin)
%Written by Brittney Gorman
%num: numerator matirx
%den: denominator matrix
%nargin: name of the numerator or ratio matrix
%Type: element being ratioed oxygen = 'O' nitrogen = 'N' 

%This program calculates the Ratio of 18-O/16-O counts for each image file.
% 

L = length(num(1,1,:));
Ratio = zeros(512,512,L);

        if Type == 'N'
            Terrestrial = 0.00367;
        elseif Type == 'O'
                Terrestrial = 0.002005;
        else
                Terrestrial = Type;
        end
        
        Ratio = (num./den); %Divides both matrices and multiplies the Resulting Matrix by the scaling factor from ImageJ 10,000
        Ratio(isinf(Ratio)|isnan(Ratio)) = 0;%Corrects the errors produced by dividing 0/0 and num/0.
        Enrichment = Ratio./Terrestrial;

end
