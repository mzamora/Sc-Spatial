%% threshold dependence plot
ii=1; % ctrl case
it=find(ps(ii).time==4*3600);
epss=[0.8 .9 1 1.1 1.2];
for ieps=1:5
    izt=ps3d(ii).nql_izt;
    totwtv(:,ieps)=obj_ud_eps(ieps).wtv(1:izt)+ps(ii).buoy_sfs(1:izt,it)*289/9.81;
    Rwtv_UD(:,ieps)=sum(obj_ud_eps(ieps).wtv_cs_UD(1:izt,1:2),2)./totwtv(:,ieps); 
    Rwtv_DD(:,ieps)=sum(obj_ud_eps(ieps).wtv_cs_DD(1:izt,1:2),2)./totwtv(:,ieps);
end
Rwtv_UD_avg=nanmean(Rwtv_UD);
Rwtv_DD_avg=nanmean(Rwtv_DD);

subplot(131); plot(Rwtv_UD,zm(1:izt))
subplot(132); plot(Rwtv_DD,zm(1:izt))
subplot(133); plot(Rwtv_UD+Rwtv_DD,zm(1:izt))

%%
for ieps=1:5
    izt=ps3d(ii).nql_izt;
    totww(:,ieps)=obj_ud_eps(ieps).ww(1:izt)+ps(ii).ww_sfs(1:izt,it);
    Rww_UD(:,ieps)=sum(obj_ud_eps(ieps).ww_cs_UD(1:izt,1:2),2)./totww(:,ieps); 
    Rww_DD(:,ieps)=sum(obj_ud_eps(ieps).ww_cs_DD(1:izt,1:2),2)./totww(:,ieps); 
end
Rww_UD_avg=nanmean(Rww_UD);
Rww_DD_avg=nanmean(Rww_DD);

subplot(131); plot(Rww_UD,zm(1:izt))
subplot(132); plot(Rww_DD,zm(1:izt))
subplot(133); plot(Rww_UD+Rww_DD,zm(1:izt))

%% tl
for ieps=1:5
    izt=ps3d(ii).nql_izt;
    totwtl(:,ieps)=obj_ud_eps(ieps).wtl(1:izt)+ps(ii).sfs_tw(1:izt,it)./ps(ii).dn0(1:izt)/1005;
    Rwtl_UD(:,ieps)=sum(obj_ud_eps(ieps).wtl_cs_UD(1:izt,1:2),2)./totwtl(:,ieps); 
    Rwtl_DD(:,ieps)=sum(obj_ud_eps(ieps).wtl_cs_DD(1:izt,1:2),2)./totwtl(:,ieps); 
end
Rwtl_UD_avg=nanmean(Rwtl_UD(abs(Rwtl_UD)<100));
Rwtl_DD_avg=nanmean(Rwtl_DD(abs(Rwtl_DD)<100));

subplot(131); plot(Rwtl_UD,zm(1:izt)); xlim([-2 2])
subplot(132); plot(Rwtl_DD,zm(1:izt)); xlim([-2 2])
subplot(133); plot(Rwtl_UD+Rwtl_DD,zm(1:izt)); xlim([-2 2])

%% qt
for ieps=1:5
    izt=ps3d(ii).nql_izt;
    totwqt(:,ieps)=obj_ud(ii).wqt(1:izt)+ps(ii).sfs_qw(1:izt,it)./ps(ii).dn0(1:izt)/2.5e6;
    Rwqt_UD(:,ieps)=sum(obj_ud_eps(ieps).wqt_cs_UD(1:izt,1:2),2)./totwqt(:,ieps); 
    Rwqt_DD(:,ieps)=sum(obj_ud_eps(ieps).wqt_cs_DD(1:izt,1:2),2)./totwqt(:,ieps); 
end
Rwqt_UD_avg=nanmean(Rwqt_UD);
Rwqt_DD_avg=nanmean(Rwqt_DD);

subplot(131); plot(Rwqt_UD,zm(1:izt))
subplot(132); plot(Rwqt_DD,zm(1:izt))
subplot(133); plot(Rwqt_UD+Rwqt_DD,zm(1:izt))


%%
figure('Position',[0 0 800 300])
sp1=subplot(121); plot(epss,Rww_DD_avg,'.-',epss,Rww_UD_avg,'.-',epss,Rww_UD_avg+Rww_DD_avg,'.-')
xlabel('$\epsilon$','Interpreter','latex'); ylabel('$R_{w''w''}$','Interpreter','latex'); 
set(gca,'FontSize',12)
sp2=subplot(122); plot(epss,Rwtv_DD_avg,'.-',epss,Rwtv_UD_avg,'.-',epss,Rwtv_UD_avg+Rwtv_DD_avg,'.-')
xlabel('$\epsilon$','Interpreter','latex'); ylabel('$R_{w''\theta_v''}$','Interpreter','latex'); 
set(gca,'FontSize',12)
lgd=legend('$\rm UD^I+UD^{II}$','$\rm DD^I+DD^{II}$','All $\rm I+II$','Interpreter','latex','Location','eastoutside','FontSize',12);

lgd.Position=[.78 .47 .2 .1];
sp1.Position=[.1 .2 .28 .75];
sp2.Position=[.48 .2 .28 .75];
%%
filename=['../figures/Fig_epsilondependence'];
fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 8 3];
print(filename,'-depsc')
