% redo if needed
for ii=1:11
    casename=base(ii).name;
    filename=[casename(1:end-4),'hr3_4/'];
    var3d={'w','u','v','tl','tv','qt','ql','LWP'};
    [nz,nx,ny]=size(ql);
    for ivar=1:length(var3d)
        load([filename,'rf01_',var3d{ivar},num2str(time,'%02i')])
    end
    izt=ps3d(ii).nql_izt;
%     [obj_ud(ii).ww_cs_UD,~]=get_cs_fluxes_wobjfilters(obj_ud(ii).ccUD,obj_ud(ii).filters_UD,w,w,izt,nz,nx,ny);
%     [obj_ud(ii).wtv_cs_UD,~]=get_cs_fluxes_wobjfilters(obj_ud(ii).ccUD,obj_ud(ii).filters_UD,w,tv,izt,nz,nx,ny);
%     [obj_ud(ii).wtl_cs_UD,~]=get_cs_fluxes_wobjfilters(obj_ud(ii).ccUD,obj_ud(ii).filters_UD,w,tl,izt,nz,nx,ny);
%     [obj_ud(ii).wql_cs_UD,~]=get_cs_fluxes_wobjfilters(obj_ud(ii).ccUD,obj_ud(ii).filters_UD,w,ql,izt,nz,nx,ny);
%     [obj_ud(ii).wqt_cs_UD,~]=get_cs_fluxes_wobjfilters(obj_ud(ii).ccUD,obj_ud(ii).filters_UD,w,qt,izt,nz,nx,ny);
    
    
%     [obj_ud(ii).ww_cs_DD,~]=get_cs_fluxes_wobjfilters(obj_ud(ii).ccDD,obj_ud(ii).filters_DD,w,w,izt,nz,nx,ny);
%     [obj_ud(ii).wtv_cs_DD,~]=get_cs_fluxes_wobjfilters(obj_ud(ii).ccDD,obj_ud(ii).filters_DD,w,tv,izt,nz,nx,ny);
%     [obj_ud(ii).wtl_cs_DD,~]=get_cs_fluxes_wobjfilters(obj_ud(ii).ccDD,obj_ud(ii).filters_DD,w,tl,izt,nz,nx,ny);
%     [obj_ud(ii).wql_cs_DD,~]=get_cs_fluxes_wobjfilters(obj_ud(ii).ccDD,obj_ud(ii).filters_DD,w,ql,izt,nz,nx,ny);
%     [obj_ud(ii).wqt_cs_DD,~]=get_cs_fluxes_wobjfilters(obj_ud(ii).ccDD,obj_ud(ii).filters_DD,w,qt,izt,nz,nx,ny);
    
end


%%
it=find(ps(ii).time==4*3600);
zm=ps(ii).zm; lw=1.3;

%% plots ww
figure('Position',[0 0 900 300]);
ip=1;
% colors=get(gca,'colororder');
colors=[0 .8 .1;1 .4 0; .4 1 .6; .6 0 1; .4 .8 1;1 .4 .6];

for ii=[5,3,1, 10,8,6, 11,9,7]
    sp(ip)=subplot(3,3,ip); 
    set(gca,'FontSize',12)
    zi=ps(ii).zi(it);
    plot(obj_ud(ii).ww_cs_UD(:,1),zm/zi,'--r','LineWidth',lw); hold on
    plot(obj_ud(ii).ww_cs_UD(:,2),zm/zi,'-.r','LineWidth',lw); hold on
    plot(obj_ud(ii).ww_cs_DD(:,1),zm/zi,'--b','LineWidth',lw); hold on
    plot(obj_ud(ii).ww_cs_DD(:,2),zm/zi,'-.b','LineWidth',lw); hold on

    plot(sum(obj_ud(ii).ww_cs_UD(:,1:2),2),zm/zi,'r','LineWidth',lw)
    plot(sum(obj_ud(ii).ww_cs_DD(:,1:2),2),zm/zi,'b','LineWidth',lw)
    plot(sum(obj_ud(ii).ww_cs_UD(:,1:2)+obj_ud(ii).ww_cs_DD(:,1:2),2),zm/zi,'g','LineWidth',lw)
