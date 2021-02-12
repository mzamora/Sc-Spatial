iis=[7,11]; %[7,11]; %[1,5]; %
for ii=iis %[7,11] %[1,5]
    gnrl.mylgd(ii)

%% type I updrafts
zm=ps(ii).zm;
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

%% new plot
switch ii
    case 1 %CTRL
        sp3=subplot(233);
        plot_isosurface(maskUD,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD,1)),'red'); hold on
        plot_isosurface(maskUD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD2,1)),[.8 .4 0])
        plot_isosurface(maskDD,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD,1)),'blue')
        plot_isosurface(maskDD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD2,1)),[0 .4 .8])
        sp1=subplot(231);
        plot_isosurface(maskUD,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD,1)),'red'); hold on
        plot_isosurface(maskUD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD2,1)),[.8 .4 0])
        %xlim([-7 -3]); ylim([-5 -.7]); view(110,20); box on
        xlim([-6 -3]); ylim([-5 -2]); view(110,20); box on
        sp2=subplot(232);
        plot_isosurface(maskDD,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD,1)),'blue')
        plot_isosurface(maskDD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD2,1)),[0 .4 .8])
        %xlim([0 3]); ylim([-2.5 2]); view(110,20); box on
        xlim([4 7]); ylim([3 6]); view(110,20); box on
    case 5 %000U
        sp6=subplot(236);
        plot_isosurface(maskUD,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD,1)),'red'); hold on
        plot_isosurface(maskUD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD2,1)),[.8 .4 0])
        plot_isosurface(maskDD,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD,1)),'blue')
        plot_isosurface(maskDD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD2,1)),[0 .4 .8])
        sp4=subplot(234);
        plot_isosurface(maskUD,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD,1)),'red'); hold on
        plot_isosurface(maskUD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD2,1)),[.8 .4 0])
%         xlim([-6 -2.6]); ylim([3.6 6]); view(30,20); box on
        xlim([-4 -.6]); ylim([1 4]); view(110,20); box on
        sp5=subplot(235);
        plot_isosurface(maskDD,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD,1)),'blue')
        plot_isosurface(maskDD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD2,1)),[0 .4 .8])
%         xlim([-4.5 -.6]); ylim([3.6 7]); view(30,20); box on
        xlim([4 7]); ylim([3 6]); view(110,20); box on
    case 7 %CTRL-S2
        sp3=subplot(233);
        plot_isosurface(maskUD,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD,1)),'red'); hold on
        plot_isosurface(maskUD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD2,1)),[.8 .4 0])
        plot_isosurface(maskDD,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD,1)),'blue')
        plot_isosurface(maskDD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD2,1)),[0 .4 .8])
        sp1=subplot(231);
        plot_isosurface(maskUD,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD,1)),'red'); hold on
        plot_isosurface(maskUD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD2,1)),[.8 .4 0])
%         xlim([-1.8 2.5]); ylim([-3.5 1]); view(110,20); box on
        xlim([-4 -1]); ylim([-6 -3]); view(110,20); box on
        sp2=subplot(232);
        plot_isosurface(maskDD,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD,1)),'blue')
        plot_isosurface(maskDD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD2,1)),[0 .4 .8])
%         xlim([-1.3 1]); ylim([1.5 5]); view(110,20); box on
        xlim([0 3]); ylim([-5 -2]); view(110,20); box on
    case 11 %000U-S2
        sp6=subplot(236);
        plot_isosurface(maskUD,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD,1)),'red'); hold on
        plot_isosurface(maskUD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD2,1)),[.8 .4 0])
        plot_isosurface(maskDD,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD,1)),'blue')
        plot_isosurface(maskDD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD2,1)),[0 .4 .8])
        sp4=subplot(234);
        plot_isosurface(maskUD,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD,1)),'red'); hold on
        plot_isosurface(maskUD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskUD2,1)),[.8 .4 0])
%         xlim([1.5 5]); ylim([1 4]); view(30,20); box on
        xlim([-2 1]); ylim([1 4]); view(110,20); box on
        sp5=subplot(235);
        plot_isosurface(maskDD,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD,1)),'blue')
        plot_isosurface(maskDD2,0.5,xm/1e3,ym/1e3,zm(1:size(maskDD2,1)),[0 .4 .8])
%         xlim([-4.8 -1.5]); ylim([-5 -1.5]); view(-20,20); box on
        xlim([4 7]); ylim([3 6]); view(110,20); box on
