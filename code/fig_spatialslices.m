time=60; %hr 4
load('../in/LESoutput/075U_14km_zrough_nudge/hr3_4/rf01_xm.mat')
load('../in/LESoutput/075U_14km_zrough_nudge/hr3_4/rf01_ym.mat')

%% Surface shear cases
figure('Position',[1300 0 600 700])
iis=[5,3,1];
for ip=1:3
    ii=iis(ip);
    filename=[base(ii).datafolder,base(ii).casename,'/hr3_4/'];
    var3d={'u','v','w','LWP'};
    for ivar=1:length(var3d); load([filename,'rf01_',var3d{ivar},num2str(time,'%02i')]); end
    ipp=ip;

    %% lwp
    sp(ipp)=subplot(4,3,ipp); % LWP
    contourf(xm/1000,ym/1000,LWP,'LineStyle','none'); colormap('bone'); hold on; caxis([0 100])
    uxy=squeeze(u(ps3d(ii,time).nql_max_iz,:,:)); vxy=squeeze(v(ps3d(ii,time).nql_max_iz,:,:)); meanu=mean(uxy,'all'); meanv=mean(vxy,'all');
    quiver(0,0,meanu,meanv,0.5,'Color','yellow','LineWidth',3)
%     c=colorbar; ylabel(c,'${\rm LWP}(x,y){~\rm(g~m^{-2})}$','Interpreter','latex','Fontsize',16)
%     xlabel('$x$ (km)','Interpreter','latex','Fontsize',16); ylabel('$y$ (km)','Interpreter','latex','Fontsize',16)
%     xticks([-5 0 5]); yticks([-5 0 5]);
%     print(['../figures/Spatial_',gnrl.mylgd{ii},'_LWP_t',num2str(time,'%02i')],'-dpng'); close(1)

    %% w(x,y) at cloudiest level  
    sp(ipp+3)=subplot(4,3,ipp+3);
    iz=ps3d(ii,time).nql_max_iz;
    wxy=squeeze(w(iz,:,:)); wanom=wxy-mean(wxy,'all');
    uxy=squeeze(u(iz,:,:)); vxy=squeeze(v(iz,:,:));
    meanu=mean(uxy,'all'); meanv=mean(vxy,'all');
    contourf(xm/1000,ym/1000,wanom,'LineStyle','none'); caxis([-1.5 1.5]); colormap('bone'); hold on
    quiver(0,0,meanu,meanv,0.5,'Color','yellow','LineWidth',3)
%     c=colorbar; ylabel(c,'$w''(x,y){~\rm(m~s^{-1})}$ at cloudiest level','Interpreter','latex','Fontsize',16)
%     xlabel('$x$ (km)','Interpreter','latex','Fontsize',16); ylabel('$y$ (km)','Interpreter','latex','Fontsize',16)
%     xticks([-5 0 5]); yticks([-5 0 5]);
%     print(['../figures/Spatial_',gnrl.mylgd{ii},'_wanom_zcloudiest_t',num2str(time,'%02i')],'-dpng'); close(1);

    %% w(x,y) at 0.5 zb
    sp(ipp+6)=subplot(4,3,ipp+6);
    iz=find(ps(ii).zm>0.5*ps(ii).zm(ps3d(ii,time).nql_izb),1); %first point ~0.5 zb (mid sub cloud)
    wxy=squeeze(w(iz,:,:)); wanom=wxy-mean(wxy,'all');
    uxy=squeeze(u(iz,:,:)); vxy=squeeze(v(iz,:,:));
    meanu=mean(uxy,'all'); meanv=mean(vxy,'all');

%     figure('Position',[0 0 500 400])
    contourf(xm/1000,ym/1000,wanom,'LineStyle','none'); caxis([-1.5 1.5]); colormap('bone'); hold on
    quiver(0,0,meanu,meanv,0.5,'Color','yellow','LineWidth',3)
