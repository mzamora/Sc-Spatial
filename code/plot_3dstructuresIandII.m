
ii=5; gnrl.mylgd(ii)

%% type I updrafts
iobjs=find(obj_ud(ii).filters_UD(:,1));
maskUD=zeros(obj_ud(ii).ccUD.ImageSize(1),396,396);
for i=1:length(iobjs)
    iobj=iobjs(i);
    %transform 3x to 1x
    [iz,ix,iy]=pixels_3x_to_1x(obj_ud(ii).ccUD.PixelIdxList{iobj},obj_ud(ii).ccUD.ImageSize(1),396,396); % get 
    maskUD(sub2ind(size(maskUD),iz,ix,iy))=1;
end

% type II updrafts
iobjs=find(obj_ud(ii).filters_UD(:,2));
maskUD2=zeros(obj_ud(ii).ccUD.ImageSize(1),396,396);
for i=1:length(iobjs)
    iobj=iobjs(i);
    %transform 3x to 1x
    [iz,ix,iy]=pixels_3x_to_1x(obj_ud(ii).ccUD.PixelIdxList{iobj},obj_ud(ii).ccUD.ImageSize(1),396,396); % get 
    maskUD2(sub2ind(size(maskUD2),iz,ix,iy))=1;
end

% type I downdrafts
iobjs=find(obj_ud(ii).filters_DD(:,1));
maskDD=zeros(obj_ud(ii).ccDD.ImageSize(1),396,396);
for i=1:length(iobjs)
    iobj=iobjs(i);
    %transform 3x to 1x
    [iz,ix,iy]=pixels_3x_to_1x(obj_ud(ii).ccDD.PixelIdxList{iobj},obj_ud(ii).ccDD.ImageSize(1),396,396); % get 
    maskDD(sub2ind(size(maskDD),iz,ix,iy))=1;
end

% type II downdrafts
iobjs=find(obj_ud(ii).filters_DD(:,2));
maskDD2=zeros(obj_ud(ii).ccDD.ImageSize(1),396,396);
for i=1:length(iobjs)
    iobj=iobjs(i);
    %transform 3x to 1x
    [iz,ix,iy]=pixels_3x_to_1x(obj_ud(ii).ccDD.PixelIdxList{iobj},obj_ud(ii).ccDD.ImageSize(1),396,396); % get 
    maskDD2(sub2ind(size(maskDD2),iz,ix,iy))=1;
end

%%
zm=ps(ii).zm;
plot_isosurface(maskUD,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD,1)),'red'); hold on
plot_isosurface(maskUD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD2,1)),[.8 .4 0])
plot_isosurface(maskDD,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD,1)),'blue')
plot_isosurface(maskDD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD2,1)),[0 .4 .8])

%% instructions: sorry, this plot was done semi manually
%% run the above for 
subplot(121); ii=1; %run all above
subplot(121); ii=5; %run all above
%then complete the plot
subplot(121); daspect([1 1 500]); subplot(122); daspect([1 1 500])
subplot(121); view(60,45); subplot(122); view(60,45)
subplot(121); zticks([0 888]); zticklabels([0 1]); zlabel('$z/z_i$','Interpreter','latex')
subplot(122); zticks([0 898]); zticklabels([0 1]); zlabel('$z/z_i$','Interpreter','latex')
lgd=legend('$\rm UD^I$','$\rm UD^{II}$','$\rm DD^I$','$\rm DD^{II}$','Interpreter','latex');
lgd.Position=[0.8908 0.7619 0.0966 0.2010];
print('../figures/Fig_3Dobjects','-dpng','-r300')

%% cloud cores
ii=2
maskCloud=zeros(obj_ql(ii).cc.ImageSize(1),396,396);
for iobj=1:obj_ql(ii).cc.NumObjects
    %transform 3x to 1x
    [iz,ix,iy]=pixels_3x_to_1x(obj_ql(ii).cc.PixelIdxList{iobj},obj_ql(ii).cc.ImageSize(1),396,396); % get 
    maskCloud(sub2ind(size(maskCloud),iz,ix,iy))=1;
end

figure
subplot(212); plot_isosurface(ql,0,xm/1e3,ym/1e3,zm,[.7 .7 .7])
casename=base(ii).name; filename=[casename(1:end-4),'hr3_4/'];
load([filename,'rf01_ql',num2str(time,'%02i')])
subplot(211); plot_isosurface(maskCloud,0.5,xm/1e3,ym/1e3,zm,[.6 .6 .6])

%% cloud cores qlw
ii=1
maskCloud=zeros(obj_qlw(ii).cc.ImageSize(1),396,396);
for iobj=1:obj_qlw(ii).cc.NumObjects
    %transform 3x to 1x
    [iz,ix,iy]=pixels_3x_to_1x(obj_qlw(ii).cc.PixelIdxList{iobj},obj_qlw(ii).cc.ImageSize(1),396,396); % get 
    maskCloud(sub2ind(size(maskCloud),iz,ix,iy))=1;
end

figure
subplot(212); plot_isosurface(ql,0,xm/1e3,ym/1e3,zm,[.7 .7 .7])
casename=base(ii).name; filename=[casename(1:end-4),'hr3_4/'];
load([filename,'rf01_ql',num2str(time,'%02i')])
subplot(211); plot_isosurface(maskCloud,0.5,xm/1e3,ym/1e3,zm,[.6 .6 .6])


%%

%     bool=;
    varp=permute(bool,[2 3 1]);
    p = patch(isosurface(xm,ym,zm,varp,0.5));

    isonormals(xm,ym,zm,varp,p)
    p.FaceColor = 'yellow';
    p.EdgeColor = 'none';
    daspect([1 1 300])
    view(20,45)
    axis tight
    camlight
    lighting gouraud   
    xlabel('x [km]'); ylabel('y [km]'); zlabel('Height [m]')