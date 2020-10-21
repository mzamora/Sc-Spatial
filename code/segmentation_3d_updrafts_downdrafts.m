function out=segmentation_3d_updrafts_downdrafts(w,zm,xm,ym,izb,izt,outpref,time,tv,qt,tl,ql,u,v)
% 3D segmentation for updrafts and downdrafts based on w'

%% Setup
nx=length(xm); ny=length(ym);
var=w; zi=zm(izt); zb=zm(izb);
var_std_z=std(var,1,[2 3]); %std(var,1,'all');
var_mean=mean(var,[2 3]); %avg in the z direction
var_anom=var-repmat(var_mean,[1 nx ny]); % anomaly
var_anom_std_z=std(var_anom,1,[2 3]); %std of anomaly
rgaussianblur=2; %radius for gaussian blur
doplots=0;
%%
%epss=1;% 
epss=1; %[0.8 .9 1 1.1 1.2];% constant for the SD(z) threshold

% for ieps=5:-1:1 % constant for the SD(z) threshold
ieps=1;
epsSDthreshold=epss(ieps);
    
%% get w' distributions
var_anom_min=min(var_anom,[],'all'); %overall min of w'
var_anom_max=max(var_anom,[],'all'); %overall max of w'
var_min=min(var,[],'all');
var_max=max(var,[],'all');
edges=linspace(var_anom_min,var_anom_max,50); 
edges_asis=linspace(var_min,var_max,50); 
nz=length(zm);
for iz=1:nz
    N_anom(iz,:)=histcounts(var_anom(iz,:,:),edges);
    N_asis(iz,:)=histcounts(var(iz,:,:),edges_asis);
end
N_anom(izt+1:nz,:)=0;
N_asis(izt+1:nz,:)=0;

 %% check distribution of w'
 if doplots
contourf(0.5*(edges(2:end)+edges(1:end-1)),zm(1:izt),N_anom(1:izt,:),50,'LineStyle','none'); hold on
c=colorbar; xlabel ('w'' [m/s]'); ylabel('Height [m]'); c.Label.String='Number of counts';
plot([0 0],[0 zm(izt)],'w:')
plot(var_anom_std_z(1:izt),zm(1:izt),'w--','LineWidth',3)
plot(-var_anom_std_z(1:izt),zm(1:izt),'w--','LineWidth',3)
text(0.9,100,'$+\sigma_w$','Interpreter','latex','Color','w','FontSize',20)
text(-1.7,100,'$-\sigma_w$','Interpreter','latex','Color','w','FontSize',20)
print([outpref,'3dseg_w_',num2str(time,'%02i'),'_dist_wanom'],'-depsc','-r600'); close(1)
 end
 
 %% Blurred var
varb=imgaussfilt3(var,rgaussianblur); %gaussian filter
varb_std_all_z=epsSDthreshold*std(varb,1,[2 3]); %std(varb,1,'all');
varb_mean=mean(varb,[2 3]);
varb_anom=varb-repmat(varb_mean,[1 nx ny]);
varb_anom_min=min(varb_anom,[],'all'); %overall min of wblur'
varb_anom_max=max(varb_anom,[],'all'); %overall max of wblur'
varb_anom_std_z=std(varb_anom,1,[2 3]);
edgesb=linspace(varb_anom_min,varb_anom_max,50); 
for iz=1:nz
    Nb_anom(iz,:)=histcounts(varb_anom(iz,:,:),edgesb);
end
Nb_anom(izt+1:nz,:)=0;

     %% blur effect
     thrs=std(var,1,[2 3]);
     var01=var>repmat(thrs,[1 nx ny]); udfrac=sum(var01,[2 3]); [~,maxud_iz]=max(udfrac(1:izt));
     var01=var<repmat(-thrs,[1 nx ny]); ddfrac=sum(var01,[2 3]); [~,maxdd_iz]=max(ddfrac(1:izt)); 

     %% 1: updrafts
    iz=maxud_iz; % at max cloud cover height
    subplot(2,4,1); imagesc(xm/1000,ym/1000,squeeze(var(iz,:,:))>thrs(iz))
    ccout=binarize_periodic_3d(var,thrs); vol=volume_from_extended_objects(ccout,zm,xm,ym);
    nobjs(1)=ccout.NumObjects; tvol(1)=sum(vol)/1e9; title('No blur','Interpreter','latex')
    for iblr=1:5
    varb=imgaussfilt3(var,iblr); std_b=std(varb,0,[2 3],'omitnan');
    subplot(2,4,1+iblr+(iblr>2)); imagesc(xm/1000,ym/1000,squeeze(varb(iz,:,:))>std_b(iz))
    title(['$r_G=',num2str(iblr),'$'],'Interpreter','latex')
    ccout=binarize_periodic_3d(varb,std_b); vol=volume_from_extended_objects(ccout,zm,xm,ym); 
    nobjs(1+iblr)=ccout.NumObjects; tvol(1+iblr)=sum(vol)/1e9;
    end
    out(ieps).sensrgUD_nobjs=nobjs;
    out(ieps).sensrgUD_tvol=tvol;
%     subplot(244); plot(0:5,nobjs); ylabel('Number of objects','Interpreter','latex'); 
%     xlabel('Gaussian filter radius $r_G$','Interpreter','latex'); xticks([1 3 5])
%     subplot(248);  plot(0:5,tvol); ylabel('Total volume (km$^3$)','Interpreter','latex'); 
%     xlabel('Gaussian filter radius $r_G$','Interpreter','latex'); xticks([1 3 5])
%     subplot(241); ylabel('$y$ (km)','Interpreter','latex')
%     subplot(245); ylabel('$y$ (km)','Interpreter','latex'); xlabel('$x$ (km)','Interpreter','latex'); 
%     subplot(246); xlabel('$x$ (km)','Interpreter','latex'); 
%     subplot(247); xlabel('$x$ (km)','Interpreter','latex');
%     fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 8 3];
%     print([outpref,'_blureffectUD'],'-depsc'); close(1);
    %% 2: downdrafts
    iz=maxdd_iz; % at max cloud cover height
    subplot(2,4,1); imagesc(xm/1000,ym/1000,squeeze(var(iz,:,:))<-thrs(iz))
    ccout=binarize_periodic_3d(var,thrs); vol=volume_from_extended_objects(ccout,zm,xm,ym);
    nobjs(1)=ccout.NumObjects; tvol(1)=sum(vol)/1e9; title('No blur','Interpreter','latex')
    for iblr=1:5
    varb=imgaussfilt3(var,iblr); std_b=std(varb,0,[2 3],'omitnan');
    subplot(2,4,1+iblr+(iblr>2)); imagesc(xm/1000,ym/1000,squeeze(varb(iz,:,:))<-std_b(iz))
    title(['$r_G=',num2str(iblr),'$'],'Interpreter','latex')
    ccout=binarize_periodic_3d(-varb,std_b); vol=volume_from_extended_objects(ccout,zm,xm,ym); 
    nobjs(1+iblr)=ccout.NumObjects; tvol(1+iblr)=sum(vol)/1e9;
    end
    out(ieps).sensrgDD_nobjs=nobjs;
    out(ieps).sensrgDD_tvol=tvol;
    
