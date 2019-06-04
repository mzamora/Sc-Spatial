%% Looking closer at the 05SHF case (rolls all over the place)

%% setup
clearvars
%LESdir='/mnt/Sc_group/uclales_output/dycoms_rf01/grid_sens/'; %panthers
LESdir='../in/LESoutput/'; %my laptop
plotcontours=0;
plots=0;

experiment='dycoms_14km_winds';

%%
switch experiment
    case 'dycoms_ctl_gridsize'
        outdir='../dycoms_ctl_gridsize/';
        nkxdays={'ctl_dx35dz10','ctl_dx20dz7','ctl_dx10dz5'};
        mylgd={'35/10','20/7','10/5'};
        isinitial=1;
        standardcase='rf01';
        t_index=19;
        it1=14; it2=19; %last hour
        nxs=[96,96,96];
        nzs=[131,131,131];
    case 'dycoms_cases'
        outdir='../dycoms_ctl_gridsize/';
%         nkxdays={'ctl_dx35dz10','05LHF_dx35dz10','05SHF_dx35dz10','0wind_dx35dz10'};
        nkxdays={'ctl_dx35dz10','05SHF_dx35dz10','0wind_dx35dz10'};
        mylgd={'CTL','0.5xSHF','0xWind'};
        isinitial=1;
        standardcase='rf01';
        t_index=19;
        it1=14; it2=19; %last hour
        nxs=[96,96,96,96,96];
        nzs=[131,131,131,131,131];
    case 'dycoms_all_domain'
        outdir='../LESoutput/';
        nkxdays={'ctl_dx35dz10','ctl_dx35dz10_14km','05SHF_dx35dz10','05SHF_dx35dz10_14km','0wind_dx35dz10','0wind_dx35dz10_14km'};
        mylgd={'CTL 3km','CTL 14km','05SHF 3km','05SHF 14km','0Wind 3km','0Wind 14km'};
        isinitial=1;
        standardcase='rf01';
        t_index=19;
        it1=14; it2=19; %last hour
        nxs=[96,400,96,400,96,400];
        nzs=[131,131,131,131,131,131];
    case 'dycoms_14km_domain'
        outdir='../LESoutput/';
        nkxdays={'ctl_dx35dz10_14km','05SHF_dx35dz10_14km','0wind_dx35dz10_14km'};
        mylgd={'CTRL','05SHF','0Wind'};
        isinitial=1;
        standardcase='rf01';
        t_index=19;
        it1=14; it2=19; %last hour
        nxs=[400,400,400];
        nzs=[131,131,131];
    case 'dycoms_14km_winds'
        outdir=['../out/',experiment];
        nkxdays={'ctl_dx35dz10_14km','075wind_dx35dz10_14km','05wind_dx35dz10_14km','025wind_dx35dz10_14km','0wind_dx35dz10_14km'};
        mylgd={'CTRL','075Wind','05Wind','025Wind','0Wind'};
        bcklgd={'0Wind','025Wind','05Wind','075Wind','CTRL'};
        isinitial=1;
        t_index=19;
        it1=14; it2=19; %last hour
        standardcase='rf01';
        nxs=[400,400,400,400,400];
        nzs=[131,131,131,131,131];
%         datafolder='../../uclales_output/dycoms_rf01/grid_sens/'; % in the panthers
        datafolder='../LESoutput/'; % in the panthers
    case 'dycoms_14km_SHF'
        outdir=['../out/',experiment];
        nkxdays={'0SHF_dx35dz10_14km','05SHF_dx35dz10_14km','ctl_dx35dz10_14km','15SHF_dx35dz10_14km','2SHF_dx35dz10_14km'};
        mylgd={'0SHF','05SHF','CTRL','15SHF','2SHF'};
        bcklgd={'2SHF','15SHF','CTRL','05SHF','0SHF'};
        isinitial=1;
        t_index=19;
        it1=14; it2=19; %last hour
        standardcase='rf01';
        nxs=[400,400,400,400,400];
        nzs=[131,131,131,131,131];
