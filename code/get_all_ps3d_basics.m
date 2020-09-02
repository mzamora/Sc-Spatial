function ps3d=get_all_ps3d_basics(base,ts,ps,gnrl)

doplots=0;
for ii=gnrl.numcases:-1:1
    for time=60 %hour 4 snapshot
    %% load 3d vars at that time
    filename=[base(ii).name(1:end-4),'hr3_4/'];
    var3d={'w','u','v','tl','tv','qt','ql','LWP'};
    for ivar=1:length(var3d); load([filename,'rf01_',var3d{ivar},num2str(time,'%02i')]); end
    
    %% vertical cloud fraction and levels
    ps3d(ii,time)=get_vertical_cloudfrac_levels(ql,LWP,tl,ps(ii));
end
%%
    if doplots
    plot(ps3d(ii).nql(ps3d(ii).nql_izb:ps3d(ii).nql_izt),ps3d(ii).nql_izb:ps3d(ii).nql_izt,'.-'); xlabel('Cloudy area fraction'); ylabel('z levels') %#ok<UNRCH>
    fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 4 3];
    print([outdir,'/statsLES_cloudprofile_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc') %it will write it each time though
    clf 
    
    %% plot contours in xy
    sp1=subplot('Position',[0.05,0.14,0.27,.75]); plot_wanom_contour(u,v,w,10); title('$0.1 z/z_i$','Interpreter','latex'); ylabel('y [km]','Interpreter','latex'); xlabel('x [km]','Interpreter','latex');
    sp2=subplot('Position',[0.38,0.14,0.27,.75]); plot_wanom_contour(u,v,w,ps3d(ii).nql_max_iz); title('Max. CF','Interpreter','latex');xlabel('x [km]','Interpreter','latex');
    sp3=subplot('Position',[0.71,0.14,0.27,.75]); plot_ql_xy_contour(u,v,ql,ps3d(ii).nql_max_iz); title('Max. CF','Interpreter','latex');xlabel('x [km]','Interpreter','latex');

    fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 12 3];
    print([outdir,'/statsLES_maxCFslice_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc','-r600') %it will write it each time though
    %clf; fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 4 3];
    end
    
    %% conditional sampling and mean vertical profiles
