ip=1; lw=1.2
figure('Position',[0 0 900 600])
% updrafts per category
for ii=[5 1 11 7] %[5,3,1, 10,8,6, 11,9,7]
    sp(ip)=subplot(4,2,ip);
    
    set(gca,'FontSize',12)
rp=obj_ud(ii).rpUD;
filUD=obj_ud(ii).filters_UD;
zm=ps(ii).zm;

z0=obj_ud(ii).z0UD;
dz=obj_ud(ii).dzUD;
z1=z0+dz;
Lh=obj_ud(ii).LhUD;
vol=obj_ud(ii).volUD;

% colors=get(gca,'colororder');
% colors=[0 0 0]+[0 73 73; 182 109 255; 0 146 146; 109 182 255; 255 109 182; 182 219 255]/256;
% colors=[0 .8 .1;1 .4 0; .4 1 .6; .6 0 1; .4 .8 1;1 .4 .6];
% colors=[1 0 .2;0 1 .7; .8 .2 .3; .2 .8 .6; .6 .4 .4; .4 .6 .5;]
colors=[0 .8 .1;1 .4 0; .4 1 .6; .6 0 1; .4 .8 1;1 .8 .6];

it=find(ps(ii).time==4*3600);
zt=ps(ii).zm(ps3d(ii,time).nql_izt);
x0=0;
for ifilter=1:6
    objs=find(filUD(:,ifilter));
    
    % plot of object "size" distribution by class    
    [~,isorted]=sort(z0(filUD(:,ifilter)));
       
    for i=1:length(isorted)
        iobj=objs(isorted(i));
        rectangle('Position',[x0 z0(iobj)/zt Lh(iobj) dz(iobj)/zt],'EdgeColor',colors(ifilter,:),'LineWidth',lw); hold on
        x0=x0+sqrt(vol(iobj)/dz(iobj))/1000;
    end
end
title(gnrl.mylgd{ii},'Interpreter','latex'); ylim([0 1]); xlim([0 90])

    ip=ip+1;
    
% xlabel('$L_h$ (km)','Interpreter','latex'); ylabel('$z$ (m)','Interpreter','latex')
% title('Object size distribution')
% print([outpref,'3dseg_ql_',num2str(time,'%02i'),'_objsizedistSD'],'-depsc','-r600'); %close(1)
end

%% downdrafts per category
for ii=[5 1 10 7] %[5,3,1, 10,8,6, 11,9,7]
    sp(ip)=subplot(4,2,ip);
    set(gca,'FontSize',12)
    rp=obj_ud(ii).rpDD;
    filDD=obj_ud(ii).filters_DD;
    zm=ps(ii).zm;

    z0=obj_ud(ii).z0DD;
    dz=obj_ud(ii).dzDD;
    z1=z0+dz;
    Lh=obj_ud(ii).LhDD;
    vol=obj_ud(ii).volDD;

%     colors=[0 .8 .1;1 .4 0; .4 1 .6; .6 0 1; .4 .8 1;1 .4 .6];
%     colors=get(gca,'colororder');
%     colors=[0 73 73; 182 109 255; 0 146 146; 109 182 255; 255 109 182; 182 219 255]/256;
% colors=[0 .6 0;1 .6 .4; 0 1 .6; .6 0 1; .4 .8 1;1 .4 .6];
colors=[0 .8 .1;1 .4 0; .4 1 .6; .6 0 1; .4 .8 1;1 .8 .6];
    
    it=find(ps(ii).time==4*3600);
    zt=ps(ii).zm(ps3d(ii,time).nql_izt);
    x0=0;
    for ifilter=1:6
        objs=find(filDD(:,ifilter));

        % plot of object "size" distribution by class    
        [~,isorted]=sort(z0(filDD(:,ifilter)));

        for i=1:length(isorted)
            iobj=objs(isorted(i));
            rectangle('Position',[x0 z0(iobj)/zt Lh(iobj) dz(iobj)/zt],'EdgeColor',colors(ifilter,:),'LineWidth',lw); hold on
            x0=x0+sqrt(vol(iobj)/dz(iobj))/1000;
        end
    end
    title(gnrl.mylgd{ii},'Interpreter','latex'); ylim([0 1]); xlim([0 90])


    ip=ip+1;
    
% xlabel('$L_h$ (km)','Interpreter','latex'); ylabel('$z$ (m)','Interpreter','latex')
% title('Object size distribution')
% print([outpref,'3dseg_ql_',num2str(time,'%02i'),'_objsizedistSD'],'-depsc','-r600'); %close(1)
end

%%
h = zeros(6, 1);
for i=1:6
h(i) = plot(NaN,NaN,'Color',colors(i,:),'LineWidth',lw);
end
lgd=legend(h,'I: Large thick','II: Large thin','III: Medium bottom','IV: Medium top', ...
    'V: Small bottom','VI:Small top','Location','eastoutside','Interpreter','latex','FontSize',12);
title(lgd,'Object Category')

%% 2 cases
wdt=.9; hgt=.16; x1=0.07; y1=.18; y2=.62;
xticks(sp(1),[]); set(sp(1),'Position',[x1 y2+hgt+0.02 wdt hgt])
set(sp(3),'Position',[x1 y2 wdt hgt]); title(sp(3),[])
xticks(sp(2),[]); set(sp(2),'Position',[x1 y1+hgt+0.02 wdt hgt])
set(sp(4),'Position',[x1 y1 wdt hgt]); title(sp(4),[])

