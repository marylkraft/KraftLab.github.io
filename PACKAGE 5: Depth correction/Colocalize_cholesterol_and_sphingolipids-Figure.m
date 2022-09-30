
%% x,y colocal
figure;
for i=1:size(ZTrans_SN,3)

im = ZTrans_SN(:,:,i);
im_2 = ZTrans_SO(:,:,i);
im_2(im_2 == 0) = NaN;
ax=axes;
s1 = surf(ax,im,'edgecolor','none');
ax.View=[0 90]; ax.XLim=[0 size(im,2)]; ax.YLim=[0 size(im,1)]; colormap(ax,Enrichment); ax.CLim = [1 5];
axis off;

% I = getframe(gca);
% [indMov,cm] = rgb2ind(I.cdata,256);
% imwrite(I.cdata,cm,'z_N15','tif');


hold on;
ax2=axes;
s2 = surf(ax2,im_2,'edgecolor','none','FaceAlpha',.6);
ax2.View =[0 90]; ax2.XLim=[0 size(im,2)]; ax2.YLim=[0 size(im,1)];  colormap(ax2,greens);  ax2.CLim = [1 15];
axis off;

I = getframe(gca);
[indMov,cm] = rgb2ind(I.cdata,256);
imwrite(I.cdata,cm,num2str(i),'tif');

 hold off;
end


%% Combine matrices
N=ZTrans_SN;
N(N>5)=5;
O = ZTrans_SO;
O(O>15) = 15;
O(O>0) = O(O>0) + 6;

N_1 = N;
N_1(N<3.0)=0;
O_1 = O;
O_1(O_1<11)=0;
% C = zeros(size(N_1));
C = N_1 + O_1;
C(N_1==0 | O_1==0) = 0;

Com = N;
Com(Com < 1 & O>13) = O(Com < 1 & O>13); 
 
% Com(Com = 1 & O > 8) = O(Com = 1 1 & O > 8); 
Com(C>0) = C(C>0);



%% volume show
 figure;
Data = Com; % 3D data
t = 0; % Box thickness
dist = 30; % distance of box from the data cube
line =  [.7 .7 1]; % box color
Bground = [1 1 1];
scale=[4 4 1];%[5.27 5.27 1];
[x, y, z] = size(Data);
imbox= zeros(x+(dist*2),y+(dist*2),z+(dist*2))*(max(Data(:)));
t = round(t./scale);
imbox(t(1)+1:x+(dist*2)-t(1),:,t(3)+1:z+(dist*2)-t(3))=NaN;
imbox(:,t(2)+1:y+(dist*2)-t(2),t(3)+1:z+(dist*2)-t(3))=NaN;
imbox(t(1)+1:x+(dist*2)-t(1),t(2)+1:y+(dist*2)-t(2),:)=NaN;
imcube = imbox;
imcube(dist:x+(dist-1),dist:y+(dist-1),dist:z+(dist-1))=Data;
imcube(:,:,1:3) = max(Data(:));
Colormap = Three_7;
 Colormap = brighten(Colormap,.1);
Alpha = linspace(0,.09,57)'; %.15
Alpha(57:208) = linspace(0.05,0.20,152)'; %.08 uncorrected; .22 corrected
Alpha(209:256) = linspace(0,.1,48)'; %.1 uncorrected; .15 corrected
Alpha(1,1) = 0;
Alpha(256,1) = 1;

v = volshow(imcube,'Colormap',Colormap,'Lighting',false,'Alphamap',Alpha,'BackgroundColor',Bground,'ScaleFactors',scale);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
VAxis = [0, 26];
aAxis = [1, 26];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Generate new scale
newscale = linspace(min(imcube(:)) - min(VAxis(:)),...
    max(imcube(:)) - min(VAxis(:)), size(Colormap, 1))/diff(VAxis);
newscale(newscale < 0) = 0;
newscale(newscale > 1) = 1;

% newscale_a = linspace(min(imcube(:)) - min(VAxis(:)),...
%     max(imcube(:)) - min(VAxis(:)), (size(Colormap, 1))/4)/diff(aAxis);
% newscale_a(newscale_a < 0) = 0;
% newscale_a(newscale_a > 1) = 1;

