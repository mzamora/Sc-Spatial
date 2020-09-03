ip=1;
figure('Position',[0 0 800 400])

% clouds per category
for ii=[5,3,1, 10,8,6, 11,9,7]
    sp(ip)=subplot(3,3,ip);
rp=obj_ql(ii).rp;
zm=ps(ii).zm;

z0=obj_ql(ii).z0;
dz=obj_ql(ii).dz;
z1=z0+dz;
Lh=obj_ql(ii).Lh;
vol=obj_ql(ii).vol;

colors=get(gca,'colororder');

it=find(ps(ii).time==4*3600);
zt=ps(ii).zm(ps3d(ii,time).nql_izt);
x0=0;
    
% plot of object "size" distribution by class    
[~,isorted]=sort(z0);
       
for i=1:length(isorted)
    iobj=isorted(i);
    rectangle('Position',[x0 z0(iobj)/zt Lh(iobj) dz(iobj)/zt],'EdgeColor',[1 1 1]*.5); hold on
    x0=x0+sqrt(vol(iobj)/dz(iobj))/1000;
end
title(gnrl.mylgd{ii},'Interpreter','latex'); ylim([0.65 1.05]); xlim([0 21])

ip=ip+1;
end

%%
for ip=[1,4,7]
    ylabel(sp(ip),'$z/z_i$','Interpreter','latex')
end
for ip=7:9
    xlabel(sp(ip),'Cumulative $L_h$ (km)','Interpreter','latex')
end

%% Save plot
filename=['../figures/Fig_cloudcoresposition'];
fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 6 4];
print(filename,'-depsc')