for ip=1:4; xlim(sp(ip),[0 80]); ylim(sp(ip),[0 1.05]); end
for ip=1:4; ylabel(sp(ip),'$z/z_i$','Interpreter','latex'); end
xlabel(sp(4),'Cumulative $L_h$ (km)','Interpreter','latex')

for ip=1:2
    text(sp(ip),75,.5,'Updrafts','Interpreter','latex','FontSize',12,'HorizontalAlignment','center')
end
for ip=3:4
    text(sp(ip),75,.5,'Downdrafts','Interpreter','latex','FontSize',12,'HorizontalAlignment','center')
end
lgd.Orientation='horizontal';
lgd.Position=[.3 0.02 .4 .05];
%% 4 cases
wdt=.44; hgt=.16;
x1=0.07; x2=0.54;
y1=.18; y2=.62;
xticks(sp(1),[]); set(sp(1),'Position',[x1 y2+hgt+0.02 wdt hgt])
set(sp(5),'Position',[x1 y2 wdt hgt]); title(sp(5),[])

xticks(sp(2),[]); set(sp(2),'Position',[x2 y2+hgt+0.02 wdt hgt])
set(sp(6),'Position',[x2 y2 wdt hgt]); title(sp(6),[])

xticks(sp(3),[]); set(sp(3),'Position',[x1 y1+hgt+0.02 wdt hgt])
set(sp(7),'Position',[x1 y1 wdt hgt]); title(sp(7),[])

xticks(sp(4),[]); set(sp(4),'Position',[x2 y1+hgt+0.02 wdt hgt])
set(sp(8),'Position',[x2 y1 wdt hgt]); title(sp(8),[])

for ip=1:8
    xlim(sp(ip),[0 80])
    ylim(sp(ip),[0 1.05])
end
for ip=[1,3,5,7]
    ylabel(sp(ip),'$z/z_i$','Interpreter','latex')
end
for ip=[2,4,6,8]
    sp(ip).YTickLabel=[];
end
for ip=7:8
    xlabel(sp(ip),'Cumulative $L_h$ (km)','Interpreter','latex')
end
for ip=1:4
    text(sp(ip),60,.5,'Updrafts','Interpreter','latex','FontSize',12,'HorizontalAlignment','center')
end
for ip=5:8
    text(sp(ip),60,.5,'Downdrafts','Interpreter','latex','FontSize',12,'HorizontalAlignment','center')
end
lgd.Orientation='horizontal';
lgd.Position=[.3 0.02 .4 .05];
%% 9 cases
wdt=.22; hgt=.12;
x1=0.07; x2=0.35; x3=0.63;
y1=.05; y2=.38; y3=.71;
xticks(sp(1),[]); set(sp(1),'Position',[x1 y3+hgt+0.02 wdt hgt])
set(sp(10),'Position',[x1 y3 wdt hgt]); title(sp(10),[])

xticks(sp(2),[]); set(sp(2),'Position',[x2 y3+hgt+0.02 wdt hgt])
set(sp(11),'Position',[x2 y3 wdt hgt]); title(sp(11),[])

xticks(sp(3),[]); set(sp(3),'Position',[x3 y3+hgt+0.02 wdt hgt])
set(sp(12),'Position',[x3 y3 wdt hgt]); title(sp(12),[])

xticks(sp(4),[]); set(sp(4),'Position',[x1 y2+hgt+0.02 wdt hgt])
set(sp(13),'Position',[x1 y2 wdt hgt]); title(sp(13),[])

xticks(sp(5),[]); set(sp(5),'Position',[x2 y2+hgt+0.02 wdt hgt])
set(sp(14),'Position',[x2 y2 wdt hgt]); title(sp(14),[])

xticks(sp(6),[]); set(sp(6),'Position',[x3 y2+hgt+0.02 wdt hgt])
set(sp(15),'Position',[x3 y2 wdt hgt]); title(sp(15),[])

xticks(sp(7),[]); set(sp(7),'Position',[x1 y1+hgt+0.02 wdt hgt])
set(sp(16),'Position',[x1 y1 wdt hgt]); title(sp(16),[])

xticks(sp(8),[]); set(sp(8),'Position',[x2 y1+hgt+0.02 wdt hgt])
set(sp(17),'Position',[x2 y1 wdt hgt]); title(sp(17),[])

xticks(sp(9),[]); set(sp(9),'Position',[x3 y1+hgt+0.02 wdt hgt])
set(sp(18),'Position',[x3 y1 wdt hgt]); title(sp(18),[])

for ip=[1,4,7,10,13,16]
    ylabel(sp(ip),'$z/z_i$','Interpreter','latex')
end
for ip=10:18
    xlabel(sp(ip),'Cumulative $L_h$ (km)','Interpreter','latex')
end
for ip=1:9
    text(sp(ip),60,.5,'Updrafts','Interpreter','latex')
end
for ip=10:18
    text(sp(ip),52,.5,'Downdrafts','Interpreter','latex')
end

lgd.Position=[.86 .45 .13 .13];

%% Save plot
filename=['../figures/Fig_UDDDobjectsbyclass_4cases_v3'];
fig=gcf;
fig.PaperUnits='inches';
fig.PaperPosition=[0 0 9 6];
print(filename,'-depsc')


