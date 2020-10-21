ip=1;
figure('Position',[0 0 900 300])

% clouds per category
for ii=[1 5 7 11]%[5,3,1, 10,8,6, 11,9,7]
    sp(ip)=subplot(2,2,ip);
rp=obj_ql(ii).rp;
zm=ps(ii).zm;

z0=obj_ql(ii).z0;
dz=obj_ql(ii).dz;
z1=z0+dz;
Lh=obj_ql(ii).Lh;
vol=obj_ql(ii).vol;

it=find(ps(ii).time==4*3600);
zt=ps(ii).zm(ps3d(ii,time).nql_izt);
x0=0;
    
% plot of object "size" distribution by class    
[~,isorted]=sort(z0);
       
for i=1:length(isorted)
    iobj=isorted(i);
    rectangle('Position',[x0 z0(iobj)/zt Lh(iobj) dz(iobj)/zt],'EdgeColor',[1 1 1]*.4,'LineWidth',1.3); hold on
    x0=x0+sqrt(vol(iobj)/dz(iobj))/1000;
end
text(17,0.73,gnrl.mylgd{ii},'Interpreter','latex','FontSize',12,'HorizontalAlignment','right');
ylim([0.68 1.02]); xlim([0 18])

ip=ip+1;
end

%%
for ip=1:4; sp(ip).FontSize=12; end
for ip=1:2; sp(ip).XTickLabel=[]; end
for ip=[2 4]; sp(ip).YTickLabel=[]; end
for ip=[1,3]
    ylabel(sp(ip),'$z/z_i$','Interpreter','latex','FontSize',12)
end
for ip=3:4
    xlabel(sp(ip),'Cumulative $L_h$ (km)','Interpreter','latex','FontSize',12)
end
sp(1).Position=[.1 .59 .43 .39];
sp(2).Position=[.55 .59 .43 .39];
sp(3).Position=[.1 .15 .43 .39];
sp(4).Position=[.55 .15 .43 .39];

%% Save plot
filename=['../figures/Fig_cloudcoresposition_4cases'];
fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 9 3];
print(filename,'-depsc')