%     plot(sum(obj_ud(ii).ww_cs_UD(:,:)+obj_ud(ii).ww_cs_DD(:,:),2),zm/zi,':g','LineWidth',lw)
    plot(obj_ud(ii).ww+ps(ii).ww_sfs(:,it),zm/zi,'k:','LineWidth',lw)
    ylim([0 1]); xlim([0 0.5])
    text(0.48,0.1,gnrl.mylgd{ii},'Interpreter','latex','HorizontalAlignment','right','FontSize',12);

    ip=ip+1;
end

for ip=[1:6]
    set(sp(ip),'XTickLabels',[])
end
for ip=[2,3,5,6,8,9]
    set(sp(ip),'YTickLabels',[])
end
for ip=[1,4,7]
    ylabel(sp(ip),'$z/z_i$','Interpreter','latex','FontSize',12)
end
for ip=7:9
    xlabel(sp(ip),'$w''w''(z)$ (m$^2$ s$^{-2}$)','Interpreter','latex','FontSize',12)
end
for ip=1:9
    sp(ip).FontSize=11;
end

% legend is complicated
h = zeros(8, 1);
h(1) = plot(NaN,NaN,'--r','LineWidth',lw);
h(2) = plot(NaN,NaN,'-.r','LineWidth',lw);
h(3) = plot(NaN,NaN,'r','LineWidth',lw);
h(4) = plot(NaN,NaN,'--b','LineWidth',lw);
h(5) = plot(NaN,NaN,'-.b','LineWidth',lw);
h(6) = plot(NaN,NaN,'b','LineWidth',lw);
h(7) = plot(NaN,NaN,'g','LineWidth',lw);
h(8) = plot(NaN,NaN,':k','LineWidth',lw);
lgd=legend(h,'$\rm UD^{I}$','$\rm UD^{II}$','$\rm UD^{I+II}$', ...
    '$\rm DD^{I}$','$\rm DD^{II}$','$\rm DD^{I+II}$', ...
    '$\rm UD^{I+II}+DD^{I+II}$','Total', ...
    'Location','eastoutside','Interpreter','latex','FontSize',12);

wdt=.3; hgt=.25;
x1=0.07; x2=0.38; x3=0.69;
y1=.15; y2=.44; y3=.73;
for ip=1:9; sp(ip).YLim=[0 1.05]; end
set(sp(1),'Position',[x1 y3 wdt hgt])
set(sp(2),'Position',[x2 y3 wdt hgt])
set(sp(3),'Position',[x3 y3 wdt hgt])
set(sp(4),'Position',[x1 y2 wdt hgt])
set(sp(5),'Position',[x2 y2 wdt hgt])
set(sp(6),'Position',[x3 y2 wdt hgt])
set(sp(7),'Position',[x1 y1 wdt hgt])
set(sp(8),'Position',[x2 y1 wdt hgt])
set(sp(9),'Position',[x3 y1 wdt hgt])
set(lgd,'Position',[1.2 0.3 0.15 0.4])
%
filename=['../figures/Fig_UDDDcontribution_ww'];
fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 9 3];
print(filename,'-depsc')

%% plots wtv
figure('Position',[0 0 900 300])
ip=1;
colors=get(gca,'colororder');

for ii=[5,3,1, 10,8,6, 11,9,7]
    sp(ip)=subplot(3,3,ip);
    zi=ps(ii).zi(it);
    plot(obj_ud(ii).wtv_cs_UD(:,1),zm/zi,'--r','LineWidth',lw); hold on
    plot(obj_ud(ii).wtv_cs_UD(:,2),zm/zi,'-.r','LineWidth',lw); hold on
    plot(obj_ud(ii).wtv_cs_DD(:,1),zm/zi,'--b','LineWidth',lw); hold on
    plot(obj_ud(ii).wtv_cs_DD(:,2),zm/zi,'-.b','LineWidth',lw); hold on

    plot(sum(obj_ud(ii).wtv_cs_UD(:,1:2),2),zm/zi,'r','LineWidth',lw)
    plot(sum(obj_ud(ii).wtv_cs_DD(:,1:2),2),zm/zi,'b','LineWidth',lw)
    plot(sum(obj_ud(ii).wtv_cs_UD(:,1:2)+obj_ud(ii).wtv_cs_DD(:,1:2),2),zm/zi,'g','LineWidth',lw)
    plot(obj_ud(ii).wtv+ps(ii).buoy_sfs(:,it)*289/9.81,zm/zi,'k:','LineWidth',lw)
    ylim([0 1]); xlim([-.018 .041])