%     subplot(244); plot(0:5,nobjs); ylabel('Number of objects','Interpreter','latex'); 
%     xlabel('Gaussian filter radius $r_G$','Interpreter','latex'); xticks([1 3 5])
%     subplot(248);  plot(0:5,tvol); ylabel('Total volume (km$^3$)','Interpreter','latex'); 
%     xlabel('Gaussian filter radius $r_G$','Interpreter','latex'); xticks([1 3 5])
%     subplot(241); ylabel('$y$ (km)','Interpreter','latex')
%     subplot(245); ylabel('$y$ (km)','Interpreter','latex'); xlabel('$x$ (km)','Interpreter','latex'); 
%     subplot(246); xlabel('$x$ (km)','Interpreter','latex'); 
%     subplot(247); xlabel('$x$ (km)','Interpreter','latex');
%     fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 8 3];
%     print([outpref,'_blureffectDD'],'-depsc'); close(1);
%  
%% distribution plot for blurred var
if doplots
contourf(0.5*(edgesb(2:end)+edgesb(1:end-1)),zm(1:izt),Nb_anom(1:izt,:),50,'LineStyle','none'); hold on
c=colorbar; xlabel ('Blurred w'' [m/s]'); ylabel('Height [m]'); c.Label.String='Number of counts';
plot([0 0],[0 zm(izt)],'w:')
plot(varb_std_all_z(1:izt),zm(1:izt),'w--','LineWidth',3)
plot(-varb_std_all_z(1:izt),zm(1:izt),'w--','LineWidth',3)
text(0.4,100,'$+\epsilon\sigma_w$','Interpreter','latex','Color','w','FontSize',20)
text(-0.7,100,'$-\epsilon\sigma_w$','Interpreter','latex','Color','w','FontSize',20)
print([outpref,'3dseg_w_',num2str(time,'%02i'),'_dist_wanomblurred_eps',num2str(epsSDthreshold)],'-depsc','-r600') ; close(1)
end
%% segmentation for var' blurred: UPDRAFTS
var_th=varb_std_all_z; %prctile(ql_pos,50);
if doplots
plot_slices_in_ABL(varb,var_th,zm)% slices using SD
print([outpref,'3dseg_wUD_',num2str(time,'%02i'),'_slicesSD_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end

% takes too long
plot_isosurface(varb,var_th,xm,ym,zm,'red')% isosurface using SD
% print([outpref,'3dseg_w_',casename,'_',num2str(time,'%02i'),'_isoSD'],'-depsc','-r600'); close(1)

% Get geometric properties only up to izt because above ABL is not needed
[ccout_UD,vol_UD,rp_UD]=get_geom_3d_properties(varb,var_th,zm,xm,ym,izt);

% plot of object "size" distribution and position
[z0_UD,dz_UD,Lh_UD]=plot_3dobjects_size_position(rp_UD,vol_UD,zm);
if doplots
print([outpref,'3dseg_wUD_',num2str(time,'%02i'),'_objsizedist_SD_eps',num2str(epsSDthreshold)],'-depsc','-r600'); 
end
close(1)

out(ieps).ccUD=ccout_UD; out(ieps).volUD=vol_UD; out(ieps).rpUD=rp_UD;
out(ieps).z0UD=z0_UD; out(ieps).dzUD=dz_UD; out(ieps).LhUD=Lh_UD;
% Is Lh constant? Nah, it's cuadratic because of the sqrt we used to define it
% plot(Lh,vol,'*'); xlabel('$L_h$ (km)','Interpreter','latex'); ylabel('$V$ (m$^3$)','Interpreter','latex')
% print([outpref,'3dseg_w_',casename,'_',num2str(time,'%02i'),'_objsizedist_SD_Lhvol'],'-depsc','-r600'); close(1)

% check dz distribution
f_large_UD=dz_UD/zm(izt)>0.5;
f_medium_UD=dz_UD/zm(izt)>0.2 & dz_UD/zm(izt)<=0.5;
f_small_UD=dz_UD/zm(izt)<0.2;
%%
if doplots
plot(sort(dz_UD/zm(izt))); hold on; plot(xlim,[0.2 0.2],'k--',xlim,[0.5 0.5],'k--',xlim,[0.5 0.5],'k--')
xlabel('Sorted objects'); ylabel('Sorted Δz/z_i'); 
text(10,0.8,'Large objects ~ whole ABL'); text(5,0.8,num2str(sum(f_large_UD)),'Color','r')
text(10,0.35,'Medium objects ~ almost half of the ABL'); text(5,0.35,num2str(sum(f_medium_UD)),'Color','r')
text(10,0.1,'Small objects ~ less than 1/5 of ABL'); text(5,0.1,num2str(sum(f_small_UD)),'Color','r')
print([outpref,'3dseg_wUD_',num2str(time,'%02i'),'_objdist_SD_dz_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)

subplot(131); histogram(Lh_UD(f_large_UD)); ylabel('Large Objects'); xlabel('L_h (km)')
subplot(132); histogram(z0_UD(f_medium_UD),10); ylabel('Medium Objects'); xlabel('Starting z (m)')
subplot(133); histogram(z0_UD(f_small_UD),10); ylabel('Small Objects'); xlabel('Starting z (m)')
print([outpref,'3dseg_wUD_',num2str(time,'%02i'),'_objdist_SD_classessize_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end
%%
f_largeThick_UD=f_large_UD & Lh_UD>=mean(Lh_UD(f_large_UD)); 
f_largeThin_UD=f_large_UD &  Lh_UD<mean(Lh_UD(f_large_UD));
f_mediumBottom_UD=f_medium_UD & z0_UD<zm(izb); % cloud base as threshold %z0/zm(izt)<0.5;
f_mediumTop_UD=f_medium_UD & z0_UD>=zm(izb); % cloud base as threshold %z0/zm(izt)>=0.5;
f_smallBottom_UD=f_small_UD & z0_UD<zm(izb); % cloud base as threshold %z0/zm(izt)<0.5;
f_smallTop_UD=f_small_UD & z0_UD>=zm(izb); % cloud base as threshold %z0/zm(izt)>=0.5;
filters_UD=[f_largeThick_UD, f_largeThin_UD, f_mediumBottom_UD,f_mediumTop_UD,f_smallBottom_UD,f_smallTop_UD];
out(ieps).filters_UD=filters_UD;
%% conditional sampling ww
[ww_cs_UD,ww]=get_cs_fluxes_wobjfilters(ccout_UD,filters_UD,w,w,izt,nz,nx,ny);
ww_UD=sum(ww_cs_UD,2); %all UD objects
if doplots
plot(ww_cs_UD,zm/zi); hold on; plot(ww_UD,zm/zi,'k--',ww,zm/zi,'k:')
legend('Large Thick','Large Thin','Medium Bottom','Medium Top', ...
    'Small Bottom','Small Top','Total updrafts','Total','Location','eastoutside')
xlabel('$\overline{w''w''}(z)$ (m$^2$ s$^{-2}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])
print([outpref,'3dseg_wUD_',num2str(time,'%02i'),'_objclass_ww_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end
%% conditional sampling wthetav
[wtv_cs_UD,wtv]=get_cs_fluxes_wobjfilters(ccout_UD,filters_UD,w,tv,izt,nz,nx,ny);
wtv_UD=sum(wtv_cs_UD,2);
if doplots
plot(wtv_cs_UD,zm/zi); hold on; plot(wtv_UD,zm/zi,'k--',wtv,zm/zi,'k:')
legend('Large Thick','Large Thin','Medium Bottom','Medium Top', ...
    'Small Bottom','Small Top','Total updrafts','Total','Location','eastoutside')
xlabel('$\overline{w''\theta_v''}(z)$ (m K s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])
print([outpref,'3dseg_wUD_',num2str(time,'%02i'),'_objclass_wtv_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end
%% conditional sampling wqt
[wqt_cs_UD,wqt]=get_cs_fluxes_wobjfilters(ccout_UD,filters_UD,w,qt,izt,nz,nx,ny);
wqt_UD=sum(wqt_cs_UD,2);
if doplots
plot(wqt_cs_UD,zm/zi); hold on; plot(wqt_UD,zm/zi,'k--',wqt,zm/zi,'k:')
legend('Large Thick','Large Thin','Medium Bottom','Medium Top', ...
    'Small Bottom','Small Top','Total updrafts','Total','Location','eastoutside')
xlabel('$\overline{w''q_t''}(z)$ (m s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])
print([outpref,'3dseg_wUD_',num2str(time,'%02i'),'_objclass_wqt_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end
%% conditional sampling wtl
[wtl_cs_UD,wtl]=get_cs_fluxes_wobjfilters(ccout_UD,filters_UD,w,tl,izt,nz,nx,ny);
wtl_UD=sum(wtl_cs_UD,2);
if doplots
plot(wtl_cs_UD,zm/zi); hold on; plot(wtl_UD,zm/zi,'k--',wtl,zm/zi,'k:')
legend('Large Thick','Large Thin','Medium Bottom','Medium Top', ...
    'Small Bottom','Small Top','Total updrafts','Total','Location','eastoutside')
xlabel('$\overline{w''\theta_l''}(z)$ (m K s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])
print([outpref,'3dseg_wUD_',num2str(time,'%02i'),'_objclass_wtl_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end
%% conditional sampling wql
[wql_cs_UD,wql]=get_cs_fluxes_wobjfilters(ccout_UD,filters_UD,w,ql,izt,nz,nx,ny);
wql_UD=sum(wql_cs_UD,2);
if doplots
plot(wql_cs_UD,zm/zi); hold on; plot(wql_UD,zm/zi,'k--',wql,zm/zi,'k:')
legend('Large Thick','Large Thin','Medium Bottom','Medium Top', ...
    'Small Bottom','Small Top','Total updrafts','Total','Location','eastoutside')
xlabel('$\overline{w''\theta_l''}(z)$ (m s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])
print([outpref,'3dseg_wUD_',num2str(time,'%02i'),'_objclass_wql_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end
%% conditional sampling wu and wv
[wu_cs_UD,wu]=get_cs_fluxes_wobjfilters(ccout_UD,filters_UD,w,u,izt,nz,nx,ny);
wu_UD=sum(wu_cs_UD,2);
[wv_cs_UD,wv]=get_cs_fluxes_wobjfilters(ccout_UD,filters_UD,w,v,izt,nz,nx,ny);
wv_UD=sum(wv_cs_UD,2);
r=sqrt(u.^2+v.^2);
[wr_cs_UD,wr]=get_cs_fluxes_wobjfilters(ccout_UD,filters_UD,w,r,izt,nz,nx,ny);
wr_UD=sum(wr_cs_UD,2);
%% using median
% var_th=prctile(varb,50,[2 3]); %a profile again
% 
% plot_slices_in_ABL(varb,var_th,zm)% slices using SD
% print([outpref,'3dseg_wUD_',casename,'_',num2str(time,'%02i'),'_slicesmedian'],'-depsc','-r600'); close(1)
% 
% % plot_isosurface(varb,var_th,xm,ym,zm)% isosurface using SD
% % print([outpref,'3dseg_wUD_',casename,'_',num2str(time,'%02i'),'_isomedian'],'-depsc','-r600'); close(1)
% 
% % Get geometric properties
% [ccout,vol,rp]=get_geom_3d_properties(varb,var_th,zm,xm,ym,izt)
% 
% % plot of object "size" distribution and position
% [z0,dz,Lh]=plot_3dobjects_size_position(rp,vol,zm);
% print([outpref,'3dseg_wUD_',casename,'_',num2str(time,'%02i'),'_objsizedist_median'],'-depsc','-r600'); close(1)

% Is Lh constant? Nah, it's cuadratic because of the sqrt we used to define it
% plot(Lh,vol,'*'); xlabel('$L_h$ (km)','Interpreter','latex'); ylabel('$V$ (m$^3$)','Interpreter','latex')
% print([outpref,'3dseg_w_',casename,'_',num2str(time,'%02i'),'_objsizedist_median_Lhvol'],'-depsc','-r600'); close(1)
% 
% 
% 
%         %%
%         winddir_avgcld=mean(winddir_z(izb:izt))*180/pi;
%         u_avgcld=mean(u_z(izb:izt));
%         v_avgcld=mean(v_z(izb:izt));
%     
%         subplot(131); plot(rp.Orientation(:,1),rp.Volume,'.'); xlabel('Orientation (deg)'); ylabel('Volume (voxels)')
%         subplot(132); plot(rp.Orientation(:,2),rp.Volume,'.'); xlabel('Orientation (deg)'); ylabel('Volume (voxels)')
%         subplot(133); plot(rp.Orientation(:,3),rp.Volume,'.'); xlabel('Orientation (deg)'); ylabel('Volume (voxels)')
% 
%         orient2=rp.Orientation(:,2)-winddir_avgcld;
%         orient2(orient2>90)=orient2(orient2>90)-90;
%         stats=prctile(orient2,[25 50 75]);
%         nobj=length(orient2);         
% 
%         close(1)
%% segmentation for var' blurred: DOWNDRAFTS
var_th=varb_std_all_z; %prctile(ql_pos,50);
if doplots
plot_slices_in_ABL(-varb,var_th,zm)% slices using SD
print([outpref,'3dseg_wDD_',num2str(time,'%02i'),'_slicesSD_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end
%plot_isosurface(-varb,var_th,xm,ym,zm)% isosurface using SD
%print([outpref,'3dseg_wDD_',casename,'_',num2str(time,'%02i'),'_isoSD'],'-depsc','-r600'); close(1)

% Get geometric properties
[ccout_DD,vol_DD,rp_DD]=get_geom_3d_properties(-varb,var_th,zm,xm,ym,izt);

% plot of object "size" distribution and position
[z0_DD,dz_DD,Lh_DD]=plot_3dobjects_size_position(rp_DD,vol_DD,zm);
if doplots
print([outpref,'3dseg_wDD_',num2str(time,'%02i'),'_objsizedist_SD_eps',num2str(epsSDthreshold)],'-depsc','-r600'); 
end
close(1)
out(ieps).ccDD=ccout_DD; out(ieps).volDD=vol_DD; out(ieps).rpDD=rp_DD;
out(ieps).z0DD=z0_DD; out(ieps).dzDD=dz_DD; out(ieps).LhDD=Lh_DD;

% check dz distribution
f_large_DD=dz_DD/zm(izt)>0.5;
f_medium_DD=dz_DD/zm(izt)>0.2 & dz_DD/zm(izt)<=0.5;
f_small_DD=dz_DD/zm(izt)<0.2;
%%
if doplots
plot(sort(dz_DD/zm(izt))); hold on; plot(xlim,[0.2 0.2],'k--',xlim,[0.5 0.5],'k--',xlim,[0.5 0.5],'k--')
xlabel('Sorted objects'); ylabel('Sorted Δz/z_i'); 
text(10,0.8,'Large objects ~ whole ABL'); text(5,0.8,num2str(sum(f_large_DD)),'Color','r')
text(10,0.35,'Medium objects ~ almost half of the ABL'); text(5,0.35,num2str(sum(f_medium_DD)),'Color','r')
text(10,0.1,'Small objects ~ less than 1/5 of ABL'); text(5,0.1,num2str(sum(f_small_DD)),'Color','r')
print([outpref,'3dseg_wDD_',num2str(time,'%02i'),'_objdist_SD_dz'],'-depsc','-r600'); close(1)

subplot(131); histogram(Lh_DD(f_large_DD)); ylabel('Large Objects'); xlabel('L_h (km)')
subplot(132); histogram(z0_DD(f_medium_DD),10); ylabel('Medium Objects'); xlabel('Ending z (m)')
subplot(133); histogram(z0_DD(f_small_DD),10); ylabel('Small Objects'); xlabel('Ending z (m)')
print([outpref,'3dseg_wDD_',num2str(time,'%02i'),'_objdist_SD_classessize_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end
%%
f_largeThick_DD=f_large_DD & Lh_DD>=mean(Lh_DD(f_large_DD)); 
f_largeThin_DD=f_large_DD &  Lh_DD<mean(Lh_DD(f_large_DD));
f_mediumBottom_DD=f_medium_DD & z0_DD+dz_DD<zm(izb); % cloud base as threshold % z0/zm(izt)<0.5;
f_mediumTop_DD=f_medium_DD & z0_DD+dz_DD>=zm(izb); % cloud base as threshold % z0/zm(izt)>=0.5;
f_smallBottom_DD=f_small_DD & z0_DD+dz_DD<zm(izb); % cloud base as threshold % z0/zm(izt)<0.5;
f_smallTop_DD=f_small_DD & z0_DD+dz_DD>=zm(izb); % cloud base as threshold % z0/zm(izt)>=0.5;
filters_DD=[f_largeThick_DD, f_largeThin_DD, f_mediumBottom_DD,f_mediumTop_DD,f_smallBottom_DD,f_smallTop_DD];
out(ieps).filters_DD=filters_DD;
%% conditional sampling ww
[ww_cs_DD,ww]=get_cs_fluxes_wobjfilters(ccout_DD,filters_DD,w,w,izt,nz,nx,ny);
ww_DD=sum(ww_cs_DD,2);
ww_res=ww-ww_DD-ww_UD; %residual
Rww_res=ww_res(2:izt)./ww(2:izt); Rww_res_avg=mean(Rww_res);
Rww_UD=ww_UD(2:izt)./ww(2:izt); Rww_UD_avg=mean(Rww_UD);
Rww_DD=ww_DD(2:izt)./ww(2:izt); Rww_DD_avg=mean(Rww_DD);

%%
subplot(211); rectangle('Position',[0 zb/zi .6 (zi-zb)/zi],'FaceColor',[.9 .9 .9],'EdgeColor','none'); hold on
plot(ww_UD,zm/zi,'r',ww_DD,zm/zi,'b',ww_res,zm/zi,'k',ww,zm/zi,'k--')
xlabel('$\overline{w''w''}(z)$ (m$^2$ s$^{-2}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1]); legend('UD','DD','Residual','Total','Location','eastoutside')
title(['Threshold: $',num2str(epsSDthreshold),'\sigma_w(z)$'],'Interpreter','latex')

subplot(212); rectangle('Position',[0 zm(izb)/zi 1 (zi-zm(izb))/zi],'FaceColor',[.9 .9 .9],'EdgeColor','none'); hold on
plot(Rww_UD,zm(2:izt)/zi,'r',Rww_DD,zm(2:izt)/zi,'b',Rww_res,zm(2:izt)/zi,'k')
xlabel('Fraction of $\overline{w''w''}(z)$','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1]); xlim([0 1]);legend('UD','DD','Residual','Location','eastoutside')
title(['Threshold: $',num2str(epsSDthreshold),'\sigma_w(z)$'],'Interpreter','latex')

print([outpref,'3dseg_wDD_',num2str(time,'%02i'),'_objclass_wwres_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)

%%
if doplots
plot(ww_cs_DD,zm/zi); hold on; plot(ww_DD,zm/zi,'k--',ww,zm/zi,'k:')
legend('Large Thick','Large Thin','Medium Bottom','Medium Top', ...
    'Small Bottom','Small Top','Total downdrafts','Total','Location','eastoutside')
xlabel('$\overline{w''w''}(z)$ (m$^2$ s$^{-2}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])
print([outpref,'3dseg_wDD_',num2str(time,'%02i'),'_objclass_ww_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end
%% conditional sampling wthetav
[wtv_cs_DD,wtv]=get_cs_fluxes_wobjfilters(ccout_DD,filters_DD,w,tv,izt,nz,nx,ny);
wtv_DD=sum(wtv_cs_DD,2);
wtv_res=wtv-wtv_DD-wtv_UD; %residual
Rwtv_res=wtv_res(2:izt)./wtv(2:izt); Rwtv_res_avg=mean(Rwtv_res); Rwtv_res_avgsubcloud=mean(Rwtv_res(1:izb-2)); Rwtv_res_avgincloud=mean(Rwtv_res(izb-1:izt-1));
Rwtv_UD=wtv_UD(2:izt)./wtv(2:izt); Rwtv_UD_avg=mean(Rwtv_UD); Rwtv_UD_avgsubcloud=mean(Rwtv_UD(1:izb-2)); Rwtv_UD_avgincloud=mean(Rwtv_UD(izb-1:izt-1)); 
Rwtv_DD=wtv_DD(2:izt)./wtv(2:izt); Rwtv_DD_avg=mean(Rwtv_DD); Rwtv_DD_avgsubcloud=mean(Rwtv_DD(1:izb-2)); Rwtv_DD_avgincloud=mean(Rwtv_DD(izb-1:izt-1)); 

%%
if doplots
subplot(211); rectangle('Position',[-.025 zm(izb)/zi .075 (zi-zm(izb))/zi],'FaceColor',[.9 .9 .9],'EdgeColor','none'); hold on
plot(wtv_UD,zm/zi,'r',wtv_DD,zm/zi,'b',wtv_res,zm/zi,'k',wtv,zm/zi,'k--')
xlabel('$\overline{w''\theta_v''}(z)$ (m K s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1]); xlim([-.025 .05]); legend('UD','DD','Residual','Total','Location','eastoutside')
title(['Threshold: $',num2str(epsSDthreshold),'\sigma_w(z)$'],'Interpreter','latex')

subplot(212);  rectangle('Position',[-.5 zm(izb)/zi 2 (zi-zm(izb))/zi],'FaceColor',[.9 .9 .9],'EdgeColor','none'); hold on
plot(Rwtv_UD,zm(2:izt)/zi,'r',Rwtv_DD,zm(2:izt)/zi,'b',Rwtv_res,zm(2:izt)/zi,'k')
xlabel('Fraction of $\overline{w''\theta_v''}(z)$ (m K s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1]); xlim([-.5 1.5]);legend('UD','DD','Residual','Location','eastoutside')
title(['Threshold: $',num2str(epsSDthreshold),'\sigma_w(z)$'],'Interpreter','latex')
print([outpref,'3dseg_wDD_',num2str(time,'%02i'),'_objclass_wtvres_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end
%%
if doplots
plot(wtv_cs_DD,zm/zi); hold on; plot(wtv_DD,zm/zi,'k--',wtv,zm/zi,'k:')
legend('Large Thick','Large Thin','Medium Bottom','Medium Top', ...
    'Small Bottom','Small Top','Total downdrafts','Total','Location','eastoutside')
xlabel('$\overline{w''\theta_v''}(z)$ (m K s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])
print([outpref,'3dseg_wDD_',num2str(time,'%02i'),'_objclass_wtv_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end
%% conditional sampling wqt
[wqt_cs_DD,wqt]=get_cs_fluxes_wobjfilters(ccout_DD,filters_DD,w,qt,izt,nz,nx,ny);
wqt_DD=sum(wqt_cs_DD,2);
wqt_res=wqt-wqt_DD-wqt_UD; %residual
Rwqt_res=wqt_res(2:izt)./wqt(2:izt); Rwqt_res_avg=mean(Rwqt_res); %Rwtv_res_avgsubcloud=mean(Rwtv_res(1:izb-2)); Rwtv_res_avgincloud=mean(Rwtv_res(izb-1:izt-1));
Rwqt_UD=wqt_UD(2:izt)./wqt(2:izt); Rwqt_UD_avg=mean(Rwqt_UD); %Rwtv_UD_avgsubcloud=mean(Rwtv_UD(1:izb-2)); Rwtv_UD_avgincloud=mean(Rwtv_UD(izb-1:izt-1)); 
Rwqt_DD=wqt_DD(2:izt)./wqt(2:izt); Rwqt_DD_avg=mean(Rwqt_DD); %Rwtv_DD_avgsubcloud=mean(Rwtv_DD(1:izb-2)); Rwtv_DD_avgincloud=mean(Rwtv_DD(izb-1:izt-1)); 

%%
if doplots
subplot(211); rectangle('Position',[0 zm(izb)/zi 5e-5 (zi-zm(izb))/zi],'FaceColor',[.9 .9 .9],'EdgeColor','none'); hold on
plot(wqt_UD,zm/zi,'r',wqt_DD,zm/zi,'b',wqt_res,zm/zi,'k',wqt,zm/zi,'k--')
xlabel('$\overline{w''q_t''}(z)$ (m s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1]); xlim([0 5e-5]); legend('UD','DD','Residual','Total','Location','eastoutside')
title(['Threshold: $',num2str(epsSDthreshold),'\sigma_w(z)$'],'Interpreter','latex')

subplot(212);  rectangle('Position',[0 zm(izb)/zi 1 (zi-zm(izb))/zi],'FaceColor',[.9 .9 .9],'EdgeColor','none'); hold on
plot(Rwqt_UD,zm(2:izt)/zi,'r',Rwqt_DD,zm(2:izt)/zi,'b',Rwqt_res,zm(2:izt)/zi,'k')
xlabel('Fraction of $\overline{w''q_t''}(z)$ (m s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1]); xlim([0 1]);legend('UD','DD','Residual','Location','eastoutside')
title(['Threshold: $',num2str(epsSDthreshold),'\sigma_w(z)$'],'Interpreter','latex')
print([outpref,'3dseg_wDD_',num2str(time,'%02i'),'_objclass_wqtres_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end
%%
if doplots
plot(wqt_cs_DD,zm/zi); hold on; plot(wqt_DD,zm/zi,'k--',wqt,zm/zi,'k:')
legend('Large Thick','Large Thin','Medium Bottom','Medium Top', ...
    'Small Bottom','Small Top','Total downdrafts','Total','Location','eastoutside')
xlabel('$\overline{w''q_t''}(z)$ (m s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])
print([outpref,'3dseg_wDD_',num2str(time,'%02i'),'_objclass_wqt_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end
%% conditional sampling wtl
[wtl_cs_DD,wtl]=get_cs_fluxes_wobjfilters(ccout_DD,filters_DD,w,tl,izt,nz,nx,ny);
wtl_DD=sum(wtl_cs_DD,2);
wtl_res=wtl-wtl_DD-wtl_UD; %residual
Rwtl_res=wtl_res(2:izt-1)./wtl(2:izt-1); Rwtl_res(abs(Rwtl_res)>10)=0; Rwtl_res_avg=mean(Rwtl_res); %Rwtv_res_avgsubcloud=mean(Rwtv_res(1:izb-2)); Rwtv_res_avgincloud=mean(Rwtv_res(izb-1:izt-1));
Rwtl_UD=wtl_UD(2:izt-1)./wtl(2:izt-1); Rwtl_UD(abs(Rwtl_UD)>10)=0; Rwtl_UD_avg=mean(Rwtl_UD); %Rwtv_UD_avgsubcloud=mean(Rwtv_UD(1:izb-2)); Rwtv_UD_avgincloud=mean(Rwtv_UD(izb-1:izt-1)); 
Rwtl_DD=wtl_DD(2:izt-1)./wtl(2:izt-1); Rwtl_DD(abs(Rwtl_DD)>10)=0; Rwtl_DD_avg=mean(Rwtl_DD); %Rwtv_DD_avgsubcloud=mean(Rwtv_DD(1:izb-2)); Rwtv_DD_avgincloud=mean(Rwtv_DD(izb-1:izt-1)); 

%%
if doplots
subplot(211); rectangle('Position',[-.05 zm(izb)/zi .07 (zi-zm(izb))/zi],'FaceColor',[.9 .9 .9],'EdgeColor','none'); hold on
plot(wtl_UD,zm/zi,'r',wtl_DD,zm/zi,'b',wtl_res,zm/zi,'k',wtl,zm/zi,'k--')
xlabel('$\overline{w''\theta_l''}(z)$ (m K s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1]); xlim([-.05 .02]); legend('UD','DD','Residual','Total','Location','eastoutside')
title(['Threshold: $',num2str(epsSDthreshold),'\sigma_w(z)$'],'Interpreter','latex')

subplot(212);  rectangle('Position',[-1 zm(izb)/zi 2.5 (zi-zm(izb))/zi],'FaceColor',[.9 .9 .9],'EdgeColor','none'); hold on
plot(Rwtl_UD,zm(2:izt-1)/zi,'r',Rwtl_DD,zm(2:izt-1)/zi,'b',Rwtl_res,zm(2:izt-1)/zi,'k')
xlabel('Fraction of $\overline{w''\theta_l''}(z)$ (m K s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1]); xlim([-1 1.5]);legend('UD','DD','Residual','Location','eastoutside')
title(['Threshold: $',num2str(epsSDthreshold),'\sigma_w(z)$'],'Interpreter','latex')
print([outpref,'3dseg_wDD_',num2str(time,'%02i'),'_objclass_wtlres_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end
%%
if doplots
plot(wtl_cs_DD,zm/zi); hold on; plot(wtl_DD,zm/zi,'k--',wtl,zm/zi,'k:')
legend('Large Thick','Large Thin','Medium Bottom','Medium Top', ...
    'Small Bottom','Small Top','Total downdrafts','Total','Location','eastoutside')
xlabel('$\overline{w''\theta_l''}(z)$ (m K s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])
print([outpref,'3dseg_wDD_',num2str(time,'%02i'),'_objclass_wtl_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end
%% conditional sampling wql
[wql_cs_DD,wql]=get_cs_fluxes_wobjfilters(ccout_DD,filters_DD,w,ql,izt,nz,nx,ny);
wql_DD=sum(wql_cs_DD,2);
if doplots
plot(wql_cs_DD,zm/zi); hold on; plot(wql_DD,zm/zi,'k--',wql,zm/zi,'k:')
legend('Large Thick','Large Thin','Medium Bottom','Medium Top', ...
    'Small Bottom','Small Top','Total downdrafts','Total','Location','eastoutside')
xlabel('$\overline{w''\theta_l''}(z)$ (m K s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])
print([outpref,'3dseg_wDD_',num2str(time,'%02i'),'_objclass_wql_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end

%% conditional sampling wu and wv
[wu_cs_DD,wu]=get_cs_fluxes_wobjfilters(ccout_DD,filters_DD,w,u,izt,nz,nx,ny);
wu_DD=sum(wu_cs_DD,2);
[wv_cs_DD,wv]=get_cs_fluxes_wobjfilters(ccout_DD,filters_DD,w,v,izt,nz,nx,ny);
wv_DD=sum(wv_cs_DD,2);
% r=sqrt(u.^2+v.^2);
[wr_cs_DD,wr]=get_cs_fluxes_wobjfilters(ccout_DD,filters_DD,w,r,izt,nz,nx,ny);
wr_DD=sum(wr_cs_DD,2);

%% updrafts and downdrafts total/just Large Thick
if doplots
subplot(121); plot(ww_cs_UD(:,1),zm/zi,'r--',ww_cs_DD(:,1),zm/zi,'b--', ...
    ww_cs_DD(:,1)+ww_cs_UD(:,1),zm/zi,'k--',ww,zm/zi,'k:')
xlabel('$\overline{w''w''}(z)$ (m$^2$ s$^{-2}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.3])
legend('All UD','All DD','All UD+DD','Total')
subplot(122); plot(ww_UD,zm/zi,'r--',ww_DD,zm/zi,'b--',ww_DD+ww_UD,zm/zi,'k--',ww,zm/zi,'k:')
xlabel('$\overline{w''\theta_v''}(z)$ (m K s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.3])
legend('LargeThick UD','LargeThick DD','LargeThick UD+DD','Total')
print([outpref,'3dseg_wUDDD_',num2str(time,'%02i'),'_objclass_ww_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)

%% updrafts and downdrafts total/just Large Thick
subplot(121); plot(wtv_cs_UD(:,1),zm/zi,'r--',wtv_cs_DD(:,1),zm/zi,'b--',wtv_cs_DD(:,1)+wtv_cs_UD(:,1),zm/zi,'k--',wtv,zm/zi,'k:')
xlabel('$\overline{w''\theta_v''}(z)$ (m K s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.3])
legend('All UD','All DD','All UD+DD','Total')
subplot(122); plot(wtv_UD,zm/zi,'r--',wtv_DD,zm/zi,'b--',wtv_DD+wtv_UD,zm/zi,'k--',wtv,zm/zi,'k:')
xlabel('$\overline{w''\theta_v''}(z)$ (m K s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.3])
legend('LargeThick UD','LargeThick DD','LargeThick UD+DD','Total')
print([outpref,'3dseg_wUDDD_',num2str(time,'%02i'),'_objclass_wtv_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)

%% updrafts and downdrafts total/just Large Thick
subplot(121); plot(wqt_cs_UD(:,1),zm/zi,'r--',wqt_cs_DD(:,1),zm/zi,'b--', ...
    wqt_cs_DD(:,1)+wqt_cs_UD(:,1),zm/zi,'k--',wqt,zm/zi,'k:')
xlabel('$\overline{w''q_t''}(z)$ (m s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.3])
legend('All UD','All DD','All UD+DD','Total')
subplot(122); plot(wqt_UD,zm/zi,'r--',wqt_DD,zm/zi,'b--',wqt_DD+wqt_UD,zm/zi,'k--',wqt,zm/zi,'k:')
xlabel('$\overline{w''q_t''}(z)$ (m s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.3])
legend('LargeThick UD','LargeThick DD','LargeThick UD+DD','Total')
print([outpref,'3dseg_wUDDD_',num2str(time,'%02i'),'_objclass_wqt_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)

%% updrafts and downdrafts total/just Large Thick
subplot(121); plot(wtl_cs_UD(:,1),zm/zi,'r--',wtl_cs_DD(:,1),zm/zi,'b--', ...
    wtl_cs_DD(:,1)+wtl_cs_UD(:,1),zm/zi,'k--',wtl,zm/zi,'k:')
xlabel('$\overline{w''\theta_l''}(z)$ (m K s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.3])
legend('All UD','All DD','All UD+DD','Total')
subplot(122); plot(wtl_UD,zm/zi,'r--',wtl_DD,zm/zi,'b--',wtl_DD+wtl_UD,zm/zi,'k--',wtl,zm/zi,'k:')
xlabel('$\overline{w''\theta_l''}(z)$ (m K s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.3])
legend('LargeThick UD','LargeThick DD','LargeThick UD+DD','Total')
print([outpref,'3dseg_wUDDD_',num2str(time,'%02i'),'_objclass_wtl_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)

%% updrafts and downdrafts total/just Large Thick
subplot(121); plot(wql_cs_UD(:,1),zm/zi,'r--',wql_cs_DD(:,1),zm/zi,'b--', ...
    wql_cs_DD(:,1)+wql_cs_UD(:,1),zm/zi,'k--',wql,zm/zi,'k:')
xlabel('$\overline{w''q_l''}(z)$ (m s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.3])
legend('All UD','All DD','All UD+DD','Total')
subplot(122); plot(wql_UD,zm/zi,'r--',wql_DD,zm/zi,'b--',wql_DD+wql_UD,zm/zi,'k--',wql,zm/zi,'k:')
xlabel('$\overline{w''q_l''}(z)$ (m s$^{-1}$)','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.3])
legend('LargeThick UD','LargeThick DD','LargeThick UD+DD','Total')
print([outpref,'3dseg_wUDDD_',num2str(time,'%02i'),'_objclass_wql_eps',num2str(epsSDthreshold)],'-depsc','-r600'); close(1)
end

%% grab mean fraction values
frac_res_ww(ieps)=Rww_res_avg; frac_UD_ww(ieps)=Rww_UD_avg; frac_DD_ww(ieps)=Rww_DD_avg;
frac_res_wqt(ieps)=Rwqt_res_avg; frac_UD_wqt(ieps)=Rwqt_UD_avg; frac_DD_wqt(ieps)=Rwqt_DD_avg;
frac_res_wtl(ieps)=Rwtl_res_avg; frac_UD_wtl(ieps)=Rwtl_UD_avg; frac_DD_wtl(ieps)=Rwtl_DD_avg;
frac_res_wtv(ieps)=Rwtv_res_avg; frac_UD_wtv(ieps)=Rwtv_UD_avg; frac_DD_wtv(ieps)=Rwtv_DD_avg;

out(ieps).ww_res=ww_res; out(ieps).ww_DD=ww_DD; out(ieps).ww_UD=ww_UD; out(ieps).ww=ww;
out(ieps).ww_cs_UD=ww_cs_UD; out(ieps).ww_cs_DD=ww_cs_DD; 
out(ieps).wqt_res=wqt_res; out(ieps).wqt_DD=wqt_DD; out(ieps).wqt_UD=wqt_UD; out(ieps).wqt=wqt;
out(ieps).wqt_cs_UD=wqt_cs_UD; out(ieps).wqt_cs_DD=wqt_cs_DD; 
out(ieps).wtl_res=wtl_res; out(ieps).wtl_DD=wtl_DD; out(ieps).wtl_UD=wtl_UD; out(ieps).wtl=wtl;
out(ieps).wtl_cs_UD=wtl_cs_UD; out(ieps).wtl_cs_DD=wtl_cs_DD; 
out(ieps).wtv_res=wtv_res; out(ieps).wtv_DD=wtv_DD; out(ieps).wtv_UD=wtv_UD; out(ieps).wtv=wtv;
out(ieps).wtv_cs_UD=wtv_cs_UD; out(ieps).wtv_cs_DD=wtv_cs_DD; 
out(ieps).wu_DD=wu_DD; out(ieps).wu_UD=wu_UD; out(ieps).wu=wu;
out(ieps).wu_cs_UD=wu_cs_UD; out(ieps).wu_cs_DD=wu_cs_DD; 
out(ieps).wv_DD=wv_DD; out(ieps).wv_UD=wv_UD; out(ieps).wv=wv;
out(ieps).wv_cs_UD=wv_cs_UD; out(ieps).wv_cs_DD=wv_cs_DD; 
out(ieps).wr_DD=wr_DD; out(ieps).wr_UD=wr_UD; out(ieps).wr=wr;
out(ieps).wr_cs_UD=wr_cs_UD; out(ieps).wr_cs_DD=wr_cs_DD; 

%end %ieps
%%
if doplots
subplot(141); plot(epss,frac_res_ww,'k.-',epss,frac_UD_ww,'r.-',epss,frac_DD_ww,'b.-',epss,frac_DD_ww+frac_UD_ww,'m.-'); xlabel('\epsilon'); ylabel('Avg. fraction of $\overline{w''w''}$','Interpreter','latex')
subplot(142); plot(epss,frac_res_wqt,'k.-',epss,frac_UD_wqt,'r.-',epss,frac_DD_wqt,'b.-',epss,frac_DD_wqt+frac_UD_wqt,'m.-'); xlabel('\epsilon'); ylabel('Avg. fraction of $\overline{w''q_t''}$','Interpreter','latex')
subplot(143); plot(epss,frac_res_wtl,'k.-',epss,frac_UD_wtl,'r.-',epss,frac_DD_wtl,'b.-',epss,frac_DD_wtl+frac_UD_wtl,'m.-'); xlabel('\epsilon'); ylabel('Avg. fraction of $\overline{w''\theta_l''}$','Interpreter','latex')
subplot(144); plot(epss,frac_res_wtv,'k.-',epss,frac_UD_wtv,'r.-',epss,frac_DD_wtv,'b.-',epss,frac_DD_wtv+frac_UD_wtv,'m.-'); xlabel('\epsilon'); ylabel('Avg. fraction of $\overline{w''\theta_v''}$','Interpreter','latex')
legend('Residual','Updraft','Downdraft','UD+DD')
% save([outpref,'3dseg_wUDDD_',casename,'_',num2str(time,'%02i'),'_data'],'out');
close(1)
end

%%
% Is Lh constant? Nah, it's cuadratic because of the sqrt we used to define it
% plot(Lh,vol,'*'); xlabel('$L_h$ (km)','Interpreter','latex'); ylabel('$V$ (m$^3$)','Interpreter','latex')
% print([outpref,'3dseg_w_',casename,'_',num2str(time,'%02i'),'_objsizedist_SD_Lhvol'],'-depsc','-r600'); close(1)

% %% using median
% var_th=prctile(-varb,50,'all');
% 
% plot_slices_in_ABL(-varb,var_th,zm)% slices using SD
% print([outpref,'3dseg_wDD_',casename,'_',num2str(time,'%02i'),'_slicesmedian'],'-depsc','-r600'); close(1)
% 
% % plot_isosurface(-varb,var_th,xm,ym,zm)% isosurface using SD
% % print([outpref,'3dseg_wDD_',casename,'_',num2str(time,'%02i'),'_isomedian'],'-depsc','-r600'); close(1)
% 
% % Get geometric properties
% [ccout,vol,rp]=get_geom_3d_properties(-varb,var_th,zm,xm,ym,izt)
% 
% % plot of object "size" distribution and position
% [z0,dz,Lh]=plot_3dobjects_size_position(rp,vol,zm);
% print([outpref,'3dseg_wDD_',casename,'_',num2str(time,'%02i'),'_objsizedist_median'],'-depsc','-r600'); close(1)
% 
% % Is Lh constant? Nah, it's cuadratic because of the sqrt we used to define it
% % plot(Lh,vol,'*'); xlabel('$L_h$ (km)','Interpreter','latex'); ylabel('$V$ (m$^3$)','Interpreter','latex')
% % print([outpref,'3dseg_w_',casename,'_',num2str(time,'%02i'),'_objsizedist_median_Lhvol'],'-depsc','-r600'); close(1)


% end
    
%     subplot(121); plot(percs,stats','.-'); legend('p25','p50','p75')
%     xlabel('Threshold percentile'); ylabel('Object orientation w.r.t. mean wind (deg)')
%     subplot(122); plot(percs,nobj); xlabel('Threshold percentile'); ylabel('Number of objects')