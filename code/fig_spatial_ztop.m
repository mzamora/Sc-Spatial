
figure('Position',[0 0 700 600])

iis=[5,3,1,10,8,6,11,9,7];
for ip=1:9
    sp(ip)=subplot(3,3,ip);    
    ii=iis(ip);
     contourf(xm/1000,ym/1000,ps3d(ii,time).cth_xy,'LineStyle','none'); caxis([780 880]); colormap(bone); hold on
%      c=colorbar; ylabel(c,'$z_t${~\rm(m)}','Interpreter','latex','Fontsize',16)
%     xlabel('$x$ (km)','Interpreter','latex','Fontsize',16); ylabel('$y$ (km)','Interpreter','latex','Fontsize',16)
%     xticks([-5 0 5]); yticks([-5 0 5]);
%     print(['../figures/Spatial_',gnrl.mylgd{ii},'_cth_t',num2str(time,'%02i')],'-dpng'); close(1);
end

%%  for the last 3 (S10) get theoretical wavelength
angsDelta=[]; usDelta=[]; vsDelta=[];
for ii=[5,3,1,10,8,6,11,9,7]
time=60; % for time=1:4 %60
filename=[base(ii).datafolder,base(ii).casename,'/hr3_4/'];
load([filename,'rf01_u',num2str(time,'%02i')]);
load([filename,'rf01_v',num2str(time,'%02i')]);
load([filename,'rf01_tv',num2str(time,'%02i')]);

q=sqrt(u.^2+v.^2); %plot(mean(q,[2 3]),zm)
% find shear layer
qmean_z=mean(q,[2 3]); umean_z=mean(u,[2 3]); vmean_z=mean(v,[2 3]);
d2qz=diff(qmean_z,2); % 2nd derivative of tv
[~,izu1]=max(d2qz(20:end-1)); izu1=izu1+20; %skip sometimes spurious last point
[~,izu2]=min(d2qz(20:end-1)); izu2=izu2+20; 

% uBL and vBL (below and above 200m of the shear layer)
itop=find(zm>zm(izu2)+200,1);
ilow=find(zm>zm(izu1)-200,1);
uBL=mean(umean_z(ilow:izu1)); vBL=mean(vmean_z(ilow:izu1)); qBL=mean(qmean_z(ilow:izu1));
uFT=mean(umean_z(izu2:itop)); vFT=mean(vmean_z(izu2:itop)); qFT=mean(qmean_z(izu2:itop));

% angles:
angBL=atan2d(vBL,uBL);
angFT=atan2d(vFT,uFT);
angDelta=atan2d(vFT-vBL,uFT-uBL); angsDelta=[angsDelta,angDelta];
usDelta=[usDelta,uFT-uBL]; vsDelta=[vsDelta,vFT-vBL];
end

% edit get_theorericalwavelength
lS2=lambda_KH(end)/1e3; %in km
%%
linecol=[1 1 0];
for ip=1:6
    subplot(3,3,ip); hold on; 
    quiver(0,0,usDelta(ip),vsDelta(ip),.4,'LineWidth',4,'Color',[1 0 0])
end

for ip=7:9
subplot(3,3,ip); hold on; angle=90+angsDelta(ip);
quiver(0,0,usDelta(ip),vsDelta(ip),.4,'LineWidth',4,'Color',[1 0 0])
for xs=0:lS2:7
    ys=-7+(7-xs)*tand(angle);
    plot([7 xs],[ys -7],'Color',linecol,'LineWidth',1.8)
end
end


for ip=[2,3,5,6,8,9]
    subplot(3,3,ip); yticks([]);
end
for ip=1:6
    subplot(3,3,ip); xticks([]);
end
for ip=[1,4,7]
    ylabel(sp(ip),'$y$ (km)','Interpreter','latex','FontSize',10)
end
for ip=7:9
    xlabel(sp(ip),'$x$ (km)','Interpreter','latex','FontSize',10)
end

subplot(3,3,9); c=colorbar; ylabel(c,'$z_t$ (m)','Interpreter','latex','FontSize',10)

%%
wdt=.25; hgt=.27;
x=[0.07 0.34 0.61];
y=[.69 .39 .09];
for ip=1:9
    ix=rem(ip,3); if ix==0; ix=3; end
    iy=ceil(ip/3);
    set(sp(ip),'Position',[x(ix) y(iy) wdt hgt])
end


%%
rectangle(sp(1),'Position',[-7 -7 4.5 2],'FaceColor','k','EdgeColor','none')
text(sp(1),-6.9,-6,'000U','Color','y','FontSize',14)
rectangle(sp(2),'Position',[-7 -7 4.6 2],'FaceColor','k','EdgeColor','none')
text(sp(2),-6.9,-6,'050U','Color','y','FontSize',14)
rectangle(sp(3),'Position',[-7 -7 4.6 2],'FaceColor','k','EdgeColor','none')
text(sp(3),-6.9,-6,'CTRL','Color','y','FontSize',14)

rectangle(sp(4),'Position',[-7 -7 6.9 2],'FaceColor','k','EdgeColor','none')
text(sp(4),-6.9,-6,'000U-S5','Color','y','FontSize',14)
rectangle(sp(5),'Position',[-7 -7 6.9 2],'FaceColor','k','EdgeColor','none')
text(sp(5),-6.9,-6,'050U-S5','Color','y','FontSize',14)
rectangle(sp(6),'Position',[-7 -7 6.9 2],'FaceColor','k','EdgeColor','none')
text(sp(6),-6.9,-6,'CTRL-S5','Color','y','FontSize',14)

rectangle(sp(7),'Position',[-7 -7 7.7 2],'FaceColor','k','EdgeColor','none')
text(sp(7),-6.9,-6,'000U-S10','Color','y','FontSize',14)
rectangle(sp(8),'Position',[-7 -7 7.7 2],'FaceColor','k','EdgeColor','none')
text(sp(8),-6.9,-6,'050U-S10','Color','y','FontSize',14)
rectangle(sp(9),'Position',[-7 -7 7.7 2],'FaceColor','k','EdgeColor','none')
text(sp(9),-6.9,-6,'CTRL-S10','Color','y','FontSize',14)

c.Position=[.87 .33 .03 .39];
%%
%%
filename=['../figures/Fig_Spatial_ztop_jan2021'];
fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 7 6];
print(filename,'-dpng','-r300')
print([filename,'_r600'],'-dpng','-r600')