%     c=colorbar; ylabel(c,'$w''(x,y){~\rm(m~s^{-1})}$ at $z/z_b=0.5$','Interpreter','latex','Fontsize',16)
%     xlabel('$x$ (km)','Interpreter','latex','Fontsize',16); ylabel('$y$ (km)','Interpreter','latex','Fontsize',16)
%     xticks([-5 0 5]); yticks([-5 0 5]);
%     print(['../figures/Spatial_',gnrl.mylgd{ii},'_wanom_05zb_t',num2str(time,'%02i')],'-dpng'); close(1);
    
        %% at 0.1 zi 
    sp(ipp+9)=subplot(4,3,ipp+9);
    iz=find(ps(ii).zm>0.1*ps(ii).zm(ps3d(ii,time).nql_izt),1); %first point ~0.1 zi
    wxy=squeeze(w(iz,:,:)); wanom=wxy-mean(wxy,'all');
    uxy=squeeze(u(iz,:,:)); vxy=squeeze(v(iz,:,:));
    meanu=mean(uxy,'all'); meanv=mean(vxy,'all');

%     figure('Position',[0 0 500 400])
    contourf(xm/1000,ym/1000,wanom,'LineStyle','none'); caxis([-1.5 1.5]); colormap('bone'); hold on
    quiver(0,0,meanu,meanv,0.5,'Color','yellow','LineWidth',3)
%     c=colorbar; ylabel(c,'$w''(x,y){~\rm(m~s^{-1})}$ at $z/z_i=0.1$','Interpreter','latex','Fontsize',16)
%     xlabel('$x$ (km)','Interpreter','latex','Fontsize',16); ylabel('$y$ (km)','Interpreter','latex','Fontsize',16)
%     xticks([-5 0 5]); yticks([-5 0 5]);
%     print(['../figures/Spatial_',gnrl.mylgd{ii},'_wanom_01zi_t',num2str(time,'%02i')],'-dpng'); close(1);

end

%%

for ip=[2,3,5,6,8,9,11,12]
    subplot(4,3,ip); yticks([]);
end
for ip=1:9
    subplot(4,3,ip); xticks([]);
end
for ip=[1,4,7,10]
    ylabel(sp(ip),'$y$ (km)','Interpreter','latex')
end
for ip=10:12
    xlabel(sp(ip),'$x$ (km)','Interpreter','latex')
end
subplot(4,3,3); c1=colorbar; ylabel(c1,'${\rm LWP}{~\rm(g~m^{-2})}$','Interpreter','latex')
subplot(4,3,6); c2=colorbar; ylabel(c2,'$w''{~\rm(m~s^{-1})}$ at cloudiest level','Interpreter','latex')
subplot(4,3,9); c3=colorbar; ylabel(c3,'$w''{~\rm(m~s^{-1})}$ at $z/z_b=0.5$','Interpreter','latex')
subplot(4,3,12); c4=colorbar; ylabel(c4,'$w''{~\rm(m~s^{-1})}$ at $z/z_i=0.1$','Interpreter','latex')

%%
wdt=.26; hgt=.21;
x=[0.06 0.34 0.62];
y=[.76 .53 .3 .07];
for ip=1:12
    ix=rem(ip,3); if ix==0; ix=3; end
    iy=ceil(ip/3);
    set(sp(ip),'Position',[x(ix) y(iy) wdt hgt])
end

%%
for ip=[1,4,7,10]
    rectangle(sp(ip),'Position',[-7 -7 4.5 2],'FaceColor','k','EdgeColor','none')
    text(sp(ip),-6.9,-6,'000U','Color','y','FontSize',14)
end
for ip=[2,5,8,11]
    rectangle(sp(ip),'Position',[-7 -7 4.5 2],'FaceColor','k','EdgeColor','none')
    text(sp(ip),-6.9,-6,'050U','Color','y','FontSize',14)
end
for ip=[3,6,9,12]
    rectangle(sp(ip),'Position',[-7 -7 4.5 2],'FaceColor','k','EdgeColor','none')
    text(sp(ip),-6.9,-6,'CTRL','Color','y','FontSize',14)
end

% move colorbars
c1.Position = [.89 .78 .026 .16];
c2.Position = [.89 .55 .026 .16];
c3.Position = [.89 .32 .026 .16];
c4.Position = [.89 .09 .026 .16];

%%
filename=['../figures/Fig_Spatial_NS'];
fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 7 8];
print(filename,'-dpng','-r300')
print([filename,'_r600'],'-dpng','-r600')

