ip=1;
figure('Position',[1500 0 800 900])
%% updrafts per category
for ii=[5,3,1, 10,8,6, 11,9,7]
    sp(ip)=subplot(6,3,ip);
rp=obj_ud(ii).rpUD;
filUD=obj_ud(ii).filters_UD;
zm=ps(ii).zm;

z0=obj_ud(ii).z0UD;
dz=obj_ud(ii).dzUD;
z1=z0+dz;
Lh=obj_ud(ii).LhUD;
vol=obj_ud(ii).volUD;

colors=get(gca,'colororder');

it=find(ps(ii).time==4*3600);
zt=ps(ii).zm(ps3d(ii,time).nql_izt);
x0=0;
for ifilter=1:6
    objs=find(filUD(:,ifilter));
    
    % plot of object "size" distribution by class    
    [~,isorted]=sort(z0(filUD(:,ifilter)));
       
    for i=1:length(isorted)
        iobj=objs(isorted(i));
        rectangle('Position',[x0 z0(iobj)/zt Lh(iobj) dz(iobj)/zt],'EdgeColor',colors(ifilter,:)); hold on
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
for ii=[5,3,1, 10,8,6, 11,9,7]
    sp(ip)=subplot(6,3,ip);
    rp=obj_ud(ii).rpDD;
    filDD=obj_ud(ii).filters_DD;
    zm=ps(ii).zm;

    z0=obj_ud(ii).z0DD;
    dz=obj_ud(ii).dzDD;
    z1=z0+dz;
    Lh=obj_ud(ii).LhDD;
    vol=obj_ud(ii).volDD;

    colors=get(gca,'colororder');

    it=find(ps(ii).time==4*3600);
    zt=ps(ii).zm(ps3d(ii,time).nql_izt);
    x0=0;
    for ifilter=1:6
        objs=find(filDD(:,ifilter));

        % plot of object "size" distribution by class    
        [~,isorted]=sort(z0(filDD(:,ifilter)));

        for i=1:length(isorted)
            iobj=objs(isorted(i));
            rectangle('Position',[x0 z0(iobj)/zt Lh(iobj) dz(iobj)/zt],'EdgeColor',colors(ifilter,:)); hold on
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
h(i) = plot(NaN,NaN,'Color',colors(i,:));
end
lgd=legend(h,'I','II','III','IV','V','VI','Location','eastoutside','Interpreter','latex','FontSize',10);
title(lgd,'Object Category')

%%
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
filename=['../figures/Fig_UDDDobjectsbyclass'];
fig=gcf;
fig.PaperUnits='inches';
fig.PaperPosition=[0 0 12 9];
print(filename,'-depsc')