%     title(gnrl.mylgd{ii},'Interpreter','latex');
    text(0.038,0.1,gnrl.mylgd{ii},'Interpreter','latex','HorizontalAlignment','right','FontSize',12);
    ip=ip+1;
end

for ip=[1:6]
    set(sp(ip),'XTickLabels',[])
end
for ip=[2,3,5,6,8,9]
    set(sp(ip),'YTickLabels',[])
end
for ip=[1,4,7]
    ylabel(sp(ip),'$z/z_i$','Interpreter','latex','FontSize',12)
end
for ip=7:9
    xticks(sp(ip),[0 0.02 0.04])
    xlabel(sp(ip),'$w''\theta_v''(z)$ (m K s$^{-1}$)','Interpreter','latex','FontSize',12)
end
for ip=1:9
    sp(ip).FontSize=11;
end

% legend is complicated
h = zeros(8, 1);
h(1) = plot(NaN,NaN,'--r','LineWidth',lw);
h(2) = plot(NaN,NaN,'-.r','LineWidth',lw);
h(3) = plot(NaN,NaN,'r','LineWidth',lw);
h(4) = plot(NaN,NaN,'--b','LineWidth',lw);
h(5) = plot(NaN,NaN,'-.b','LineWidth',lw);
h(6) = plot(NaN,NaN,'b','LineWidth',lw);
h(7) = plot(NaN,NaN,'g','LineWidth',lw);
h(8) = plot(NaN,NaN,':k','LineWidth',lw);
lgd=legend(h,'$\rm UD^{I}$','$\rm UD^{II}$','$\rm UD^{I+II}$', ...
    '$\rm DD^{I}$','$\rm DD^{II}$','$\rm DD^{I+II}$', ...
    '$\rm UD^{I+II}+DD^{I+II}$','Total', ...
    'Location','eastoutside','Interpreter','latex','FontSize',12);

wdt=.3; hgt=.25;
x1=0.07; x2=0.38; x3=0.69;
y1=.15; y2=.44; y3=.73;
for ip=1:9; sp(ip).YLim=[0 1.05]; end
set(sp(1),'Position',[x1 y3 wdt hgt])
set(sp(2),'Position',[x2 y3 wdt hgt])
set(sp(3),'Position',[x3 y3 wdt hgt])
set(sp(4),'Position',[x1 y2 wdt hgt])
set(sp(5),'Position',[x2 y2 wdt hgt])
set(sp(6),'Position',[x3 y2 wdt hgt])
set(sp(7),'Position',[x1 y1 wdt hgt])
set(sp(8),'Position',[x2 y1 wdt hgt])
set(sp(9),'Position',[x3 y1 wdt hgt])
set(lgd,'Position',[1.2 0.3 0.15 0.4])

filename=['../figures/Fig_UDDDcontribution_wtv'];
fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 9 3];
print(filename,'-depsc')

%% plots wtl
ip=1;
figure('Position',[0 0 900 300])

for ii=[5,3,1, 10,8,6, 11,9,7]
    sp(ip)=subplot(3,3,ip);
    zi=ps(ii).zi(it);
    plot(obj_ud(ii).wtl_cs_UD(:,1),zm/zi,'--r','LineWidth',lw); hold on
    plot(obj_ud(ii).wtl_cs_UD(:,2),zm/zi,'-.r','LineWidth',lw); hold on
    plot(obj_ud(ii).wtl_cs_DD(:,1),zm/zi,'--b','LineWidth',lw); hold on
    plot(obj_ud(ii).wtl_cs_DD(:,2),zm/zi,'-.b','LineWidth',lw); hold on

    plot(sum(obj_ud(ii).wtl_cs_UD(:,1:2),2),zm/zi,'r','LineWidth',lw)
    plot(sum(obj_ud(ii).wtl_cs_DD(:,1:2),2),zm/zi,'b','LineWidth',lw)
    plot(sum(obj_ud(ii).wtl_cs_UD(:,1:2)+obj_ud(ii).wtl_cs_DD(:,1:2),2),zm/zi,'g','LineWidth',lw)
    plot(obj_ud(ii).wtl+ps(ii).sfs_tw(:,it)./ps(ii).dn0/1005,zm/zi,':k')
    ylim([0 1]); xlim([-.027 .013])
    text(-0.025,0.15,gnrl.mylgd{ii},'Interpreter','latex','HorizontalAlignment','left','FontSize',12);

    ip=ip+1;
end

for ip=[1:6]
    set(sp(ip),'XTickLabels',[])