%% part 2 ( strong top shear)
time=60; %hr 4
load('../in/LESoutput/075U_14km_zrough_nudge/hr3_4/rf01_xm.mat')
load('../in/LESoutput/075U_14km_zrough_nudge/hr3_4/rf01_ym.mat')

%% 
figure('Position',[1300 0 600 700])
iis=[11,9,7];
for ip=1:3
    ii=iis(ip);
    filename=[base(ii).datafolder,base(ii).casename,'/hr3_4/'];
    var3d={'u','v','w','LWP'};
    for ivar=1:length(var3d); load([filename,'rf01_',var3d{ivar},num2str(time,'%02i')]); end
    ipp=ip;

    %% lwp
    sp(ipp)=subplot(4,3,ipp); % LWP
    contourf(xm/1000,ym/1000,LWP,'LineStyle','none'); colormap('bone'); hold on; caxis([0 100])
    uxy=squeeze(u(ps3d(ii,time).nql_max_iz,:,:)); vxy=squeeze(v(ps3d(ii,time).nql_max_iz,:,:)); meanu=mean(uxy,'all'); meanv=mean(vxy,'all');
    quiver(0,0,meanu,meanv,0.5,'Color','yellow','LineWidth',3)
%     c=colorbar; ylabel(c,'${\rm LWP}(x,y){~\rm(g~m^{-2})}$','Interpreter','latex','Fontsize',16)
%     xlabel('$x$ (km)','Interpreter','latex','Fontsize',16); ylabel('$y$ (km)','Interpreter','latex','Fontsize',16)
%     xticks([-5 0 5]); yticks([-5 0 5]);
%     print(['../figures/Spatial_',gnrl.mylgd{ii},'_LWP_t',num2str(time,'%02i')],'-dpng'); close(1)

    %% w(x,y) at cloudiest level  
    sp(ipp+3)=subplot(4,3,ipp+3);
    iz=ps3d(ii,time).nql_max_iz;
    wxy=squeeze(w(iz,:,:)); wanom=wxy-mean(wxy,'all');
    uxy=squeeze(u(iz,:,:)); vxy=squeeze(v(iz,:,:));
    meanu=mean(uxy,'all'); meanv=mean(vxy,'all');
    contourf(xm/1000,ym/1000,wanom,'LineStyle','none'); caxis([-1.5 1.5]); colormap('bone'); hold on
    quiver(0,0,meanu,meanv,0.5,'Color','yellow','LineWidth',3)
%     c=colorbar; ylabel(c,'$w''(x,y){~\rm(m~s^{-1})}$ at cloudiest level','Interpreter','latex','Fontsize',16)
%     xlabel('$x$ (km)','Interpreter','latex','Fontsize',16); ylabel('$y$ (km)','Interpreter','latex','Fontsize',16)
%     xticks([-5 0 5]); yticks([-5 0 5]);
%     print(['../figures/Spatial_',gnrl.mylgd{ii},'_wanom_zcloudiest_t',num2str(time,'%02i')],'-dpng'); close(1);

    %% w(x,y) at 0.5 zb
    sp(ipp+6)=subplot(4,3,ipp+6);
    iz=find(ps(ii).zm>0.5*ps(ii).zm(ps3d(ii,time).nql_izb),1); %first point ~0.5 zb (mid sub cloud)
    wxy=squeeze(w(iz,:,:)); wanom=wxy-mean(wxy,'all');
    uxy=squeeze(u(iz,:,:)); vxy=squeeze(v(iz,:,:));
    meanu=mean(uxy,'all'); meanv=mean(vxy,'all');

%     figure('Position',[0 0 500 400])
    contourf(xm/1000,ym/1000,wanom,'LineStyle','none'); caxis([-1.5 1.5]); colormap('bone'); hold on
    quiver(0,0,meanu,meanv,0.5,'Color','yellow','LineWidth',3)
