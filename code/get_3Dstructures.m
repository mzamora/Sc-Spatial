for time=45:60 %hr 4
time
for ii=gnrl.numcases:-1:1
    ii
    % load 3D data
    casename=base(ii).name;
    filename=[casename(1:end-4),'hr3_4/'];
    var3d={'w','u','v','tl','tv','qt','ql','LWP'};
    for ivar=1:length(var3d)
        load([filename,'rf01_',var3d{ivar},num2str(time,'%02i')])
    end
    load([filename,'rf01_zm'])
    load([filename,'rf01_xm'])
    load([filename,'rf01_ym'])
    
    %% find levels when cloud starts, maxes and ends
    nz=size(ql,1); %z levels
    nx=size(ql,2); ny=size(ql,3);
    nql=zeros(1,nz); %cloud pixel fraction
    for iz=1:nz
        qlxy=squeeze(ql(iz,:,:)); %ql in the plane
        nql(iz)=sum(sum(qlxy>0))/(size(qlxy,1)*size(qlxy,2));
    end

    izb=find(nql>0,1,'first'); %min base cloud
    izt=find(nql>0,1,'last'); %max top cloud
    [~,iz_nqlmax]=max(nql); %level of max cloud fraction
    % they are also in ps3d(ii)
    
    %% get mean wind speed profile for future orientations
    [u_z,v_z,winddir_z,sheardir_z]=get_mean_windspeed_z(u,v,w,izt,zm);
    ps3d(ii,time).u_zhr4=u_z;
    ps3d(ii,time).v_zhr4=v_z;    
    ps3d(ii,time).winddir_zhr4=winddir_z;
    ps3d(ii,time).sheardir_zhr4=sheardir_z;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%                    3D objects                          %%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% ql 3D objects?
    outpref=['../out/',gnrl.mylgd{ii},'_structures/3D_p50/'];
    if ~exist(outpref,'dir'); mkdir(outpref); end
    obj_ql(ii)=segmentation_3d_ql(ql,zm,xm,ym,izb,izt,outpref,time,winddir_z,u_z,v_z,iz_nqlmax,w,tv,tl,qt,ps(ii));
    obj_qlw(ii)=segmentation_3d_qlw(ql,zm,xm,ym,izb,izt,outpref,time,winddir_z,u_z,v_z,iz_nqlmax,w,tv,tl,qt,ps(ii));

    %% updraft 3D objects?
    outpref=['../out/',gnrl.mylgd{ii},'_structures/3D_UDDD/'];
    if ~exist(outpref,'dir'); mkdir(outpref); end
    obj_ud(ii)=segmentation_3d_updrafts_downdrafts(w,zm,xm,ym,izb,izt,outpref,time,tv,qt,tl,ql,u,v);
    
%     %% buoyancy 3D objects?
%     outpref=['../out',casename(6:end),'_structures/buoyancy/'];
%     if ~exist(outpref,'dir'); mkdir(outpref); end
%     obj_tv(ii)=segmentation_3d_buoyancy(w,zm,xm,ym,izb,izt,outpref,time,tv,qt,tl,ql);
    
end
%% skip and load results
outpref=['../out/'];
save([outpref,'objects_time_',num2str(time)],'obj_ql','obj_ud')
% load([outpref,'objects_gaussianr2n3'])
end

%% comparisons
figure('Position',[0 0 900 500])
fs=12;
hr=4;
it=find(ps(ii).time==3600*hr);
sp1=subplot(231);
for ii=1:11
    totww=obj_ud(ii).ww+ps(ii).ww_sfs(:,it);
    plot(totww,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]);
xlabel('Total $w''w''$ (m$^{2}$ s$^{-2}$)','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'a)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp2=subplot(232);
for ii=1:11
    totww=obj_ud(ii).ww+ps(ii).ww_sfs(:,it);
    plot((obj_ud(ii).ww_UD+obj_ud(ii).ww_DD)./totww,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color);     hold on
end
ylim([0 1]);
xlabel('Large UD+DD fraction of $w''w''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'b)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp3=subplot(233);
for ii=1:11
    totww=obj_ud(ii).ww+ps(ii).ww_sfs(:,it);
    plot(obj_ud(ii).ww_res./totww,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]);