end
for ip=[2,3,5,6,8,9]
    set(sp(ip),'YTickLabels',[])
end
for ip=[1,4,7]
    ylabel(sp(ip),'$z/z_i$','Interpreter','latex','FontSize',12)
end
for ip=7:9
    xlabel(sp(ip),'$w''\theta_l''(z)$ (m K s$^{-1}$)','Interpreter','latex','FontSize',12)
    xticks(sp(ip),-0.02:0.01:0.01)
end
for ip=1:9
    sp(ip).FontSize=11;
end

% legend is complicated
h = zeros(8, 1);
h(1) = plot(NaN,NaN,'--r','LineWidth',lw);
h(2) = plot(NaN,NaN,'-.r','LineWidth',lw);
h(3) = plot(NaN,NaN,'r','LineWidth',lw);
h(4) = plot(NaN,NaN,'--b','LineWidth',lw);
h(5) = plot(NaN,NaN,'-.b','LineWidth',lw);
h(6) = plot(NaN,NaN,'b','LineWidth',lw);
h(7) = plot(NaN,NaN,'g','LineWidth',lw);
h(8) = plot(NaN,NaN,':k','LineWidth',lw);
lgd=legend(h,'$\rm UD^{I}$','$\rm UD^{II}$','$\rm UD^{I+II}$', ...
    '$\rm DD^{I}$','$\rm DD^{II}$','$\rm DD^{I+II}$', ...
    '$\rm UD^{I+II}+DD^{I+II}$','Total', ...
    'Location','eastoutside','Interpreter','latex','FontSize',12);

wdt=.3; hgt=.25;
x1=0.07; x2=0.38; x3=0.69;
y1=.15; y2=.44; y3=.73;
for ip=1:9; sp(ip).YLim=[0 1.05]; end
set(sp(1),'Position',[x1 y3 wdt hgt])
set(sp(2),'Position',[x2 y3 wdt hgt])
set(sp(3),'Position',[x3 y3 wdt hgt])
set(sp(4),'Position',[x1 y2 wdt hgt])
set(sp(5),'Position',[x2 y2 wdt hgt])
set(sp(6),'Position',[x3 y2 wdt hgt])
set(sp(7),'Position',[x1 y1 wdt hgt])
set(sp(8),'Position',[x2 y1 wdt hgt])
set(sp(9),'Position',[x3 y1 wdt hgt])
set(lgd,'Position',[1.2 0.3 0.15 0.4])

filename=['../figures/Fig_UDDDcontribution_wtl'];
fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 9 3];
print(filename,'-depsc')

%% plots wqt
ip=1;
figure('Position',[0 0 900 300])

for ii=[5,3,1, 10,8,6, 11,9,7]
    sp(ip)=subplot(3,3,ip);
    zi=ps(ii).zi(it);
    plot(1e5*obj_ud(ii).wqt_cs_UD(:,1),zm/zi,'--r','LineWidth',lw); hold on
    plot(1e5*obj_ud(ii).wqt_cs_UD(:,2),zm/zi,'-.r','LineWidth',lw); hold on
    plot(1e5*obj_ud(ii).wqt_cs_DD(:,1),zm/zi,'--b','LineWidth',lw); hold on
    plot(1e5*obj_ud(ii).wqt_cs_DD(:,2),zm/zi,'-.b','LineWidth',lw); hold on

    plot(1e5*sum(obj_ud(ii).wqt_cs_UD(:,1:2),2),zm/zi,'r','LineWidth',lw)
    plot(1e5*sum(obj_ud(ii).wqt_cs_DD(:,1:2),2),zm/zi,'b','LineWidth',lw)
    plot(1e5*sum(obj_ud(ii).wqt_cs_UD(:,1:2)+obj_ud(ii).wqt_cs_DD(:,1:2),2),zm/zi,'g','LineWidth',lw)
    plot(1e5*(obj_ud(ii).wqt+ps(ii).sfs_qw(:,it)./ps(ii).dn0/2.5e6),zm/zi,':k','LineWidth',lw)
    ylim([0 1]); xlim([0 4.5])
    text(3.8,0.15,gnrl.mylgd{ii},'Interpreter','latex','HorizontalAlignment','right','FontSize',12);
    ip=ip+1;
end

for ip=[1:6]
    set(sp(ip),'XTickLabels',[])
end
for ip=[2,3,5,6,8,9]
    set(sp(ip),'YTickLabels',[])