%     c=colorbar; ylabel(c,'$w''(x,y){~\rm(m~s^{-1})}$ at $z/z_b=0.5$','Interpreter','latex','Fontsize',16)
%     xlabel('$x$ (km)','Interpreter','latex','Fontsize',16); ylabel('$y$ (km)','Interpreter','latex','Fontsize',16)
%     xticks([-5 0 5]); yticks([-5 0 5]);
%     print(['../figures/Spatial_',gnrl.mylgd{ii},'_wanom_05zb_t',num2str(time,'%02i')],'-dpng'); close(1);
    
        %% at 0.1 zi 
    sp(ipp+9)=subplot(4,3,ipp+9);
    iz=find(ps(ii).zm>0.1*ps(ii).zm(ps3d(ii,time).nql_izt),1); %first point ~0.1 zi
    wxy=squeeze(w(iz,:,:)); wanom=wxy-mean(wxy,'all');
    uxy=squeeze(u(iz,:,:)); vxy=squeeze(v(iz,:,:));
    meanu=mean(uxy,'all'); meanv=mean(vxy,'all');

%     figure('Position',[0 0 500 400])
    contourf(xm/1000,ym/1000,wanom,'LineStyle','none'); caxis([-1.5 1.5]); colormap('bone'); hold on
    quiver(0,0,meanu,meanv,0.5,'Color','yellow','LineWidth',3)
%     c=colorbar; ylabel(c,'$w''(x,y){~\rm(m~s^{-1})}$ at $z/z_i=0.1$','Interpreter','latex','Fontsize',16)
%     xlabel('$x$ (km)','Interpreter','latex','Fontsize',16); ylabel('$y$ (km)','Interpreter','latex','Fontsize',16)
%     xticks([-5 0 5]); yticks([-5 0 5]);
%     print(['../figures/Spatial_',gnrl.mylgd{ii},'_wanom_01zi_t',num2str(time,'%02i')],'-dpng'); close(1);

end

%%

for ip=[2,3,5,6,8,9,11,12]
    subplot(4,3,ip); yticks([]);
end
for ip=1:9
    subplot(4,3,ip); xticks([]);
end
for ip=[1,4,7,10]
    ylabel(sp(ip),'$y$ (km)','Interpreter','latex')
end
for ip=10:12
    xlabel(sp(ip),'$x$ (km)','Interpreter','latex')
end
subplot(4,3,3); c1=colorbar; ylabel(c1,'${\rm LWP}{~\rm(g~m^{-2})}$','Interpreter','latex')
subplot(4,3,6); c2=colorbar; ylabel(c2,'$w''{~\rm(m~s^{-1})}$ at cloudiest level','Interpreter','latex')
subplot(4,3,9); c3=colorbar; ylabel(c3,'$w''{~\rm(m~s^{-1})}$ at $z/z_b=0.5$','Interpreter','latex')
subplot(4,3,12); c4=colorbar; ylabel(c4,'$w''{~\rm(m~s^{-1})}$ at $z/z_i=0.1$','Interpreter','latex')

%%
wdt=.26; hgt=.21;
x=[0.06 0.34 0.62];
y=[.76 .53 .3 .07];
for ip=1:12
    ix=rem(ip,3); if ix==0; ix=3; end
    iy=ceil(ip/3);
    set(sp(ip),'Position',[x(ix) y(iy) wdt hgt])
end

%%
for ip=[1,4,7,10]
    rectangle(sp(ip),'Position',[-7 -7 7.4 2],'FaceColor','k','EdgeColor','none')
    text(sp(ip),-6.9,-6,'000U-S10','Color','y','FontSize',14)
end
for ip=[2,5,8,11]
    rectangle(sp(ip),'Position',[-7 -7 7.4 2],'FaceColor','k','EdgeColor','none')
    text(sp(ip),-6.9,-6,'050U-S10','Color','y','FontSize',14)
end
for ip=[3,6,9,12]
    rectangle(sp(ip),'Position',[-7 -7 7.4 2],'FaceColor','k','EdgeColor','none')
    text(sp(ip),-6.9,-6,'CTRL-S10','Color','y','FontSize',14)
end

% move colorbars
c1.Position = [.89 .78 .026 .16];
c2.Position = [.89 .55 .026 .16];
c3.Position = [.89 .32 .026 .16];
c4.Position = [.89 .09 .026 .16];