xlabel('Residual fraction of $w''w''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'c)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
% lgd=legend(gnrl.mylgd,'Interpreter','latex','fontsize',fs,'Location','eastoutside');

sp4=subplot(234);
for ii=1:11
    totwtv=obj_ud(ii).wtv+ps(ii).buoy_sfs(:,it);
    plot(totwtv,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]);
xlabel('Total $w''\theta_v''$ (m K s$^{-1}$)','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'d)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp5=subplot(235);
for ii=1:11
    totwtv=obj_ud(ii).wtv+ps(ii).buoy_sfs(:,it);
    plot((obj_ud(ii).wtv_UD+obj_ud(ii).wtv_DD)./totwtv,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color);     hold on
end
ylim([0 1]); xlim([.3 1.2])
xlabel('Large UD+DD fraction of $w''\theta_v''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'e)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp6=subplot(236);
for ii=1:11
    totwtv=obj_ud(ii).wtv+ps(ii).buoy_sfs(:,it);
    plot(obj_ud(ii).wtv_res./totwtv,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]); xlim([-.2 .6])
xlabel('Residual fraction of $w''\theta_v''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'f)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
lgd=legend(gnrl.mylgd,'Interpreter','latex','fontsize',fs,'Location','eastoutside');

h1=.35; y1=.1; y2=.6;
w1=.21; x1=.07; x2=.35; x3=.63;
set(sp1,'Position',[x1 y2 w1 h1])
set(sp2,'Position',[x2 y2 w1 h1])
set(sp3,'Position',[x3 y2 w1 h1])
set(sp4,'Position',[x1 y1 w1 h1])
set(sp5,'Position',[x2 y1 w1 h1])
set(sp6,'Position',[x3 y1 w1 h1])
lgd.Position=[.85 .3 .13 .44];

fig=gcf;
fig.PaperUnits='inches';
fig.PaperPosition=[0 0 9 5];
% print('../figures/Fig_objud_res1','-depsc','-r600'); %close(1);
%% comparisons 2 (wtl and wqt)
figure('Position',[0 0 900 500])
fs=12;
hr=4;
it=find(ps(ii).time==3600*hr);
sp1=subplot(231);
for ii=1:11
    totwtl=obj_ud(ii).wtl+ps(ii).sfs_tw(:,it)./ps(ii).dn0./1005;
    plot(totwtl,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]);
xlabel('Total $w''\theta_l''$ (m K s$^{-1}$)','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'a)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp2=subplot(232);
for ii=1:11
    totwtl=obj_ud(ii).wtl+ps(ii).sfs_tw(:,it)./ps(ii).dn0./1005;
    plot((obj_ud(ii).wtl_UD+obj_ud(ii).wtl_DD)./totwtl,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color);     hold on
end
ylim([0 1]); xlim([-10 10])
xlabel('$\rm UD^I+DD^I$ fraction of $w''\theta_l''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'b)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp3=subplot(233);
for ii=1:11
    totwtl=obj_ud(ii).wtl+ps(ii).sfs_tw(:,it)./ps(ii).dn0./1005;
    plot(obj_ud(ii).wtl_res./totwtl,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]);
xlabel('Residual fraction of $w''\theta_l''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'c)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
% lgd=legend(gnrl.mylgd,'Interpreter','latex','fontsize',fs,'Location','eastoutside');

sp4=subplot(234);
for ii=1:11
    totwqt=obj_ud(ii).wqt+ps(ii).sfs_qw(:,it)./ps(ii).dn0./2.5e6;
    plot(totwqt,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]);
xlabel('Total $w''q_t''$ (m s$^{-1}$)','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'d)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp5=subplot(235);
for ii=1:11
    totwqt=obj_ud(ii).wqt+ps(ii).sfs_qw(:,it)./ps(ii).dn0./2.5e6;
    plot((obj_ud(ii).wqt_UD+obj_ud(ii).wqt_DD)./totwqt,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color);     hold on
end
ylim([0 1]); %xlim([.3 1.2])
xlabel('$\rm UD^I+DD^I$ fraction of $w''q_t''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'e)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp6=subplot(236);
for ii=1:11
    totwqt=obj_ud(ii).wqt+ps(ii).sfs_qw(:,it)./ps(ii).dn0./2.5e6;
    plot(obj_ud(ii).wqt_res./totwqt,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]); %xlim([-.2 .6])