end
for ip=[1,4,7]
    ylabel(sp(ip),'$z/z_i$','Interpreter','latex','FontSize',12)
end
for ip=7:9
    xlabel(sp(ip),'$w''q_t''(z)$ (m s$^{-1}$) $\times 10^{-5}$','Interpreter','latex','FontSize',12)
end
for ip=1:9
    sp(ip).FontSize=11;
end

% legend is complicated
h = zeros(8, 1);
h(1) = plot(NaN,NaN,'--r','LineWidth',lw);
h(2) = plot(NaN,NaN,'-.r','LineWidth',lw);
h(3) = plot(NaN,NaN,'r','LineWidth',lw);
h(4) = plot(NaN,NaN,'--b','LineWidth',lw);
h(5) = plot(NaN,NaN,'-.b','LineWidth',lw);
h(6) = plot(NaN,NaN,'b','LineWidth',lw);
h(7) = plot(NaN,NaN,'g','LineWidth',lw);
h(8) = plot(NaN,NaN,':k','LineWidth',lw);
lgd=legend(h,'$\rm UD^{I}$','$\rm UD^{II}$','$\rm UD^{I+II}$', ...
    '$\rm DD^{I}$','$\rm DD^{II}$','$\rm DD^{I+II}$', ...
    '$\rm UD^{I+II}+DD^{I+II}$','Total', ...
    'Location','eastoutside','Interpreter','latex','FontSize',12);

wdt=.3; hgt=.25;
x1=0.07; x2=0.38; x3=0.69;
y1=.15; y2=.44; y3=.73;
for ip=1:9; sp(ip).YLim=[0 1.05]; end
set(sp(1),'Position',[x1 y3 wdt hgt])
set(sp(2),'Position',[x2 y3 wdt hgt])
set(sp(3),'Position',[x3 y3 wdt hgt])
set(sp(4),'Position',[x1 y2 wdt hgt])
set(sp(5),'Position',[x2 y2 wdt hgt])
set(sp(6),'Position',[x3 y2 wdt hgt])
set(sp(7),'Position',[x1 y1 wdt hgt])
set(sp(8),'Position',[x2 y1 wdt hgt])
set(sp(9),'Position',[x3 y1 wdt hgt])
set(lgd,'Position',[1.2 0.3 0.15 0.4])

filename=['../figures/Fig_UDDDcontribution_wqt'];
fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 9 3];
print(filename,'-depsc')

%% plots wql
% ip=1;
% colors=get(gca,'colororder');
% 
% for ii=[5,3,1, 10,8,6, 11,9,7]
%     sp(ip)=subplot(3,3,ip);
%     zi=ps(ii).zi(it);
%     for ifilter=1:6
%         plot(obj_ud(ii).wql_cs_UD(:,ifilter),zm/zi,'--','Color',colors(ifilter,:)); hold on
%         plot(obj_ud(ii).wql_cs_DD(:,ifilter),zm/zi,'-.','Color',colors(ifilter,:))
%     end
%     plot(sum(obj_ud(ii).wql_cs_UD(:,1:2)+obj_ud(ii).wql_cs_DD(:,1:2),2),zm/zi,'g')
%     plot(sum(obj_ud(ii).wql_cs_UD+obj_ud(ii).wql_cs_DD,2),zm/zi,'k')
%     ylim([.65 1.05]); xlim([0 7e-6])
%     title(gnrl.mylgd{ii},'Interpreter','latex');
% 
%     ip=ip+1;
% end
% 
% 
% for ip=[1,4,7]
%     ylabel(sp(ip),'$z/z_i$','Interpreter','latex')
% end
% for ip=7:9
%     xlabel(sp(ip),'$w''q_l''(z)$ (m s$^{-1}$)','Interpreter','latex')
% end
% 
% % legend is complicated
% h = zeros(10, 1);
% h(1) = plot(NaN,NaN,'--','Color',[.5 .5 .5]);
% h(2) = plot(NaN,NaN,'-.','Color',[.5 .5 .5]);
% for i=3:8
% h(i) = plot(NaN,NaN,'Color',colors(i-2,:));
% end
% h(9) = plot(NaN,NaN,'g');
% h(10) = plot(NaN,NaN,'k');
% lgd=legend(h,'UD','DD','I','II','III','IV','V','VI', ...
%     'I+II','Total', ...
%     'Location','eastoutside','Interpreter','latex','FontSize',10);
% 
% wdt=.22; hgt=.23;
% x1=0.07; x2=0.33; x3=0.59;
% y1=.09; y2=.4; y3=.71;
% set(sp(1),'Position',[x1 y3 wdt hgt])
% set(sp(2),'Position',[x2 y3 wdt hgt])
% set(sp(3),'Position',[x3 y3 wdt hgt])
% set(sp(4),'Position',[x1 y2 wdt hgt])
% set(sp(5),'Position',[x2 y2 wdt hgt])
% set(sp(6),'Position',[x3 y2 wdt hgt])
% set(sp(7),'Position',[x1 y1 wdt hgt])
% set(sp(8),'Position',[x2 y1 wdt hgt])
% set(sp(9),'Position',[x3 y1 wdt hgt])
% set(lgd,'Position',[0.83 0.3 0.15 0.4])
% 
% filename=['../figures/Fig_UDDDcontribution_wql'];
% fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 8 4];
% print(filename,'-depsc')