% Update colormap in volshow
v.Colormap = interp1(linspace(0, 1, size(Colormap, 1)), Colormap, newscale);
v.Alphamap = interp1(linspace(0, 1, size(Alpha, 1)), Alpha(1:size(Alpha, 1)), newscale)';
% Alphamap = interp1(linspace(0, 1, size(Alpha, 1)/4), Alpha(1:size(Alpha, 1)/4), newscale_a)';
n = round(256/ max(imcube(:))*max(VAxis(:)));
v.Alphamap((n+1):255) = v.Alphamap(n);
v.Alphamap(250:256) = 1;
v.Colormap(256,:) = line;

%% 
% front-up view
vec = linspace(0,2*pi(),120)';
CameraUpVector = [0 0 1];
myPosition = [ 7.5*cos(vec) 7.5*sin(vec) 3.3*pi/3*ones(size(vec))];
v.CameraUpVector = CameraUpVector; v.CameraPosition = myPosition(120,:);


%%
%% volume show
 figure;
Data = (Com); % 3D data
t = 15; % Box thickness
dist = 4; % distance of box from the data cube
line =  [1 1 1]; % box color
Bground = [0 0 0];
scale=[5.27 5.27 1];%[5.27 5.27 1];
[x, y, z] = size(Data);
imbox= ones(x+(dist*2),y+(dist*2),z+(dist*2))*(max(Data(:)));
t = round(t./scale);
imbox(t(1)+1:x+(dist*2)-t(1),:,t(3)+1:z+(dist*2)-t(3))=NaN;
imbox(:,t(2)+1:y+(dist*2)-t(2),t(3)+1:z+(dist*2)-t(3))=NaN;
imbox(t(1)+1:x+(dist*2)-t(1),t(2)+1:y+(dist*2)-t(2),:)=NaN;
imcube = imbox;
D =  Data(:,98:101,:);
D(D>0) = (max(Data(:)));
Data(:,98:101,:) = D;
% D =  Data(295:297,:,:);
% D(D>0) = (max(Data(:)));
% Data(295:297,:,:) = D;
imcube(dist:x+(dist-1),dist:y+(dist-1),dist:z+(dist-1))=Data;
% imcube = permute(imcube,[1 3 2]);
% imcube(:,:,87:88) = ones(size(imcube,1), size(imcube,2),2)* (max(Data(:)));
% imcube = permute(imcube,[1 3 2]);
Colormap = Three_7;
% Colormap = brighten(Colormap,.1);
Alpha = linspace(0.01,.05,57)'; %.15
Alpha(57:208) = linspace(0.02,0.06,152)'; %.08 uncorrected; .22 corrected
Alpha(209:256) = linspace(0,.1,48)'; %.1 uncorrected; .15 corrected
Alpha(1,1) = 0;
Alpha(256,1) = 1;

v = volshow(imcube,'Colormap',Colormap,'Lighting',false,'Alphamap',Alpha,'BackgroundColor',Bground,'ScaleFactors',scale);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
VAxis = [0, 26];
aAxis = [1, 26];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Generate new scale
newscale = linspace(min(imcube(:)) - min(VAxis(:)),...
    max(imcube(:)) - min(VAxis(:)), size(Colormap, 1))/diff(VAxis);
newscale(newscale < 0) = 0;
newscale(newscale > 1) = 1;

% newscale_a = linspace(min(imcube(:)) - min(VAxis(:)),...
%     max(imcube(:)) - min(VAxis(:)), (size(Colormap, 1))/4)/diff(aAxis);
% newscale_a(newscale_a < 0) = 0;
% newscale_a(newscale_a > 1) = 1;

% Update colormap in volshow
v.Colormap = interp1(linspace(0, 1, size(Colormap, 1)), Colormap, newscale);
v.Alphamap = interp1(linspace(0, 1, size(Alpha, 1)), Alpha(1:size(Alpha, 1)), newscale)';
% Alphamap = interp1(linspace(0, 1, size(Alpha, 1)/4), Alpha(1:size(Alpha, 1)/4), newscale_a)';
n = round(256/ max(imcube(:))*max(VAxis(:)));
v.Alphamap((n+1):255) = v.Alphamap(n);
v.Alphamap(256) = 1;
v.Colormap(256,:) = line;