%%
filename=['../figures/Fig_Spatial_S10'];
fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 7 8];
print(filename,'-dpng','-r300')
print([filename,'_r600'],'-dpng','-r600')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% extra: weak shear (if needed, not currently in the paper)
figure('Position',[1300 0 600 700])
iis=[10,8,6];
for ip=1:3
    ii=iis(ip);
    filename=[base(ii).datafolder,base(ii).casename,'/hr3_4/'];
    var3d={'u','v','w','LWP'};
    for ivar=1:length(var3d); load([filename,'rf01_',var3d{ivar},num2str(time,'%02i')]); end
    ipp=ip;

    %% lwp
    sp(ipp)=subplot(4,3,ipp); % LWP
    contourf(xm/1000,ym/1000,LWP,'LineStyle','none'); colormap('bone'); hold on; caxis([0 100])
    uxy=squeeze(u(ps3d(ii,time).nql_max_iz,:,:)); vxy=squeeze(v(ps3d(ii,time).nql_max_iz,:,:)); meanu=mean(uxy,'all'); meanv=mean(vxy,'all');
    quiver(0,0,meanu,meanv,0.5,'Color','yellow','LineWidth',3)
%     c=colorbar; ylabel(c,'${\rm LWP}(x,y){~\rm(g~m^{-2})}$','Interpreter','latex','Fontsize',16)
%     xlabel('$x$ (km)','Interpreter','latex','Fontsize',16); ylabel('$y$ (km)','Interpreter','latex','Fontsize',16)
%     xticks([-5 0 5]); yticks([-5 0 5]);
%     print(['../figures/Spatial_',gnrl.mylgd{ii},'_LWP_t',num2str(time,'%02i')],'-dpng'); close(1)

    %% w(x,y) at cloudiest level  
    sp(ipp+3)=subplot(4,3,ipp+3);
    iz=ps3d(ii,time).nql_max_iz;
    wxy=squeeze(w(iz,:,:)); wanom=wxy-mean(wxy,'all');
    uxy=squeeze(u(iz,:,:)); vxy=squeeze(v(iz,:,:));
    meanu=mean(uxy,'all'); meanv=mean(vxy,'all');
    contourf(xm/1000,ym/1000,wanom,'LineStyle','none'); caxis([-1.5 1.5]); colormap('bone'); hold on
    quiver(0,0,meanu,meanv,0.5,'Color','yellow','LineWidth',3)
%     c=colorbar; ylabel(c,'$w''(x,y){~\rm(m~s^{-1})}$ at cloudiest level','Interpreter','latex','Fontsize',16)
%     xlabel('$x$ (km)','Interpreter','latex','Fontsize',16); ylabel('$y$ (km)','Interpreter','latex','Fontsize',16)
%     xticks([-5 0 5]); yticks([-5 0 5]);
%     print(['../figures/Spatial_',gnrl.mylgd{ii},'_wanom_zcloudiest_t',num2str(time,'%02i')],'-dpng'); close(1);

    %% w(x,y) at 0.5 zb
    sp(ipp+6)=subplot(4,3,ipp+6);
    iz=find(ps(ii).zm>0.5*ps(ii).zm(ps3d(ii,time).nql_izb),1); %first point ~0.5 zb (mid sub cloud)
    wxy=squeeze(w(iz,:,:)); wanom=wxy-mean(wxy,'all');
    uxy=squeeze(u(iz,:,:)); vxy=squeeze(v(iz,:,:));
    meanu=mean(uxy,'all'); meanv=mean(vxy,'all');

%     figure('Position',[0 0 500 400])
    contourf(xm/1000,ym/1000,wanom,'LineStyle','none'); caxis([-1.5 1.5]); colormap('bone'); hold on
    quiver(0,0,meanu,meanv,0.5,'Color','yellow','LineWidth',3)