xlabel('Residual fraction of $w''q_t''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'f)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
lgd=legend(gnrl.mylgd,'Interpreter','latex','fontsize',fs,'Location','eastoutside');

h1=.35; y1=.1; y2=.6;
w1=.21; x1=.07; x2=.35; x3=.63;
set(sp1,'Position',[x1 y2 w1 h1])
set(sp2,'Position',[x2 y2 w1 h1])
set(sp3,'Position',[x3 y2 w1 h1])
set(sp4,'Position',[x1 y1 w1 h1])
set(sp5,'Position',[x2 y1 w1 h1])
set(sp6,'Position',[x3 y1 w1 h1])
lgd.Position=[.85 .3 .13 .44];

fig=gcf;
fig.PaperUnits='inches';
fig.PaperPosition=[0 0 9 5];
print('../figures/Fig_objud_res2','-depsc','-r600'); %close(1);

%% are updrafts-DD faster for 000U?
nx=length(xm); ny=length(ym);
for ii=9:-1:1
    casename=base(ii).name;  filename=[casename(1:end-4),'hr3_4/'];
    var3d={'w','u','v','tl','tv','qt','ql','LWP'};
    for ivar=1:length(var3d)
        load([filename,'rf01_',var3d{ivar},num2str(time,'%02i')])
    end
    nz=length(ps(ii).zm); it=find(ps(ii).time==4*3600);
    
    obj_ud(ii).meanw_UD=get_cs_meanvar_wobjfilters(obj_ud(ii).ccUD,obj_ud(ii).filters_UD,w,ps3d(ii).nql_izt,nz,nx,ny,ps(ii),it,'r');
    obj_ud(ii).meanw_DD=get_cs_meanvar_wobjfilters(obj_ud(ii).ccDD,obj_ud(ii).filters_DD,w,ps3d(ii).nql_izt,nz,nx,ny,ps(ii),it,'b');
    for ip=1:6; subplot(2,3,ip); ylim([0 1]); xlim([-2 2]); end
    subplot(231); ylabel('$z/z_i$','Interpreter','latex');
    subplot(234); xlabel('$w''$ (m s$^{-1}$)','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex');
    subplot(235); xlabel('$w''$ (m s$^{-1}$)','Interpreter','latex');
    subplot(236); xlabel('$w''$ (m s$^{-1}$)','Interpreter','latex');
    print(['../out/check_obj_meanw',num2str(ii,'%02i')],'-depsc'); close(1)
    
    obj_ud(ii).meantv_UD=get_cs_meanvar_wobjfilters(obj_ud(ii).ccUD,obj_ud(ii).filters_UD,tv,ps3d(ii).nql_izt,nz,nx,ny,ps(ii),it,'r');
    obj_ud(ii).meantv_DD=get_cs_meanvar_wobjfilters(obj_ud(ii).ccDD,obj_ud(ii).filters_DD,tv,ps3d(ii).nql_izt,nz,nx,ny,ps(ii),it,'b');
    for ip=1:6; subplot(2,3,ip); ylim([0 1]); xlim([-3 2]); end
    subplot(231); ylabel('$z/z_i$','Interpreter','latex');
    subplot(234); xlabel('$\theta_v''$ (K)','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex');
    subplot(235); xlabel('$\theta_v''$ (K)','Interpreter','latex');
    subplot(236); xlabel('$\theta_v''$ (K)','Interpreter','latex');
    print(['../out/check_obj_meantv',num2str(ii,'%02i')],'-depsc'); close(1)

    obj_ud(ii).meanqt_UD=get_cs_meanvar_wobjfilters(obj_ud(ii).ccUD,obj_ud(ii).filters_UD,qt,ps3d(ii).nql_izt,nz,nx,ny,ps(ii),it,'r');
    obj_ud(ii).meanqt_DD=get_cs_meanvar_wobjfilters(obj_ud(ii).ccDD,obj_ud(ii).filters_DD,qt,ps3d(ii).nql_izt,nz,nx,ny,ps(ii),it,'b');
    for ip=1:6; subplot(2,3,ip); ylim([0 1]); xlim([-2 3.5]*1e-3); end
    subplot(231); ylabel('$z/z_i$','Interpreter','latex');
    subplot(234); xlabel('$q_t''$ (kg kg$^{-1}$)','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex');
    subplot(235); xlabel('$q_t''$ (kg kg$^{-1}$)','Interpreter','latex');
    subplot(236); xlabel('$q_t''$ (kg kg$^{-1}$)','Interpreter','latex');
    print(['../out/check_obj_meanqt',num2str(ii,'%02i')],'-depsc'); close(1)
    
    obj_ud(ii).meantl_UD=get_cs_meanvar_wobjfilters(obj_ud(ii).ccUD,obj_ud(ii).filters_UD,tl,ps3d(ii).nql_izt,nz,nx,ny,ps(ii),it,'r');
    obj_ud(ii).meantl_DD=get_cs_meanvar_wobjfilters(obj_ud(ii).ccDD,obj_ud(ii).filters_DD,tl,ps3d(ii).nql_izt,nz,nx,ny,ps(ii),it,'b');
    for ip=1:6; subplot(2,3,ip); ylim([0 1]); xlim([-4 3]); end
    subplot(231); ylabel('$z/z_i$','Interpreter','latex');
    subplot(234); xlabel('$\theta_l''$ (K)','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex');
    subplot(235); xlabel('$\theta_l''$ (K)','Interpreter','latex');
    subplot(236); xlabel('$\theta_l''$ (K)','Interpreter','latex');
    print(['../out/check_obj_meantl',num2str(ii,'%02i')],'-depsc'); close(1)

    obj_ud(ii).meanql_UD=get_cs_meanvar_wobjfilters(obj_ud(ii).ccUD,obj_ud(ii).filters_UD,ql,ps3d(ii).nql_izt,nz,nx,ny,ps(ii),it,'r');
    obj_ud(ii).meanql_DD=get_cs_meanvar_wobjfilters(obj_ud(ii).ccDD,obj_ud(ii).filters_DD,ql,ps3d(ii).nql_izt,nz,nx,ny,ps(ii),it,'b');
    for ip=1:6; subplot(2,3,ip); ylim([0 1]); xlim([-3 5]*1e-4); end
    subplot(231); ylabel('$z/z_i$','Interpreter','latex');
    subplot(234); xlabel('$q_l''$ (g kg$^{-1}$)','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex');
    subplot(235); xlabel('$q_l''$ (g kg$^{-1}$)','Interpreter','latex');
    subplot(236); xlabel('$q_l''$ (g kg$^{-1}$)','Interpreter','latex');
    print(['../out/check_obj_meanql',num2str(ii,'%02i')],'-depsc'); close(1)