%         datafolder='../../uclales_output/dycoms_rf01/grid_sens/'; % in the panthers
        datafolder='../in/LESoutput/'; % in my laptop
end

numcases=length(nkxdays);
styles={'-','--','-','--','-','--'}; styles=styles(1:numcases);
cols=linspace(1,0,numcases); cols=[cols',1-cols',1-cols'];
%cols={'k','k','r','r','b','b'}; cols=cols(1:numcases);
% styles={'-','-','-'};
% cols={'k','r','b'}; 

%% pre allocation 
try
    mkdir(outdir)
end

%% basic setup
for ii=numcases:-1:1 %backwards preallocates structures... pretty nice trick
    base(ii).name=[LESdir,nkxdays{ii},'/',standardcase]; 
    base(ii).nx=nxs(ii); base(ii).nz=nzs(ii); base(ii).outfile=[outdir,nkxdays{ii}];
    base(ii).style=styles{ii}; base(ii).color=cols(ii,:); base(ii).casename=nkxdays{ii};
    base(ii).datafolder=datafolder;
    base(ii).tsfile_03=[base(ii).name,'.ts.nc'];
    base(ii).tsfile_34=strrep(base(ii).tsfile_03,'rf01','hr3_4/rf01');
    base(ii).psfile_03=[base(ii).name,'.ps.nc'];
    base(ii).psfile_34=strrep(base(ii).psfile_03,'rf01','hr3_4/rf01');
    % need to think the 3D stuff through
%     ps3dfile=[base.name,'_3D.mat'];
end

%% Time evolution plots
figure(1)
for ii=numcases:-1:1
    % time evolution plots
    [ts(ii)]=plot_ts_basics(base(ii)); hold on;
end
ylim([20 100]); legend(bcklgd,'Location','best')
print([outdir,'/statsLES_ts'],'-depsc')
close(1)

%% get ps data
for ii=numcases:-1:1
    ps(ii)=get_ps_vertbasics(base(ii),ts(ii));
end
%% vertical profiles at hour 3
% plot_time=3*3600;
% for ii=numcases:-1:1; plot_ps_vertbasics(base(ii),ps(ii),plot_time); end
% for ifig=1:12
%     figure(ifig); legend(bcklgd,'Location','best');
%     print(['images/statsLES_vertps_hr3_',num2str(ifig,'%02i')],'-depsc') %it will write it each time though
% end
% close all
%% vertical profiles at hour 4
% plot_time=4*3600;
% for ii=numcases:-1:1; plot_ps_vertbasics(base(ii),ps(ii),plot_time); end
% for ifig=1:12
%     figure(ifig); legend(bcklgd,'Location','best');
%     print(['images/statsLES_vertps_hr4_',num2str(ifig,'%02i')],'-depsc') %it will write it each time though
% end
% close all;
%% hr3-4 averages
for ii=numcases:-1:1
    plot_ps_vertbasics(base(ii),ps(ii))
end
for ifig=1:16
    figure(ifig); legend(bcklgd,'Location','best');
    fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 4 3];
    print([outdir,'/statsLES_vertps_avghr34_',num2str(ifig,'%02i')],'-depsc') %it will write it each time though
%     close(ifig)
end
close all;

%% slices at height with greatest CF
time=60; % 1:right after hr3, 60:hr 4
doplots=1;

