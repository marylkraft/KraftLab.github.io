% Enrichment images [Volumes, crosssections]
%% volume show
 figure;
Data = flip(Saturated_FAs2,3); % 3D data
t = 8; % Box thickness
dist = 4; % distance of box from the data cube
line =  [1 .9 .2]; % box color
Bground = [0 0 0];
scale=[6 6 4];
[x, y, z] = size(Data);
imbox= ones(x+(dist*2),y+(dist*2),z+(dist*2))*(max(Data(:)));
t = round(t./scale);
imbox(t(1)+1:x+(dist*2)-t(1),:,t(3)+1:z+(dist*2)-t(3))=NaN;
imbox(:,t(2)+1:y+(dist*2)-t(2),t(3)+1:z+(dist*2)-t(3))=NaN;
imbox(t(1)+1:x+(dist*2)-t(1),t(2)+1:y+(dist*2)-t(2),:)=NaN;
imcube = imbox;
imcube(dist:x+(dist-1),dist:y+(dist-1),dist:z+(dist-1))=Data;
Colormap =Enrichment;
Alpha = linspace(0,.25,256)';
Alpha(1,1) = 0;
Alpha(256,1) = 1;

v = volshow(imcube,'Colormap',Colormap,'Lighting',false,'Alphamap',Alpha,'BackgroundColor',Bground,'ScaleFactors',scale);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Colormap limits
VAxis = [1, 3];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Generate new scale
newscale = linspace(min(imcube(:)) - min(VAxis(:)),...
    max(imcube(:)) - min(VAxis(:)), size(Colormap, 1))/diff(VAxis);
newscale(newscale < 0) = 0;
newscale(newscale > 1) = 1;

% Update colormap in volshow
v.Colormap = interp1(linspace(0, 1, size(Colormap, 1)), Colormap, newscale);
v.Alphamap = interp1(linspace(0, 1, size(Alpha, 1)), Alpha(1:size(Alpha, 1)), newscale)';
n = round(256/ max(imcube(:))*max(VAxis(:)));
v.Alphamap((n+1):255) = v.Alphamap(n);
v.Alphamap(256) = 1;
v.Colormap(256,:) = line;

%% 
% front view
vec = linspace(0,2*pi(),120)';
CameraUpVector = [0 0 1];
myPosition = [ 6.5*cos(vec) 6.5*sin(vec) 1.5*pi/3*ones(size(vec))];
v.CameraUpVector = CameraUpVector; v.CameraPosition = myPosition(115,:);
%% 
% front-upward view
vec = linspace(0,2*pi(),121)';
CameraUpVector = [0 0 1];
myPosition = [ 25.5*cos(vec) 25.5*sin(vec) 9.6*pi/3*ones(size(vec))];
v.CameraUpVector = CameraUpVector; v.CameraPosition = myPosition(61,:);

%% z,y cross section colocal
% Insert planes to be colocalized
Data1 =; 
Data2 =;
i=; % insert plane number
figure('Position',[4,120,780,377]);
im = permute(Data1(i,:,:),[2,3,1]);
im_2 = permute(Data2(i,:,:),[2,3,1]);
im_2(im_2 == 0) = NaN;
ax=axes;
s1 = surf(ax,im,'edgecolor','none');
ax.View=[90 -90]; ax.XLim=[0 size(im_2,2)]; ax.YLim=[0 size(im_2,1)]; colormap(ax,Enrichment); ax.CLim = [0 3];
axis off;

%% 

hold on;
ax2=axes;
s2 = surf(ax2,im_2,'edgecolor','none','FaceAlpha',.6);
ax2.View =[90 -90]; ax2.XLim=[0 size(im_2,2)]; ax2.YLim=[0 size(im_2,1)];  colormap(ax2,greens);  ax2.CLim = [1 15];
axis off;

%%
ax2=axes;
im_2 = permute(Data2(i,:,:),[2,3,1]);
s2 = surf(ax2,im_2,'edgecolor','none');
ax2.View =[90 -90]; ax2.XLim=[0 size(im_2,2)]; ax2.YLim=[0 size(im_2,1)];  colormap(ax2,greens);  ax2.CLim = [3 15];
axis off;

%% x,y colocalization 
% Insert planes to be colocalized
Data1 =; 
Data2 =;
i=; % insert plane number
% Image of first data set 
figure; 
im = Data1(:,:,i);
im_2 = Data2(:,:,i);
im_2(im_2 == 0) = NaN;
ax=axes;
s1 = surf(ax,im,'edgecolor','none');
% Image size parameters
ax.View=[0 90]; ax.XLim=[0 400]; ax.YLim=[0 450]; colormap(ax,Enrichment); ax.CLim = [1 5];
axis off;

%% Image of second data set overlaid
hold on;
ax2=axes;
s2 = surf(ax2,im_2,'edgecolor','none','FaceAlpha',.5);
ax2.View =[0 90]; ax2.XLim=[0 400]; ax2.YLim=[0 450];  colormap(ax2,greens);  ax2.CLim = [1 15];
axis off;

%% Image of second data set
ax2=axes;
im_2 = Data2(:,:,i);
s2 = surf(ax2,im_2,'edgecolor','none');
ax2.View =[0 90]; ax2.XLim=[0 400]; ax2.YLim=[0 450];  colormap(ax2,greens);  ax2.CLim = [1 15];
axis off;

%% Save tiffs
I = getframe(gca);
[indMov,cm] = rgb2ind(I.cdata,256);
imwrite(I.cdata,cm,'Name','tif');