end

%% are updrafts more well mixed 
nx=length(xm); ny=length(ym);
for ii=11:-1:1
    casename=base(ii).name;  filename=[casename(1:end-4),'hr3_4/'];
    var3d={'tl','qt'}; %{'w','u','v','tl','tv','qt','ql','LWP'};
    for ivar=1:length(var3d)
        load([filename,'rf01_',var3d{ivar},num2str(time,'%02i')])
    end
    nz=length(ps(ii).zm); it=find(ps(ii).time==4*3600);
    
    [out(ii).meantl_UD,out(ii).meantl_UD_perobj]=get_cs_meanvar_wobjfilters(obj_ud(ii).ccUD,obj_ud(ii).filters_UD,tl,ps3d(ii).nql_izt,nz,nx,ny,ps(ii),it,'r');
    [out(ii).meantl_DD,out(ii).meantl_DD_perobj]=get_cs_meanvar_wobjfilters(obj_ud(ii).ccDD,obj_ud(ii).filters_DD,tl,ps3d(ii).nql_izt,nz,nx,ny,ps(ii),it,'b');
%     for ip=1:6; subplot(2,3,ip); ylim([0 1]); xlim([-2 2]); end
%     subplot(231); ylabel('$z/z_i$','Interpreter','latex');
%     subplot(234); xlabel('$\theta_l''$ (K)','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex');
%     subplot(235); xlabel('$\theta_l''$ (K)','Interpreter','latex');
%     subplot(236); xlabel('$\theta_l''$ (K)','Interpreter','latex');
%     savefig(['../out/check_obj_tl',num2str(ii,'%02i')]); close(1)
    
    [out(ii).meanqt_UD,out(ii).meanqt_UD_perobj]=get_cs_meanvar_wobjfilters(obj_ud(ii).ccUD,obj_ud(ii).filters_UD,qt,ps3d(ii).nql_izt,nz,nx,ny,ps(ii),it,'r');
    [out(ii).meanqt_DD,out(ii).meanqt_DD_perobj]=get_cs_meanvar_wobjfilters(obj_ud(ii).ccDD,obj_ud(ii).filters_DD,qt,ps3d(ii).nql_izt,nz,nx,ny,ps(ii),it,'b');
