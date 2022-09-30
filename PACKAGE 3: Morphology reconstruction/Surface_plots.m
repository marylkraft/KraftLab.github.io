% This code is for the surface plots and top-down images in the paper
%% FIB 7 (surface plot) - For paper

file = Topo2_FIB7; %FIB Morphology file
% file = Topography_FIB7;
dimx = size(file,1);
dimy = size(file,2);
o = 1;
figure; 
surf(file(:,:,o),'edgecolor','none');set(gca,'ydir','reverse');
view([0 70])
%view([0 90]) %top view
colormap(red_2)
%colormap(red_3)
%colormap(grayblue_1)
g=lightangle (0,60);
g.Color = [.8 .8 .8];
material dull
%axis([1 512 1 512 -1e-6 2e-6])
axis([0 dimy 0 dimx 0 1.5]);
axis on
l = lightangle (-120, 50);
l.Color = [.5 .5 .5];
set(gca,'XTick',[], 'YTick', [], 'ZTick', []);
set(gca,'Color','none');

% caxis([0 1.25])
caxis([0 max(file(:))]) %1.25
% 
% colorbar('Ticks',[0 0.3 0.6 0.9 1.2])
%colorbar('southoutside','Ticks',[0,0.5,1,1.5,2,2.5,3])

%xticks(0:100:dimy);
%yticks(0:50:466); % Whatever....
% 
% g = gcf;
% exportgraphics(g,'DSR_Topo_100.tiff','Resolution',300)
%% MDCK Paper 1

%file = Topo2/max(Topo2(:,:,:),[],'all');
file = Topo2_MDCK; %SIMS morphology file
% file = Topography_MDCK;
dimx = size(file,1);
dimy = size(file,2);

o =600;
figure; 
surf(file(:,:,o),'edgecolor','none');set(gca,'ydir','normal');
% view([90 75])
view([80 60])
% view([90 90])
colormap(red_2)
lightangle (0,75)
material dull
%axis([1 512 1 512 -1e-6 2e-6])
axis([0 dimy 0 dimx 0 6]);
% axis([0 dimy 0 dimx 0 1.5]);
axis on
l = lightangle ( 130, 80);
l.Color = [.5 .5 .5];
% set(gca,'XTick',[0 400], 'YTick', [0 450], 'ZTick', [0 3.5]);
set(gca,'XTick',[], 'YTick', [], 'ZTick', []);
set(gca,'Color','none');

% colorbar('Ticks',[0 1 2 3 4])
%colorbar('southoutside','Ticks',[0,0.5,1,1.5,2,2.5,3])

% caxis([0 3.6])
caxis([0 max(file,[],'all')])
% 
% g = gcf;
% exportgraphics(g,'DSR_MDCK_600.tiff','Resolution',300)

%% CSR topo
% smooth
% Topography1 = smooth3(Topography,'box', [3 3 1]);
% AS = smooth3(A,'box', [3 3 1]);
%D_add_2_ = smooth3(D_add_2,'box', [3 3 1]);

%file = Topography1;
file = Topo2/max(Topo2,[],'all');
%file = D_add_2_/max(D_add_2_,[],'all');
%file = AS/max(AS,[],'all');
%file = Sum(:,:,file_num)/dec;
dimx = size(file,1);
dimy = size(file,2);

o =600;
figure; 
surf(file(:,:,o),'edgecolor','none');set(gca,'ydir','normal');
% view([90 75])
view([80 60])
% view([90 90])
colormap(copper_3)
lightangle (0,75)
material dull
%axis([1 512 1 512 -1e-6 2e-6])
% axis([0 dimy 0 dimx 0 6]);
axis([0 dimy 0 dimx 0 2]);
axis on
l = lightangle ( 130, 80);
l.Color = [.5 .5 .5];
%set(gca,'XTick',[0 400], 'YTick', [0 450], 'ZTick', [0 3.5]);
set(gca,'XTick',[], 'YTick', [], 'ZTick', []);
set(gca,'Color','none');

% colorbar('Ticks',[])
%colorbar('southoutside','Ticks',[0,0.5,1,1.5,2,2.5,3])

% caxis([0 3.6])
caxis([0 1])


% g = gcf;
% % exportgraphics(g,'MDCK_FirstMethod_600.tiff','Resolution',300)

%% SURFACE PLOT

o =600;

dimx = size(M_FIB,1);
dimy = size(M_FIB,2);

%figure; surf(log(ver(:,:,o)+1),'edgecolor','none'); set(gca,'ydir','normal');
figure; surf(M_FIB(:,:,o),'edgecolor','none'); set(gca,'ydir','normal');
%view([90 70]);
%view([0 65]); %for FIB7 & z axis 0 2
view([90 90]); %for MDCK paper 1
%view([90 90]);
%axis([0 dimy 0 dimx 0 2]); %For FIB 7
axis([0 dimy 0 dimx 0 200000]); %For FIB 7
set(gca,'XTick',[], 'YTick', [], 'ZTick', []);
%set(gca,'visible','off')
set(gca,'Color','black'); colormap(gray_2)

caxis([0 max(M_FIB(:,:,600),[],'all')]) %the max is 64154 for FIB 7

% colorbar('Ticks',[0 15 30 45])
%colorbar('Ticks',[])
% lightangle(45,60)
% material shiny

% g = gcf;
% exportgraphics(g,'Colorbar_NoNumbers.tiff','Resolution',300)

% figure; surf(M_AFM,'edgecolor','none'); set(gca,'ydir','normal');
% view([90 60]);
% %view([-90 48]);
% axis([0 dimy 0 dimx 0 1.5]);
% %set(gca,'XTick',[], 'YTick', [], 'ZTick', []);
% %set(gca,'visible','off')
% set(gca,'Color','white'); colormap(parula)
% % 
% g = gcf;
% exportgraphics(g,'Fib_7_1.tiff','Resolution',300)