end

end
%%

for i=1:2
    zis(i)=mean(ps3d(iis(i),time).z_maxtlgrad_xy,[1 2]);
end
subplot(231); zticks([0 zis(1)]); zticklabels([0 1]); zlabel('$z/z_i$','Interpreter','latex'); zlim([0 zis(1)])
subplot(232); zticks([0 zis(1)]); zticklabels([0 1]); zlabel('$z/z_i$','Interpreter','latex'); zlim([0 zis(1)])
subplot(234); zticks([0 zis(2)]); zticklabels([0 1]); zlabel('$z/z_i$','Interpreter','latex'); zlim([0 zis(2)])
subplot(235); zticks([0 zis(2)]); zticklabels([0 1]); zlabel('$z/z_i$','Interpreter','latex'); zlim([0 zis(2)])

subplot(233)
lgd=legend('$\rm UD^I$','$\rm UD^{II}$','$\rm DD^I$','$\rm DD^{II}$','Interpreter','latex');

%%
set(sp1,'Position',[.1 .58 0.2 .34])
set(sp2,'Position',[.37 .58 0.2 .34])
set(sp3,'Position',[.64 .58 0.2 .34])

set(sp4,'Position',[.1 .1 0.2 .34])
set(sp5,'Position',[.37 .1 0.2 .34])
set(sp6,'Position',[.64 .1 0.2 .34])
lgd.Position=[0.85 0.42 0.07 0.2010];
%%
annotation('textbox',[.44 .46 .1 .05],'String',gnrl.mylgd{iis(2)},'Interpreter','latex', ...
    'HorizontalAlignment','center','LineStyle','none','FontSize',16)
annotation('textbox',[.44 .93 .1 .05],'String',gnrl.mylgd{iis(1)},'Interpreter','latex', ...
    'HorizontalAlignment','center','LineStyle','none','FontSize',16)
switch iis(1)
    case 1
        annotation('textbox',[.07 .9 .1 .05],'String','a)','Interpreter','latex', ...
        'HorizontalAlignment','center','LineStyle','none','FontSize',12)
        annotation('textbox',[.34 .9 .1 .05],'String','b)','Interpreter','latex', ...
            'HorizontalAlignment','center','LineStyle','none','FontSize',12)
        annotation('textbox',[.59 .9 .1 .05],'String','c)','Interpreter','latex', ...
            'HorizontalAlignment','center','LineStyle','none','FontSize',12)
    case 7
        annotation('textbox',[.07 .9 .1 .05],'String','g)','Interpreter','latex', ...
            'HorizontalAlignment','center','LineStyle','none','FontSize',12)
        annotation('textbox',[.34 .9 .1 .05],'String','h)','Interpreter','latex', ...
            'HorizontalAlignment','center','LineStyle','none','FontSize',12)
        annotation('textbox',[.59 .9 .1 .05],'String','i)','Interpreter','latex', ...
            'HorizontalAlignment','center','LineStyle','none','FontSize',12)
end

switch iis(2)
    case 5
        annotation('textbox',[.07 .42 .1 .05],'String','d)','Interpreter','latex', ...
            'HorizontalAlignment','center','LineStyle','none','FontSize',12)
        annotation('textbox',[.34 .42 .1 .05],'String','e)','Interpreter','latex', ...
            'HorizontalAlignment','center','LineStyle','none','FontSize',12)
        annotation('textbox',[.59 .42 .1 .05],'String','f)','Interpreter','latex', ...
            'HorizontalAlignment','center','LineStyle','none','FontSize',12)
    case 11
        annotation('textbox',[.07 .42 .1 .05],'String','j)','Interpreter','latex', ...
            'HorizontalAlignment','center','LineStyle','none','FontSize',12)
        annotation('textbox',[.34 .42 .1 .05],'String','k)','Interpreter','latex', ...
            'HorizontalAlignment','center','LineStyle','none','FontSize',12)
        annotation('textbox',[.59 .42 .1 .05],'String','l)','Interpreter','latex', ...
            'HorizontalAlignment','center','LineStyle','none','FontSize',12)
end

%%
fig=gcf;
fig.PaperUnits='inches';
fig.PaperPosition=[0 0 12 6];
% print('../figures/Fig_vis3Dobjects_NS_cont_jan2021','-dpng','-r300')
print('../figures/Fig_vis3Dobjects_S10_cont_jan2021','-dpng','-r300')

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