%% plots wr (momentum flux)
figure('Position',[0 0 600 200])
ip=1;
colors=get(gca,'colororder');

for ii=[5,1, 10,6, 11,7] %[5,3,1, 10,8,6, 11,9,7]
    sp(ip)=subplot(3,2,ip);
    zi=ps(ii).zi(it);
    plot(sqrt(obj_ud(ii).wu_cs_UD(:,1).^2+obj_ud(ii).wv_cs_UD(:,1).^2),zm/zi,'--r','LineWidth',lw); hold on
    plot(sqrt(obj_ud(ii).wu_cs_UD(:,2).^2+obj_ud(ii).wv_cs_UD(:,2).^2),zm/zi,'-.r','LineWidth',lw); hold on
    plot(sqrt(obj_ud(ii).wu_cs_DD(:,1).^2+obj_ud(ii).wv_cs_DD(:,1).^2),zm/zi,'--b','LineWidth',lw); hold on
    plot(sqrt(obj_ud(ii).wu_cs_DD(:,2).^2+obj_ud(ii).wv_cs_DD(:,2).^2),zm/zi,'-.b','LineWidth',lw); hold on
    wr_UD_I_II=sqrt(sum(obj_ud(ii).wu_cs_UD(:,1:2),2).^2+sum(obj_ud(ii).wv_cs_UD(:,1:2),2).^2);
    plot(wr_UD_I_II,zm/zi,'r','LineWidth',lw)
    wr_DD_I_II=sqrt(sum(obj_ud(ii).wu_cs_DD(:,1:2),2).^2+sum(obj_ud(ii).wv_cs_DD(:,1:2),2).^2);
    plot(wr_DD_I_II,zm/zi,'b','LineWidth',lw)

    %plot(sum(obj_ud(ii).wr_cs_UD(:,1:2)+obj_ud(ii).wr_cs_DD(:,1:2),2),zm/zi,'g','LineWidth',lw)
    wr_I_II=wr_UD_I_II+wr_DD_I_II;
%     sqrt(sum(obj_ud(ii).wu_cs_UD(:,1:2)+obj_ud(ii).wu_cs_DD(:,1:2),2).^2 + ...
%         sum(obj_ud(ii).wv_cs_UD(:,1:2)+obj_ud(ii).wv_cs_DD(:,1:2),2).^2);
    plot(wr_I_II,zm/zi,'g','LineWidth',lw)
    wr_total=sqrt((obj_ud(ii).wu+ps(ii).sfs_uw(:,it)).^2+ ...
        (obj_ud(ii).wv+ps(ii).sfs_vw(:,it)).^2);
    plot(wr_total,zm/zi,'k:','LineWidth',lw)
    ylim([0 1]); xlim([0 .09])
%     title(gnrl.mylgd{ii},'Interpreter','latex');
    text(0.085,0.15,gnrl.mylgd{ii},'Interpreter','latex','HorizontalAlignment','right','FontSize',12);
    ip=ip+1;
end

%%
for ip=[1:6]
    set(sp(ip),'XTickLabels',[])
end
for ip=[2,3,5,6,8,9]
    set(sp(ip),'YTickLabels',[])
end
for ip=[1,4,7]
    ylabel(sp(ip),'$z/z_i$','Interpreter','latex','FontSize',12)
end
for ip=7:9
    xlabel(sp(ip),'$F_r(z)$ (m$^{2}$ s$^{-2}$)','Interpreter','latex','FontSize',12)