for ii=numcases:-1:1
    %% load 3d vars at that time
    filename=[datafolder,nkxdays{ii},'/hr3_4/'];
    var3d={'w','u','v','tl','tv','qt','ql','LWP'};
    for ivar=1:length(var3d); load([filename,'rf01_',var3d{ivar},'_',num2str(time,'%02i')]); end
    
    %% vertical cloud fraction and levels
    ps3d(ii)=get_vertical_cloudfrac_levels(ql,LWP,tl,ps(ii));
    if doplots
    plot(ps3d(ii).nql(ps3d(ii).izb:ps3d(ii).izt),ps3d(ii).izb:ps3d(ii).izt,'.-'); xlabel('Cloudy area fraction'); ylabel('z levels') %#ok<UNRCH>
    fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 4 3];
    print([outdir,'/statsLES_cloudprofile_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc') %it will write it each time though
    clf 
    
    %% plot contours in xy
    sp1=subplot('Position',[0.05,0.1,0.25,.8]); plot_wanom_contour(u,v,w,10); title('$0.1 z/z_i$','Interpreter','latex')
    sp2=subplot('Position',[0.38,0.1,0.25,.8]); plot_wanom_contour(u,v,w,ps3d(ii).iz_nqlmax); title('Max. CF','Interpreter','latex');
    sp3=subplot('Position',[0.71,0.1,0.25,0.8]); plot_ql_xy_contour(u,v,ql,ps3d(ii).iz_nqlmax); title('Max. CF','Interpreter','latex');

    fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 12 3];
    print([outdir,'/statsLES_maxCFslice_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc','-r600') %it will write it each time though
    clf; fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 4 3];
    end
    
    %% conditional sampling and mean vertical profiles
    cs(ii)=get_condsamp_UDDD_fluxes(u,v,w,tl,qt,ql,tv);
    zi=ts(ii).zis(ts(ii).times==10800+time*60); %current zi: time is #min after hr3
    
    %% plot conditional sampled fluxes or mean profiles
    if doplots
    figure(1); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) % UD DD frequencies   
    plot(cs(ii).n_UD,ps(ii).zm/zi,cs(ii).n_DD,ps(ii).zm/zi); legend('UD','DD','Location','best'); 
    xlabel('Structures area fraction','Interpreter','latex'); ylabel('$z/z_i$ [m]','Interpreter','latex'); ylim([0 1.05])
    title(extractBefore(nkxdays{ii},'_')); print([outdir,'/statsLES_CSn_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
    
    figure(2); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %u'w'
    plot(cs(ii).uw_UD,ps(ii).zm/zi,'--',cs(ii).uw_DD,ps(ii).zm/zi,'--',cs(ii).uw,ps(ii).zm/zi); 
    ylabel('$z/z_i$','Interpreter','latex'); xlabel('$u''w''(z)$ [m$^2$~s$^{-2}$]','Interpreter','latex'); ylim([0 1.05])
    legend('UD','DD','Total','Location','best')
    title(extractBefore(nkxdays{ii},'_')); print([outdir,'/statsLES_CSuw_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
    
    figure(3); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %w'w'
    plot(cs(ii).ww_UD,ps(ii).zm/zi,'--',cs(ii).ww_DD,ps(ii).zm/zi,'--',cs(ii).ww,ps(ii).zm/zi); 
    ylabel('$z/z_i$','Interpreter','latex'); xlabel('$w''w''(z)$ [m$^2$~s$^{-2}$]','Interpreter','latex'); ylim([0 1.05])
    legend('UD','DD','Total','Location','best')
    title(extractBefore(nkxdays{ii},'_')); print([outdir,'/statsLES_CSww_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
    
    figure(4); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %w'w'w'
    plot(cs(ii).www_UD,ps(ii).zm/zi,'--',cs(ii).www_DD,ps(ii).zm/zi,'--',cs(ii).www,ps(ii).zm/zi); 
    ylabel('$z/z_i$','Interpreter','latex'); xlabel('$w''w''w''(z)$ [m$^2$~s$^{-2}$]','Interpreter','latex'); 
    legend('UD','DD','Total','Location','best'); ylim([0 1.05])
    title(extractBefore(nkxdays{ii},'_')); print([outdir,'/statsLES_CSwww_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
    
    figure(5); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %w'tl'
    plot(cs(ii).wtl_UD,ps(ii).zm/zi,'--',cs(ii).wtl_DD,ps(ii).zm/zi,'--',cs(ii).wtl,ps(ii).zm/zi); 
    ylabel('$z/z_i$','Interpreter','latex'); xlabel('$w''\theta_l'' (z)$ [m~K~s$^{-1}$]','Interpreter','latex'); 
    legend('UD','DD','Total','Location','best'); ylim([0 1.05])
    title(extractBefore(nkxdays{ii},'_')); print([outdir,'/statsLES_CSwtl_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
    
    figure(6); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %w'qt'
    plot(cs(ii).wqt_UD,ps(ii).zm/zi,'--',cs(ii).wqt_DD,ps(ii).zm/zi,'--',cs(ii).wqt,ps(ii).zm/zi); 
    ylabel('$z/z_i$','Interpreter','latex'); xlabel('$w''q_t''(z)$ [m~s$^{-1}$]','Interpreter','latex'); 
    legend('UD','DD','Total','Location','best'); ylim([0 1.05])
    title(extractBefore(nkxdays{ii},'_')); print([outdir,'/statsLES_CSwqt_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
    
    figure(7); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %w'ql'
    plot(cs(ii).wql_UD,ps(ii).zm/zi,'--',cs(ii).wql_DD,ps(ii).zm/zi,'--',cs(ii).wql,ps(ii).zm/zi); 
    ylabel('$z/z_i$','Interpreter','latex'); xlabel('$w''q_l''(z)$ [m~s$^{-1}$]','Interpreter','latex'); 
    legend('UD','DD','Total','Location','best'); ylim([0 1.05]); print([outdir,'/statsLES_CSwql_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
    
    figure(8); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %w'ql'
    plot(cs(ii).wtv_UD,ps(ii).zm/zi,'--',cs(ii).wtv_DD,ps(ii).zm/zi,'--',cs(ii).wtv,ps(ii).zm/zi); 
    ylabel('$z/z_i$','Interpreter','latex'); xlabel('$w''q_l''(z)$ [m~s$^{-1}$]','Interpreter','latex'); 
    legend('UD','DD','Total','Location','best'); ylim([0 1.05]); print([outdir,'/statsLES_CSwtv_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
    
    figure(9); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %tl_avg'
    plot(cs(ii).tl_UD,ps(ii).zm/zi,'--',cs(ii).tl_DD,ps(ii).zm/zi,'--',cs(ii).tl_avg,ps(ii).zm/zi); 
    ylabel('$z/z_i$','Interpreter','latex'); xlabel('$<\theta_l>(z)$ [K]','Interpreter','latex'); 
    legend('UD','DD','Total','Location','best'); ylim([0 1.05]); print([outdir,'/statsLES_CStl_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
    
    figure(10); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %qt_avg'
    plot(cs(ii).qt_UD,ps(ii).zm/zi,'--',cs(ii).qt_DD,ps(ii).zm/zi,'--',cs(ii).qt_avg,ps(ii).zm/zi); 
    ylabel('$z/z_i$','Interpreter','latex'); xlabel('$<q_t>(z)$ [K]','Interpreter','latex'); 
    legend('UD','DD','Total','Location','best'); ylim([0 1.05]); print([outdir,'/statsLES_CSqt_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
    
    close all
    end
    
    %% column stats LWP circulation, etc
    pscolumns(ii)=get_stats_LWPcolumns(u,v,w,qt,tl,LWP,ps3d(ii),base(ii));
    
    %%
    clear u v w qt tl LWP
end

%% LWP columns 1: Vertical profiles by LWP bins
colrs=linspace(1,0,11); colrs=[colrs',1-colrs',1-colrs'];
for ii=numcases:-1:1
    subplot(221); p1=plot(pscolumns(ii).wbin,ps3d(ii).zm); set(p1,{'color'},num2cell(colrs,2)); ylim([0 950])
    subplot(222); p2=plot(pscolumns(ii).quvbin,ps3d(ii).zm); set(p2,{'color'},num2cell(colrs,2)); ylim([0 950])
    subplot(223); p3=plot(pscolumns(ii).qtbin,ps3d(ii).zm); set(p3,{'color'},num2cell(colrs,2)); ylim([0 950])
    subplot(224); p4=plot(pscolumns(ii).tlbin,ps3d(ii).zm); set(p4,{'color'},num2cell(colrs,2)); ylim([0 950])

subplot(221); xlabel('$w''(x,y)$ [m~s$^{-1}$]','Interpreter','latex'); ylabel('$z$ [m]','Interpreter','latex')
subplot(222); xlabel('$\sqrt{u^2+v^2}''(x,y)$ [m~s$^{-1}$]','Interpreter','latex'); ylabel('$z$ [m]','Interpreter','latex'); %legend('0','(0,10]','(10,20]','(20,30]','(30,40]','(40,50]','(50,60]','(60,70]','(70,80]','(80,90]','(90,100]','Location','best')
subplot(223); xlabel('$q_t''(x,y)$','Interpreter','latex'); ylabel('$z$ [m]','Interpreter','latex')
subplot(224); xlabel('$\theta_l''(x,y)$ [K]','Interpreter','latex'); ylabel('$z$ [m]','Interpreter','latex')

print([outdir,'/statsLES_profiles_LWPbins_',nkxdays{ii},'_t',num2str(time,'%02i'),'_case',num2str(ii)],'-depsc'); clf
end
%% LWP columns 2: colormaps by LWP bins
for imap=1:4
    maps={'wbin','quvbin','qtbin','tlbin'}; ylabs={'$w''(x,y)$ [m~s$^{-1}$]','$\sqrt{u^2+v^2}$ [m~s$^{-1}$]','$q_t''(x,y)$','$\theta_l''(x,y)$ [K]'};
    zlims=[-0.6,0.6;-0.4,0.4;-0.001,0.001;-3,1];
    for ii=numcases:-1:1
        contourf(pscolumns(ii).Xbin,pscolumns(ii).Ybin,pscolumns(ii).(maps{imap})',30,'LineStyle','none'); c=colorbar; hold on;caxis(zlims(imap,:))
        plot(pscolumns(ii).avg_LWP,pscolumns(ii).avg_cbh,'r--','LineWidth',3);
        plot(pscolumns(ii).avg_LWP,pscolumns(ii).avg_cth,'r--','LineWidth',3);
        xlabel('$\rm{LWP}$ [g~m$^{-2}$]','Interpreter','latex'); ylabel('$z$ [m]','Interpreter','latex'); 
        ylabel(c,ylabs{imap},'Interpreter','latex')
        title(extractBefore(nkxdays{ii},'_'))
        print([outdir,'/statsLES_contour_',maps{imap},'_LWPbins_',nkxdays{ii},'_t',num2str(time,'%02i'),'_case',num2str(ii)],'-depsc'); clf
    end
end
%% Average cloud profile
for  ii=numcases:-1:1
    plot(pscolumns(ii).avgcldx,pscolumns(ii).avgcldy,base(ii).style,'Color',base(ii).color); hold on
    xlabel('Area fraction by LWP bins','Interpreter','latex'); ylabel('Average cloud edges [m]','Interpreter','latex')
end
legend(bcklgd,'Location','best');
print([outdir,'/statsLES_avgCloud_',maps{imap},'_LWPbins_',nkxdays{ii},'_t',num2str(time,'%02i'),'_case',num2str(ii)],'-depsc'); clf
%% plot UD DD frequencies together
for  ii=numcases:-1:1
    subplot(121); plot(cs(ii).n_UD,ps(ii).zm/zi,'Color',base(ii).color); hold on; ylim([0 1.1])
    subplot(122); plot(cs(ii).n_DD,ps(ii).zm/zi,'Color',base(ii).color); hold on; ylim([0 1.1])
end
subplot(121); xlabel('Updraft fraction','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex')
subplot(122); xlabel('Downdraft fraction','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex')
legend(bcklgd,'Location','best')
print([outdir,'/statsLES_nUDDDz_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
clf

%% plot vertical cloud fraction together
for ii=numcases:-1:1
    plot(ps3d(ii).nql(ps3d(ii).nql_izb:ps3d(ii).nql_izt),ps(ii).zm(ps3d(ii).nql_izb:ps3d(ii).nql_izt)/zi,'Color',base(ii).color); hold on
end
 xlabel('Cloudy area fraction','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex')
legend(bcklgd,'Location','best')
 print([outdir,'/statsLES_CFz_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')

%% plot LWP, zi and zb pdfs
figure(11); bigN=base(ii).nx^2;
for ii=numcases:-1:1
subplot(221); plot(0.5*(ps3d(ii).pdf_lims_LWP(1:end-1)+ps3d(ii).pdf_lims_LWP(2:end)),ps3d(ii).pdf_N_LWP/bigN,base(ii).style,'Color',base(ii).color); hold on
subplot(222); plot(0.5*(ps3d(ii).pdf_lims_cbh(1:end-1)+ps3d(ii).pdf_lims_cbh(2:end)),ps3d(ii).pdf_N_cbh/bigN,base(ii).style,'Color',base(ii).color); hold on
subplot(223); plot(0.5*(ps3d(ii).pdf_lims_cth(1:end-1)+ps3d(ii).pdf_lims_cth(2:end)),ps3d(ii).pdf_N_cth/bigN,base(ii).style,'Color',base(ii).color); hold on
subplot(224); plot(0.5*(ps3d(ii).pdf_lims_zmtg(1:end-1)+ps3d(ii).pdf_lims_zmtg(2:end)),ps3d(ii).pdf_N_zmtg/bigN,base(ii).style,'Color',base(ii).color); hold on 
end
subplot(221); xlabel('$\rm{LWP}$ [g~m$^2$]','Interpreter','latex'); ylabel('Frequency','Interpreter','latex'); legend(bcklgd)
subplot(222); xlabel('$z_{cb}$ [m]','Interpreter','latex'); ylabel('Frequency','Interpreter','latex')
subplot(223); xlabel('$z_{ct}$ [m]','Interpreter','latex'); ylabel('Frequency','Interpreter','latex')
subplot(224); xlabel('$z_i$ [m]','Interpreter','latex'); ylabel('Frequency','Interpreter','latex')
print([outdir,'/statsLES_pdfs_LWPzbzi_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')

%% non dimensional numbers
%% DYCOMS

F0=62;
F1=17.7;
k=119;
T_cld=283.75;
rho_cld=1.17;
ql_cld=0.00048;
l_ext=(k*rho_cld*ql_cld)^-1
nu=1e-5;
dT=8.5;

B0=(F0*9.81/rho_cld/1005/T_cld);
U0=(B0*l_ext)^(1/3)
b0=(B0^2/l_ext)^(1/3)
Re0=l_ext*U0/nu
db=9.8*dT/T_cld %b_FT-b_cld;
Ri0=l_ext*db/(U0^2)
%% Scaling laws and non dimensional numbers: stored in sp (scaling parameters)
    % radiative properties for mellados parameters
%    F0=18.73; F1=7.24; xka=87.4254; %from best fit
    % cloud properties: todo: get from ps files
%    T_cld=288; rho_cld=1.17;
%    ps.ql=ncread(psfile,'l'); [ql_cld,iqlm]=max(ql(:,t_index))*1e-3;
%    l_ext=(xka*rho_cld*ql_cld)^-1;
%    nu=1e-5; [~,iFT]=max(diff(tl(:,4))./diff(zm));

%    if exist([LESdir,prefix,nkxdays{ii},'/scalingparams.mat'],'file')==2
%        load([outdir,'/scalingparams_',nkxdays{ii}],'sp');
%    else
%%
for ii=numcases:-1:1
        sp(ii)=get_scalingparameters(base(ii),ts(ii),ps(ii),ps3d(ii));
%         save([outdir,'/scalingparams_',nkxdays{ii}],'sp');
end
%% u star vs w star at srf
for ii=numcases:-1:1
plot(sp(ii).u_star_0(1),sp(ii).w_star_0(1),'o','Color',base(ii).color); hold on
plot(sp(ii).u_star_0(2),sp(ii).w_star_0(2),'^','Color',base(ii).color)
end
legend('0SHF-hr3','0SHF-hr4','05SHF-hr3','05SHF-hr4','CTRL-hr3','CTRL-hr4','15SHF-hr3','15SHF-hr4','2SHF-hr3','2SHF-hr4','Location','best')
xlabel('$u_{*0}$','Interpreter','latex'); ylabel('$w_{*0}$','Interpreter','latex'); 
print([outdir,'/statsLES_scaling_usws'],'-depsc')

%% u star vs 
for ii=numcases:-1:1
plot(sp(ii).u_star_i(1),sp(ii).w_star_i(1),'o','Color',base(ii).color); hold on
plot(sp(ii).u_star_i(2),sp(ii).w_star_i(2),'^','Color',base(ii).color)
end
legend('0SHF-hr3','0SHF-hr4','05SHF-hr3','05SHF-hr4','CTRL-hr3','CTRL-hr4','15SHF-hr3','15SHF-hr4','2SHF-hr3','2SHF-hr4','Location','best')
xlabel('$u_{*i}$','Interpreter','latex'); ylabel('$w_{*i}$','Interpreter','latex'); 
print([outdir,'/statsLES_scaling_uiwi'],'-depsc')

%%
% 
% figure(3)
%     subplot(231); plot(sp.timeh,sp.bflx_0,sp.timeh,sp.bmax); ylabel('|w''\theta_v''| [m/s^2]'); xlabel('Time [h]')
%     subplot(232); plot(sp.timeh,sp.w_star_0,sp.timeh,sp.w_star_i); ylabel('w_* [m/s]'); xlabel('Time [h]')
%     subplot(233); plot(sp.timeh,sp.T_star_0/60,sp.timeh,sp.T_star_i/60); ylabel('T_* [min]'); xlabel('Time [h]')
%     subplot(234); plot(sp.timeh,sp.u_star_0,sp.timeh,sp.u_star_i); ylabel('u_* [m/s]'); xlabel('Time [h]')
%     subplot(235); plot(sp.timeh,sp.L_ob_0,sp.timeh,sp.L_ob_i); ylabel('L_{ob} [m]'); xlabel('Time [h]')
%     subplot(236); semilogy(sp.timeh,sp.zeta_0,sp.timeh,sp.zeta_i,[1 2],[10 10],':k'); ylabel('\zeta'); xlabel('Time [h]')
%     legend('Srf','Cld') 
%     fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 10 6];
%     print([outdir,nkxdays{ii},'_sp_07'],'-depsc'); clf;
%     fprintf('Non dimensional parameters done \n');
% 
% %% save main results
%     results.casename{ii}=nkxdays{ii};
%     results.w_star_0(ii,1)=mean(sp.w_star_0);
%     results.T_star_0(ii,1)=mean(sp.T_star_0);
%     results.u_star_0(ii,1)=mean(sp.u_star_0);
%     results.L_ob_0(ii,1)=mean(sp.L_ob_0');
%     results.zeta_0(ii,1)=mean(sp.zeta_0);
%     results.buoy_0(ii,1)=mean(sp.bflx_0);
%     results.tv_0(ii,1)=mean(sp.tv_0);
%     
%     results.w_star_i(ii,1)=mean(sp.w_star_i);
%     results.B_cld(ii,1)=mean(sp.B_cld);
%     results.B_ml(ii,1)=mean(sp.B_ml);
%     results.z_star_i(ii,1)=mean(sp.z_star_i);
%     results.T_star_i(ii,1)=mean(sp.T_star_i);
%     results.u_star_i(ii,1)=mean(sp.u_star_i);
%     results.L_ob_i(ii,1)=mean(sp.T_star_i);
%     results.zeta_i(ii,1)=mean(sp.zeta_i);
%     results.buoy_i(ii,1)=mean(sp.bmax);
%     results.tv_i(ii,1)=mean(sp.tv_i);
%     save([outdir,'meanresults_',experiment],'results');

%%