%     for ip=1:6; subplot(2,3,ip); ylim([0 1]); xlim([-3 2]); end
%     subplot(231); ylabel('$z/z_i$','Interpreter','latex');
%     subplot(234); xlabel('$q_t''$ (g/kg)','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex');
%     subplot(235); xlabel('$q_t''$ (g/kg)','Interpreter','latex');
%     subplot(236); xlabel('$q_t''$ (g/kg)','Interpreter','latex');
%     savefig(['../out/check_obj_qt',num2str(ii,'%02i')]); close(1)

end
%%
it=find(ps(ii).time==3600*4)
subplot(141); plot(out(1).meantl_UD(:,1),zm,out(1).meantl_DD(:,1),zm,ps(1).tl(:,it),zm,'g--'); xlim([289.3 289.6])
title(gnrl.mylgd{1})
subplot(142); plot(out(5).meantl_UD(:,1),zm,out(5).meantl_DD(:,1),zm,ps(5).tl(:,it),zm,'g--'); xlim([289.3 289.6])
title(gnrl.mylgd{5})
subplot(143); plot(out(11).meantl_UD(:,1),zm,out(11).meantl_DD(:,1),zm,ps(11).tl(:,it),zm,'g--'); xlim([289.3 289.6])
title(gnrl.mylgd{11})
subplot(144); plot(out(7).meantl_UD(:,1),zm,out(7).meantl_DD(:,1),zm,ps(7).tl(:,it),zm,'g--'); xlim([289.3 289.6])
title(gnrl.mylgd{7})

%%

it=find(ps(ii).time==3600*4)
subplot(141); plot(out(1).meanqt_UD(:,1),zm,out(1).meanqt_DD(:,1),zm,ps(1).qt(:,it)/1000,zm,'g--'); xlim([8.8 9.7]*1e-3)
title(gnrl.mylgd{1})
subplot(142); plot(out(5).meanqt_UD(:,1),zm,out(5).meanqt_DD(:,1),zm,ps(5).qt(:,it)/1000,zm,'g--'); xlim([8.8 9.7]*1e-3)
title(gnrl.mylgd{5})
subplot(143); plot(out(11).meanqt_UD(:,1),zm,out(11).meanqt_DD(:,1),zm,ps(11).qt(:,it)/1000,zm,'g--'); xlim([8.8 9.7]*1e-3)
title(gnrl.mylgd{11})
subplot(144); plot(out(7).meanqt_UD(:,1),zm,out(7).meanqt_DD(:,1),zm,ps(7).qt(:,it)/1000,zm,'g--'); xlim([8.8 9.7]*1e-3)
title(gnrl.mylgd{7})



%%
fs=12;
ifil=1
subplot(121)
for ii=1:11
    plot(obj_ud(ii).meanw_UD(:,ifil),ps(ii).zm./ps(ii).zi(ps(ii).time==4*3600),base(ii).style,'Color',base(ii).color); hold on
end
hold on
xlabel('Mean $w$'' for UD$^{\rm I}$ (m s$^{-1}$)','Interpreter','latex'); ylim([0 1]);
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
subplot(122)
for ii=1:11
    plot(obj_ud(ii).meanw_DD(:,ifil),ps(ii).zm./ps(ii).zi(ps(ii).time==4*3600),base(ii).style,'Color',base(ii).color); hold on
end
xlabel('Mean $w$'' for DD$^{\rm I}$ (m s$^{-1}$)','Interpreter','latex'); ylim([0 1]);
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)

% subplot(121)
% for ii=1:11
%     plot(obj_ql(ii).meanw,ps(ii).zm./ps(ii).zi(ps(ii).time==4*3600),base(ii).style,'Color',base(ii).color); hold on
% end
% xlabel('Mean $w$'' for clouds (m s$^{-1}$)','Interpreter','latex'); ylim([0 1]);
% ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)

print(['../figures/Fig_meanw_UDDDI_',num2str(ii,'%02i')],'-depsc'); close(1)

