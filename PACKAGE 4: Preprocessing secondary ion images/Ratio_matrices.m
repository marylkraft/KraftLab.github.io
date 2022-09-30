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