end
for ip=1:9
    sp(ip).FontSize=11;
end

% legend is complicated
h = zeros(8, 1);
h(1) = plot(NaN,NaN,'--r','LineWidth',lw);
h(2) = plot(NaN,NaN,'-.r','LineWidth',lw);
h(3) = plot(NaN,NaN,'r','LineWidth',lw);
h(4) = plot(NaN,NaN,'--b','LineWidth',lw);
h(5) = plot(NaN,NaN,'-.b','LineWidth',lw);
h(6) = plot(NaN,NaN,'b','LineWidth',lw);
h(7) = plot(NaN,NaN,'g','LineWidth',lw);
h(8) = plot(NaN,NaN,':k','LineWidth',lw);
lgd=legend(h,'$\rm UD^{I}$','$\rm UD^{II}$','$\rm UD^{I+II}$', ...
    '$\rm DD^{I}$','$\rm DD^{II}$','$\rm DD^{I+II}$', ...
    '$\rm UD^{I+II}+DD^{I+II}$','Total', ...
    'Location','eastoutside','Interpreter','latex','FontSize',12);

wdt=.3; hgt=.25;
x1=0.07; x2=0.38; x3=0.69;
y1=.15; y2=.44; y3=.73;
for ip=1:9; sp(ip).YLim=[0 1.05]; end
set(sp(1),'Position',[x1 y3 wdt hgt])
set(sp(2),'Position',[x2 y3 wdt hgt])
set(sp(3),'Position',[x3 y3 wdt hgt])
set(sp(4),'Position',[x1 y2 wdt hgt])
set(sp(5),'Position',[x2 y2 wdt hgt])
set(sp(6),'Position',[x3 y2 wdt hgt])
set(sp(7),'Position',[x1 y1 wdt hgt])
set(sp(8),'Position',[x2 y1 wdt hgt])
set(sp(9),'Position',[x3 y1 wdt hgt])
set(lgd,'Position',[1.2 0.3 0.15 0.4])

filename=['../figures/Fig_UDDDcontribution_wr'];
fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 9 3];
print(filename,'-depsc')