% subplot(142)
% for ii=1:11
%     plot(obj_ud(ii).meantv_UD(:,ifil),ps(ii).zm./ps(ii).zi(ps(ii).time==4*3600),base(ii).style,'Color',base(ii).color); hold on
% end
% xlabel('Mean $w$ of UD (m s$^{-1}$)','Interpreter','latex'); ylim([0 1]);
% ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
% 
% 
% for ii=1:11
%     plot(obj_ud(ii).meantv_DD(:,ifil),ps(ii).zm./ps(ii).zi(ps(ii).time==4*3600),base(ii).style,'Color',base(ii).color); hold on
% end
% 
% xlabel('Mean $w$ of DD (m s$^{-1}$)','Interpreter','latex'); ylim([0 1]);
% ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
% subplot(143)
% for ii=1:11
%     plot(obj_ud(ii).meantl_UD(:,ifil),ps(ii).zm./ps(ii).zi(ps(ii).time==4*3600),base(ii).style,'Color',base(ii).color); hold on
% end
% xlabel('Mean $w$ of UD (m s$^{-1}$)','Interpreter','latex'); ylim([0 1]);
% ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
% 
% for ii=1:11
%     plot(obj_ud(ii).meantl_DD(:,ifil),ps(ii).zm./ps(ii).zi(ps(ii).time==4*3600),base(ii).style,'Color',base(ii).color); hold on
% end
% 
% xlabel('Mean $w$ of DD (m s$^{-1}$)','Interpreter','latex'); ylim([0 1]);
% ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
% 
% subplot(144)
% for ii=1:11
%     plot(obj_ud(ii).meanqt_UD(:,ifil),ps(ii).zm./ps(ii).zi(ps(ii).time==4*3600),base(ii).style,'Color',base(ii).color); hold on
% end
% xlabel('Mean $w$ of UD (m s$^{-1}$)','Interpreter','latex'); ylim([0 1]);
% ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
% 
% for ii=1:11
%     plot(obj_ud(ii).meanqt_DD(:,ifil),ps(ii).zm./ps(ii).zi(ps(ii).time==4*3600),base(ii).style,'Color',base(ii).color); hold on
% end
% 
% xlabel('Mean $w$ of DD (m s$^{-1}$)','Interpreter','latex'); ylim([0 1]);
% ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)


%% NOW FOR SMALL/LARGE BUOYANCY
%% comparisons
figure('Position',[0 0 900 500])
fs=12;
hr=4;
it=find(ps(ii).time==3600*hr);
sp1=subplot(231);
for ii=1:11
    totww=obj_ud(ii).ww+ps(ii).ww_sfs(:,it);
    plot(totww,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]);
xlabel('Total $w''w''$ (m$^{2}$ s$^{-2}$)','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'a)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp2=subplot(232);
for ii=1:11
    totww=obj_ud(ii).ww+ps(ii).ww_sfs(:,it);
    plot((obj_tv(ii).ww_LB+obj_tv(ii).ww_SB)./totww,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color);     hold on
end
ylim([0 1]);
xlabel('Large LB+SB fraction of $w''w''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'b)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp3=subplot(233);
for ii=1:11
    totww=obj_ud(ii).ww+ps(ii).ww_sfs(:,it);
    plot(obj_tv(ii).ww_res./totww,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]);
xlabel('Residual fraction of $w''w''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'c)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
% lgd=legend(gnrl.mylgd,'Interpreter','latex','fontsize',fs,'Location','eastoutside');

sp4=subplot(234);
for ii=1:11
    totwtv=obj_ud(ii).wtv+ps(ii).buoy_sfs(:,it);
    plot(totwtv,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]);
xlabel('Total $w''\theta_v''$ (m K s$^{-1}$)','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'d)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp5=subplot(235);
for ii=1:11
    totwtv=obj_ud(ii).wtv+ps(ii).buoy_sfs(:,it);
    plot((obj_tv(ii).wtv_LB+obj_tv(ii).wtv_SB)./totwtv,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color);     hold on
end
ylim([0 1]); xlim([.3 1.2])
xlabel('Large LB+SB fraction of $w''\theta_v''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'e)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp6=subplot(236);
for ii=1:11
    totwtv=obj_ud(ii).wtv+ps(ii).buoy_sfs(:,it);
    plot(obj_tv(ii).wtv_res./totwtv,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]); xlim([-.2 .6])