%     c=colorbar; ylabel(c,'$w''(x,y){~\rm(m~s^{-1})}$ at $z/z_b=0.5$','Interpreter','latex','Fontsize',16)
%     xlabel('$x$ (km)','Interpreter','latex','Fontsize',16); ylabel('$y$ (km)','Interpreter','latex','Fontsize',16)
%     xticks([-5 0 5]); yticks([-5 0 5]);
%     print(['../figures/Spatial_',gnrl.mylgd{ii},'_wanom_05zb_t',num2str(time,'%02i')],'-dpng'); close(1);
    
        %% at 0.1 zi 
    sp(ipp+9)=subplot(4,3,ipp+9);
    iz=find(ps(ii).zm>0.1*ps(ii).zm(ps3d(ii,time).nql_izt),1); %first point ~0.1 zi
    wxy=squeeze(w(iz,:,:)); wanom=wxy-mean(wxy,'all');
    uxy=squeeze(u(iz,:,:)); vxy=squeeze(v(iz,:,:));
    meanu=mean(uxy,'all'); meanv=mean(vxy,'all');

%     figure('Position',[0 0 500 400])
    contourf(xm/1000,ym/1000,wanom,'LineStyle','none'); caxis([-1.5 1.5]); colormap('bone'); hold on
    quiver(0,0,meanu,meanv,0.5,'Color','yellow','LineWidth',3)
%     c=colorbar; ylabel(c,'$w''(x,y){~\rm(m~s^{-1})}$ at $z/z_i=0.1$','Interpreter','latex','Fontsize',16)
%     xlabel('$x$ (km)','Interpreter','latex','Fontsize',16); ylabel('$y$ (km)','Interpreter','latex','Fontsize',16)
%     xticks([-5 0 5]); yticks([-5 0 5]);
%     print(['../figures/Spatial_',gnrl.mylgd{ii},'_wanom_01zi_t',num2str(time,'%02i')],'-dpng'); close(1);

end

%%

for ip=[2,3,5,6,8,9,11,12]
    subplot(4,3,ip); yticks([]);
end
for ip=1:9
    subplot(4,3,ip); xticks([]);
end
for ip=[1,4,7,10]
    ylabel(sp(ip),'$y$ (km)','Interpreter','latex')
end
for ip=10:12
    xlabel(sp(ip),'$x$ (km)','Interpreter','latex')
end
subplot(4,3,3); c1=colorbar; ylabel(c1,'${\rm LWP}{~\rm(g~m^{-2})}$','Interpreter','latex')
subplot(4,3,6); c2=colorbar; ylabel(c2,'$w''{~\rm(m~s^{-1})}$ at cloudiest level','Interpreter','latex')
subplot(4,3,9); c3=colorbar; ylabel(c3,'$w''{~\rm(m~s^{-1})}$ at $z/z_b=0.5$','Interpreter','latex')
subplot(4,3,12); c4=colorbar; ylabel(c4,'$w''{~\rm(m~s^{-1})}$ at $z/z_i=0.1$','Interpreter','latex')

%%
wdt=.26; hgt=.21;
x=[0.06 0.34 0.62];
y=[.76 .53 .3 .07];
for ip=1:12
    ix=rem(ip,3); if ix==0; ix=3; end
    iy=ceil(ip/3);
    set(sp(ip),'Position',[x(ix) y(iy) wdt hgt])
end

%%
for ip=[1,4,7,10]
    rectangle(sp(ip),'Position',[-7 -7 7.2 2],'FaceColor','k','EdgeColor','none')
    text(sp(ip),-6.9,-6,'000U-S5','Color','y','FontSize',14)
end
for ip=[2,5,8,11]
    rectangle(sp(ip),'Position',[-7 -7 7.2 2],'FaceColor','k','EdgeColor','none')
    text(sp(ip),-6.9,-6,'050U-S5','Color','y','FontSize',14)
end
for ip=[3,6,9,12]
    rectangle(sp(ip),'Position',[-7 -7 7.2 2],'FaceColor','k','EdgeColor','none')
    text(sp(ip),-6.9,-6,'CTRL-S5','Color','y','FontSize',14)
end

% move colorbars
c1.Position = [.89 .78 .026 .16];
c2.Position = [.89 .55 .026 .16];
c3.Position = [.89 .32 .026 .16];
c4.Position = [.89 .09 .026 .16];

%%
filename=['../figures/Fig_Spatial_S5'];
fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 7 8];
print(filename,'-dpng','-r300')
print([filename,'_r600'],'-dpng','-r600')