%% fractions
fracmax=1.3;
for ii=1:11
    InII=sum(obj_ud(ii).ww_cs_UD(:,1:2)+obj_ud(ii).ww_cs_DD(:,1:2),2);
    ItoVI=sum(obj_ud(ii).ww_cs_UD(:,:)+obj_ud(ii).ww_cs_DD(:,:),2);
    total=obj_ud(ii).ww+ps(ii).ww_sfs(:,it);
    frac1=InII./ItoVI; frac1(frac1>fracmax)=nan;
    frac2=InII./total; frac2(frac2>fracmax)=nan;
    fracofUDDD_ww(ii)=nanmean(frac1(1:ps3d(ii,time).nql_izt))
    fracoftotal_ww(ii)=nanmean(frac2(1:ps3d(ii,time).nql_izt))
    
    InII=sum(obj_ud(ii).wtv_cs_UD(:,1:2)+obj_ud(ii).wtv_cs_DD(:,1:2),2);
    ItoVI=sum(obj_ud(ii).wtv_cs_UD(:,:)+obj_ud(ii).wtv_cs_DD(:,:),2);
    total=obj_ud(ii).wtv+ps(ii).buoy_sfs(:,it)*289/9.81;
    frac1=InII./ItoVI; frac1(abs(frac1)>fracmax)=nan;
    frac2=InII./total; frac2(abs(frac2)>fracmax)=nan;
    fracofUDDD_wtv(ii)=nanmean(frac1(1:ps3d(ii,time).nql_izt))
    fracoftotal_wtv(ii)=nanmean(frac2(1:ps3d(ii,time).nql_izt))
    
    InII=sum(obj_ud(ii).wqt_cs_UD(:,1:2)+obj_ud(ii).wqt_cs_DD(:,1:2),2);
    ItoVI=sum(obj_ud(ii).wqt_cs_UD(:,:)+obj_ud(ii).wqt_cs_DD(:,:),2);
    total=obj_ud(ii).wqt+ps(ii).sfs_qw(:,it)./ps(ii).dn0/2.5e6;
    frac1=InII./ItoVI; frac1(frac1>fracmax)=nan;
    frac2=InII./total; frac2(frac2>fracmax)=nan;
    fracofUDDD_wqt(ii)=nanmean(frac1(1:ps3d(ii,time).nql_izt))
    fracoftotal_wqt(ii)=nanmean(frac2(1:ps3d(ii,time).nql_izt))
    
    InII=sum(obj_ud(ii).wtl_cs_UD(:,1:2)+obj_ud(ii).wtl_cs_DD(:,1:2),2);
    ItoVI=sum(obj_ud(ii).wtl_cs_UD(:,:)+obj_ud(ii).wtl_cs_DD(:,:),2);
    total=obj_ud(ii).wtl+ps(ii).sfs_tw(:,it);
    frac1=InII./ItoVI; frac1(abs(frac1)>fracmax)=nan;
    frac2=InII./total; frac2(abs(frac2)>fracmax)=nan;
    fracofUDDD_wtl(ii)=nanmean(frac1(1:ps3d(ii,time).nql_izt))
    fracoftotal_wtl(ii)=nanmean(frac2(1:ps3d(ii,time).nql_izt))
    
    InIIu=sum(obj_ud(ii).wu_cs_UD(:,1:2)+obj_ud(ii).wu_cs_DD(:,1:2),2);
    InIIv=sum(obj_ud(ii).wv_cs_UD(:,1:2)+obj_ud(ii).wv_cs_DD(:,1:2),2);
    InII=sqrt(InIIu.^2+InIIv.^2);
    ItoVIu=sum(obj_ud(ii).wu_cs_UD(:,:)+obj_ud(ii).wu_cs_DD(:,:),2);
    ItoVIv=sum(obj_ud(ii).wv_cs_UD(:,:)+obj_ud(ii).wv_cs_DD(:,:),2);
    ItoVI=sqrt(ItoVIu.^2+ItoVIv.^2);
    totalu=obj_ud(ii).wu+ps(ii).sfs_uw(:,it);
    totalv=obj_ud(ii).wv+ps(ii).sfs_vw(:,it);
    total=sqrt(totalu.^2+totalv.^2);
    
    wr_I_II=sqrt(sum(obj_ud(ii).wu_cs_UD(:,1:2)+obj_ud(ii).wu_cs_DD(:,1:2),2).^2 + ...
        sum(obj_ud(ii).wv_cs_UD(:,1:2)+obj_ud(ii).wv_cs_DD(:,1:2),2).^2);
    plot(wr_I_II,zm/zi,'g','LineWidth',lw)
    wr_total=sqrt((sum(obj_ud(ii).wu_cs_UD+obj_ud(ii).wu_cs_DD,2)+ps(ii).sfs_uw(:,it)).^2+ ...
        (sum(obj_ud(ii).wv_cs_UD+obj_ud(ii).wv_cs_DD,2)+ps(ii).sfs_vw(:,it)).^2);
    
    frac1=InII./ItoVI; frac1(abs(frac1)>fracmax)=nan;
    frac2=InII./total; frac2(abs(frac2)>fracmax)=nan;
    fracofUDDD_wr(ii)=nanmean(frac1(1:ps3d(ii,time).nql_izt))
    fracoftotal_wr(ii)=nanmean(frac2(1:ps3d(ii,time).nql_izt))
end

subplot(122)
plot(1:11,fracoftotal_ww,1:11,fracoftotal_wqt,1:11,fracoftotal_wtv,1:11,fracoftotal_wtl,1:11,fracoftotal_wr)
xticks(1:11)
xticklabels(gnrl.mylgd)
xtickangle(45)
ylabel('Fraction of I+II over total flux','Interpreter','latex')
legend('$R_{w''w''}$','$R_{w''q_t''}$','$R_{w''\theta_v''}$','$R_{w''\theta_l''}$','$R_{F_r}$','Interpreter','latex')

subplot(121)
plot(1:11,fracofUDDD_ww,1:11,fracofUDDD_wqt,1:11,fracofUDDD_wtv,1:11,fracofUDDD_wtl,1:11,fracofUDDD_wr)
xticks(1:11)
xticklabels(gnrl.mylgd)
xtickangle(45)
ylabel('Fraction of I+II over total UD+DD flux','Interpreter','latex')
legend('$R_{w''w''}$','$R_{w''q_t''}$','$R_{w''\theta_v''}$','$R_{w''\theta_l''}$','$R_{F_r}$','Interpreter','latex')
%%
fig=gcf;
fig.PaperUnits='inches';
fig.PaperPosition=[0 0 6 3];
print('../figures/Fig_turbfluxfraction','-depsc','-r600'); %close(1);
