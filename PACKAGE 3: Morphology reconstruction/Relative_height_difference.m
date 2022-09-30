%% Subtraction (instead of % difference) [FIB6]

%Use the masked AFM data here
Conv = M_AFM_FIB6/max(M_AFM_FIB6,[],'all'); Conv(Conv==0)=NaN; % This will make sure that the substrate region will remain ignored during the subtraction

%Uncomment for uncorrected block comparison to AFM)
%----Sum Section (this is the block, uncorrected data)-------
% Sum = Sum2_FIB6(:,:,1)/max(Sum2_FIB6(:,:,1),[],'all'); %Normalizing
% subtract2 = abs(Conv - Sum); %Subtracting the AFM - Sum and calculating the absolute value.
% avg_h_difference_6_block = nanmean(subtract2,'all');
% stdev_6_block = nanstd(subtract2,0,'all');
% figure; imagesc(subtract2); colormap(jet);
% set(gca,'XTick',[], 'YTick', [], 'ZTick', []);
% caxis([0 1])
% colorbar('XTick',[0 0.2 0.4 0.6 0.8 1], 'YTick', [0 0.2 0.4 0.6 0.8 1])
% 
% g = gcf;
% exportgraphics(g,'FIB6_Subtracting_Abs_AFM-Sum.tiff','Resolution',300)

%Uncomment for Morphology comparison to AFM)
%----Topo Section (AFM vs Topo)-------
Topo = Topo2_FIB6(:,:,1)/max(Topo2_FIB6(:,:,1),[],'all'); %Normalizing
subtract2 = abs( Conv - Topo); %Subtracting the AFM - Topo and calculating the absolute value.
avg_h_difference_6 = nanmean(subtract2,'all');
stdev_6 = nanstd(subtract2,0,'all');
figure; imagesc(subtract2); colormap(jet);
set(gca,'XTick',[], 'YTick', [], 'ZTick', []);
colorbar('XTick',[0 0.25 0.5 0.75 1], 'YTick', [0 0.25 0.5 0.75 1])
caxis([0 1])

% g = gcf;
% exportgraphics(g,'FIB6_Subtracting_Abs_AFM-Topo.tiff','Resolution',300)

%% Subtracting (instead of % difference) [FIB7]

%Use the masked AFM data here
Conv = M_AFM_FIB7/max(M_AFM_FIB7,[],'all'); Conv(Conv==0)=NaN;

%Uncomment for uncorrected block comparison to AFM)
%----Sum Section-------
% Sum = Sum2_FIB7(:,:,1)/max(Sum2_FIB7(:,:,1),[],'all');
% subtract2 = abs(Conv - Sum);
% avg_h_difference_7_block = nanmean(subtract2,'all');
% stdev_7_block = nanstd(subtract2,0,'all');
% figure; imagesc(subtract2); colormap(jet);
% set(gca,'XTick',[], 'YTick', [], 'ZTick', []);
% caxis([0 1])
% colorbar('XTick',[0 0.2 0.4 0.6 0.8 1], 'YTick', [0 0.2 0.4 0.6 0.8 1])
% 
% g = gcf;
% exportgraphics(g,'FIB7_Subtracting_Abs_AFM-Sum.tiff','Resolution',300)

%Uncomment for Morphology comparison to AFM)
%----Topo Section-------
Topo = Topo2_FIB7(:,:,1)/max(Topo2_FIB7(:,:,1),[],'all');
subtract2 = abs( Conv - Topo);
avg_h_difference_7 = nanmean(subtract2,'all');
stdev_7 = nanstd(subtract2,0,'all');
figure; imagesc(subtract2); colormap(jet);
set(gca,'XTick',[], 'YTick', [], 'ZTick', []);
colorbar('XTick',[0 0.25 0.5 0.75 1], 'YTick', [0 0.25 0.5 0.75 1])
caxis([0 1])

% g = gcf;
% exportgraphics(g,'FIB7_Subtracting_Abs_AFM-Topo.tiff','Resolution',300)