%      cs(ii)=get_condsamp_UDDD_fluxes(u,v,w,tl,qt,ql,tv);
%      zi=ts(ii).zis(ts(ii).times==10800+time*60); %current zi: time is #min after hr3
%     
%     %% plot conditional sampled fluxes or mean profiles
%     if doplots
%     figure(1); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) % UD DD frequencies   
%     plot(cs(ii).n_UD,ps(ii).zm/zi,cs(ii).n_DD,ps(ii).zm/zi); legend('UD','DD','Location','best'); 
%     xlabel('Structures area fraction','Interpreter','latex'); ylabel('$z/z_i$ [m]','Interpreter','latex'); ylim([0 1.05])
%     title(extractBefore(nkxdays{ii},'_')); print([outdir,'/statsLES_CSn_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
%     
%     figure(2); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %u'w'
%     plot(cs(ii).uw_UD,ps(ii).zm/zi,'--',cs(ii).uw_DD,ps(ii).zm/zi,'--',cs(ii).uw,ps(ii).zm/zi); 
%     ylabel('$z/z_i$','Interpreter','latex'); xlabel('$u''w''(z)$ [m$^2$~s$^{-2}$]','Interpreter','latex'); ylim([0 1.05])
%     legend('UD','DD','Total','Location','best')
%     title(extractBefore(nkxdays{ii},'_')); print([outdir,'/statsLES_CSuw_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
%     
%     figure(3); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %w'w'
%     plot(cs(ii).ww_UD,ps(ii).zm/zi,'--',cs(ii).ww_DD,ps(ii).zm/zi,'--',cs(ii).ww,ps(ii).zm/zi); 
%     ylabel('$z/z_i$','Interpreter','latex'); xlabel('$w''w''(z)$ [m$^2$~s$^{-2}$]','Interpreter','latex'); ylim([0 1.05])
%     legend('UD','DD','Total','Location','best')
%     title(extractBefore(nkxdays{ii},'_')); print([outdir,'/statsLES_CSww_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
%     
%     figure(4); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %w'w'w'
%     plot(cs(ii).www_UD,ps(ii).zm/zi,'--',cs(ii).www_DD,ps(ii).zm/zi,'--',cs(ii).www,ps(ii).zm/zi); 
%     ylabel('$z/z_i$','Interpreter','latex'); xlabel('$w''w''w''(z)$ [m$^2$~s$^{-2}$]','Interpreter','latex'); 
%     legend('UD','DD','Total','Location','best'); ylim([0 1.05])
%     title(extractBefore(nkxdays{ii},'_')); print([outdir,'/statsLES_CSwww_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
%     
%     figure(5); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %w'tl'
%     plot(cs(ii).wtl_UD,ps(ii).zm/zi,'--',cs(ii).wtl_DD,ps(ii).zm/zi,'--',cs(ii).wtl,ps(ii).zm/zi); 
%     ylabel('$z/z_i$','Interpreter','latex'); xlabel('$w''\theta_l'' (z)$ [m~K~s$^{-1}$]','Interpreter','latex'); 
%     legend('UD','DD','Total','Location','best'); ylim([0 1.05])
%     title(extractBefore(nkxdays{ii},'_')); print([outdir,'/statsLES_CSwtl_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
%     
%     figure(6); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %w'qt'
%     plot(cs(ii).wqt_UD,ps(ii).zm/zi,'--',cs(ii).wqt_DD,ps(ii).zm/zi,'--',cs(ii).wqt,ps(ii).zm/zi); 
%     ylabel('$z/z_i$','Interpreter','latex'); xlabel('$w''q_t''(z)$ [m~s$^{-1}$]','Interpreter','latex'); 
%     legend('UD','DD','Total','Location','best'); ylim([0 1.05])
%     title(extractBefore(nkxdays{ii},'_')); print([outdir,'/statsLES_CSwqt_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
%     
%     figure(7); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %w'ql'
%     plot(cs(ii).wql_UD,ps(ii).zm/zi,'--',cs(ii).wql_DD,ps(ii).zm/zi,'--',cs(ii).wql,ps(ii).zm/zi); 
%     ylabel('$z/z_i$','Interpreter','latex'); xlabel('$w''q_l''(z)$ [m~s$^{-1}$]','Interpreter','latex'); 
%     legend('UD','DD','Total','Location','best'); ylim([0 1.05]); print([outdir,'/statsLES_CSwql_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
%     
%     figure(8); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %w'ql'
%     plot(cs(ii).wtv_UD,ps(ii).zm/zi,'--',cs(ii).wtv_DD,ps(ii).zm/zi,'--',cs(ii).wtv,ps(ii).zm/zi); 
%     ylabel('$z/z_i$','Interpreter','latex'); xlabel('$w''q_l''(z)$ [m~s$^{-1}$]','Interpreter','latex'); 
%     legend('UD','DD','Total','Location','best'); ylim([0 1.05]); print([outdir,'/statsLES_CSwtv_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
%     
%     figure(9); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %tl_avg'
%     plot(cs(ii).tl_UD,ps(ii).zm/zi,'--',cs(ii).tl_DD,ps(ii).zm/zi,'--',cs(ii).tl_avg,ps(ii).zm/zi); 
%     ylabel('$z/z_i$','Interpreter','latex'); xlabel('$<\theta_l>(z)$ [K]','Interpreter','latex'); 
%     legend('UD','DD','Total','Location','best'); ylim([0 1.05]); print([outdir,'/statsLES_CStl_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
%     
%     figure(10); title([extractBefore(nkxdays{ii},'_'),', minute ',num2str(time)]) %qt_avg'
%     plot(cs(ii).qt_UD,ps(ii).zm/zi,'--',cs(ii).qt_DD,ps(ii).zm/zi,'--',cs(ii).qt_avg,ps(ii).zm/zi); 
%     ylabel('$z/z_i$','Interpreter','latex'); xlabel('$<q_t>(z)$ [K]','Interpreter','latex'); 
%     legend('UD','DD','Total','Location','best'); ylim([0 1.05]); print([outdir,'/statsLES_CSqt_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
%     
%     close all
%     end
    
    %% column stats LWP circulation, etc
%     pscolumns(ii)=get_stats_LWPcolumns(u,v,w,qt,tl,LWP,ps3d(ii),base(ii));
    
    %%
    clear u v w qt tl LWP
end