xlabel('Residual fraction of $w''\theta_v''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'f)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
lgd=legend(gnrl.mylgd,'Interpreter','latex','fontsize',fs,'Location','eastoutside');

h1=.35; y1=.1; y2=.6;
w1=.21; x1=.07; x2=.35; x3=.63;
set(sp1,'Position',[x1 y2 w1 h1])
set(sp2,'Position',[x2 y2 w1 h1])
set(sp3,'Position',[x3 y2 w1 h1])
set(sp4,'Position',[x1 y1 w1 h1])
set(sp5,'Position',[x2 y1 w1 h1])
set(sp6,'Position',[x3 y1 w1 h1])
lgd.Position=[.85 .3 .13 .44];

fig=gcf;
fig.PaperUnits='inches';
fig.PaperPosition=[0 0 9 5];
print('../figures/Fig_objtv_res1','-depsc','-r600'); %close(1);
%% comparisons 2 (wtl and wqt)
figure('Position',[0 0 900 500])
fs=12;
hr=4;
it=find(ps(ii).time==3600*hr);
sp1=subplot(231);
for ii=1:11
    totwtl=obj_ud(ii).wtl+ps(ii).sfs_tw(:,it)./ps(ii).dn0./1005;
    plot(totwtl,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]);
xlabel('Total $w''\theta_l''$ (m K s$^{-1}$)','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'a)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp2=subplot(232);
for ii=1:11
    totwtl=obj_ud(ii).wtl+ps(ii).sfs_tw(:,it)./ps(ii).dn0./1005;
    plot((obj_tv(ii).wtl_LB+obj_tv(ii).wtl_SB)./totwtl,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color);     hold on
end
ylim([0 1]); xlim([-10 10])
xlabel('Large LB+SB fraction of $w''\theta_l''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'b)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp3=subplot(233);
for ii=1:11
    totwtl=obj_ud(ii).wtl+ps(ii).sfs_tw(:,it)./ps(ii).dn0./1005;
    plot(obj_tv(ii).wtl_res./totwtl,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]);
xlabel('Residual fraction of $w''\theta_l''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'c)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
% lgd=legend(gnrl.mylgd,'Interpreter','latex','fontsize',fs,'Location','eastoutside');

sp4=subplot(234);
for ii=1:11
    totwqt=obj_ud(ii).wqt+ps(ii).sfs_qw(:,it)./ps(ii).dn0./2.5e6;
    plot(totwqt,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]);
xlabel('Total $w''q_t''$ (m s$^{-1}$)','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'d)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp5=subplot(235);
for ii=1:11
    totwqt=obj_ud(ii).wqt+ps(ii).sfs_qw(:,it)./ps(ii).dn0./2.5e6;
    plot((obj_tv(ii).wqt_LB+obj_tv(ii).wqt_SB)./totwqt,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color);     hold on
end
ylim([0 1]); %xlim([.3 1.2])
xlabel('Large LB+SB fraction of $w''q_t''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'e)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp6=subplot(236);
for ii=1:11
    totwqt=obj_ud(ii).wqt+ps(ii).sfs_qw(:,it)./ps(ii).dn0./2.5e6;
    plot(obj_tv(ii).wqt_res./totwqt,zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1]); %xlim([-.2 .6])
xlabel('Residual fraction of $w''q_t''$','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs)
text(.0,1.1,'f)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
lgd=legend(gnrl.mylgd,'Interpreter','latex','fontsize',fs,'Location','eastoutside');

h1=.35; y1=.1; y2=.6;
w1=.21; x1=.07; x2=.35; x3=.63;
set(sp1,'Position',[x1 y2 w1 h1])
set(sp2,'Position',[x2 y2 w1 h1])
set(sp3,'Position',[x3 y2 w1 h1])
set(sp4,'Position',[x1 y1 w1 h1])
set(sp5,'Position',[x2 y1 w1 h1])
set(sp6,'Position',[x3 y1 w1 h1])
lgd.Position=[.85 .3 .13 .44];

fig=gcf;
fig.PaperUnits='inches';
fig.PaperPosition=[0 0 9 5];
print('../figures/Fig_objtv_res2','-depsc','-r600'); %close(1);

