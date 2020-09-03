function obj_ql=segmentation_3d_ql(ql,zm,xm,ym,izb,izt,outpref,time,winddir_z,u_z,v_z,iz_nqlmax,w,tv,tl,qt,ps)
doplots=0;

%% Setup
nx=length(xm); ny=length(ym); nz=length(zm);
ql_mean=mean(ql,[2 3]); %avg in the z direction for cloudy and clear parts
qlpos=ql; qlpos(ql==0)=nan;
qlcld_mean=nanmean(qlpos,[2 3]); qlcld_mean(isnan(qlcld_mean))=0;% only for ql>0 parts

if doplots
% plot mean ql(z) profiles:
figure(1); plot(ql_mean,zm,qlcld_mean,zm); xlabel('Mean q_l [kg/kg]'); ylabel('Height [m]'); legend('All points','Only cloudy points')
print([outpref,'3dseg_ql_',num2str(time,'%02i'),'_qlmeanz'],'-depsc','-r600'); close(1)
end
obj_ql.ql_mean=ql_mean;
obj_ql.qlcld_mean=qlcld_mean;

% get cloud fraction in z and ql'
cldfrc_z=zeros(size(zm));
ql_anom=zeros(size(ql));
for iz=izb:izt
    qlxy=squeeze(ql(iz,:,:));
    ql_anom_xy=qlxy-qlcld_mean(iz);
    ql_anom_xy(qlxy==0)=nan; %fill clear points with nan (will be rewritten later)
    ql_anom(iz,:,:)=ql_anom_xy; %append slice
    cldfrc_z(iz)=sum(qlxy>0,'all')/(nx*ny);
end

%% get ql' distributions
ql_anom_min=min(ql_anom,[],'all'); %overall min of ql'
ql_anom_max=max(ql_anom,[],'all'); %overall max of ql'
edges=linspace(ql_anom_min,ql_anom_max,40); edgesql=linspace(0,max(qlpos,[],'all'),40);
for iz=izb:izt
    Nql(iz,:)=histcounts(qlpos(iz,:,:),edgesql);
    N(iz,:)=histcounts(ql_anom(iz,:,:),edges);
    n_cld(iz)=sum(~isnan(ql_anom(iz,:,:)),'all');
    N_norm(iz,:)=N(iz,:)./n_cld(iz);
    Nql_norm(iz,:)=Nql(iz,:)./n_cld(iz);
end

if doplots
%% check distribution of cloudy ql(z)
subplot('Position',[.05 .15 .33 .75]); contourf(0.5*(edgesql(2:end)+edgesql(1:end-1)),zm(izb:izt),Nql(izb:izt,:),10,'LineStyle','none'); c=colorbar; xlabel ('q_l [kg/kg]'); ylabel('Height [m]'); c.Label.String='Number of counts';
subplot('Position',[.44 .15 .13 .75]); plot(n_cld(izb:izt),zm(izb:izt)); xlabel('Number of cloudy points'); ylabel('Height [m]')
subplot('Position',[.64 .15 .33 .75]); contourf(0.5*(edgesql(2:end)+edgesql(1:end-1)),zm(izb:izt),Nql_norm(izb:izt,:),10,'LineStyle','none'); c=colorbar; xlabel ('q_l [kg/kg]'); ylabel('Height [m]'); c.Label.String='Count fraction by height';
print([outpref,'3dseg_ql_',num2str(time,'%02i'),'_dist_cloudyql'],'-depsc','-r600'); close(1)
%% check distribution of cloudy ql'(z) 
subplot('Position',[.05 .15 .33 .75]); contourf(0.5*(edges(2:end)+edges(1:end-1)),zm(izb:izt),N(izb:izt,:),'LineStyle','none'); c=colorbar; xlabel ('q_l'' [kg/kg]'); ylabel('Height [m]'); c.Label.String='Number of counts';
subplot('Position',[.44 .15 .13 .75]); plot(n_cld(izb:izt),zm(izb:izt)); xlabel('Number of cloudy points'); ylabel('Height [m]')
subplot('Position',[.64 .15 .33 .75]); contourf(0.5*(edges(2:end)+edges(1:end-1)),zm(izb:izt),N_norm(izb:izt,:),'LineStyle','none'); c=colorbar; xlabel ('q_l'' [kg/kg]'); ylabel('Height [m]'); c.Label.String='Count fraction by height';
print([outpref,'3dseg_ql_',num2str(time,'%02i'),'_dist_cloudyqlanom'],'-depsc','-r600'); close(1)
end
    
    %% segmentation  ql' blurred
    ql_anom_filled=ql_anom; 
    ql_anom_filled(isnan(ql_anom))=ql_anom_min; %fill clear points for blurring --> gives very skewed distribution
        
    %% blur effect
    iz=iz_nqlmax; % at max cloud cover height
    std_qlanom=std(ql_anom_filled,0,[2 3],'omitnan');
%     subplot(2,4,1); imagesc(xm/1000,ym/1000,squeeze(ql_anom_filled(iz,:,:))>std_qlanom(iz))
    ccout=binarize_periodic_3d(ql_anom_filled,std_qlanom); vol=volume_from_extended_objects(ccout,zm,xm,ym);
    nobjs(1)=ccout.NumObjects; tvol(1)=sum(vol)/1e9;
%     title('No blur','Interpreter','latex')
    for iblr=1:5
    qlb=imgaussfilt3(ql_anom_filled,iblr); qlb(isnan(ql_anom))=nan;
    std_qlb=std(qlb,0,[2 3],'omitnan');
%     subplot(2,4,1+iblr+(iblr>2)); imagesc(xm/1000,ym/1000,squeeze(qlb(iz,:,:))>std_qlb(iz))
%     title(['$r_G=',num2str(iblr),'$'],'Interpreter','latex')
    ccout=binarize_periodic_3d(qlb,std_qlb); 
    vol=volume_from_extended_objects(ccout,zm,xm,ym); 
    nobjs(1+iblr)=ccout.NumObjects; tvol(1+iblr)=sum(vol)/1e9;
    end
%     subplot(244); plot(0:5,nobjs); ylabel('Number of objects','Interpreter','latex'); 
%     xlabel('Gaussian filter radius $r_G$','Interpreter','latex'); xticks([1 3 5])
%     subplot(248);  plot(0:5,tvol); ylabel('Total volume (km$^3$)','Interpreter','latex'); 
%     xlabel('Gaussian filter radius $r_G$','Interpreter','latex'); xticks([1 3 5])
%     subplot(241); ylabel('$y$ (km)','Interpreter','latex')
%     subplot(245); ylabel('$y$ (km)','Interpreter','latex'); xlabel('$x$ (km)','Interpreter','latex'); 
%     subplot(246); xlabel('$x$ (km)','Interpreter','latex'); 
%     subplot(247); xlabel('$x$ (km)','Interpreter','latex');
%     fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 8 3];
%     print([outpref,'ql_blureffect'],'-depsc'); close(1);
    obj_ql.sensrg_nobjs=nobjs;
    obj_ql.sensrg_tvol=tvol;
    
    %% blur it
    qlb=imgaussfilt3(ql_anom_filled,3); %blur it
    qlb(isnan(ql_anom))=nan; %re populate clear regions with nans
    std_qlanom=std(qlb,0,[2 3],'omitnan'); % SD of positive values of qlanom
    
    %% get ql' blurred distributions
    ql_0=min(qlb,[],'all'); %overall min of ql'
    ql_1=max(qlb,[],'all'); %overall max of ql'
    if doplots
    edges=linspace(ql_0,ql_1,40); N=zeros(length(zm),length(edges)-1);
    for iz=izb:izt
        N(iz,:)=histcounts(qlb(iz,:,:),edges);
    end
    contourf(0.5*(edges(2:end)+edges(1:end-1)),zm(izb:izt),N(izb:izt,:),10,'LineStyle','none'); c=colorbar; xlabel ('Blurred q_l'' [kg/kg]'); ylabel('Height [m]'); c.Label.String='Number of counts';
    print([outpref,'3dseg_ql_',num2str(time,'%02i'),'_dist_cloudyqlanomblur'],'-depsc','-r600'); close(1)
    end
  
    ql_th=std_qlanom; %prctile(qlb,perc,'all');

    %% isosurface
%     qlp=permute(qlb,[2 3 1]); %permute because uclales is z.x.y
%     p = patch(isosurface(xm,ym,zm,qlp,ql_th));
%     isonormals(xm/1000,ym/1000,zm/zm(izt),qlp,p); p.FaceColor = 'yellow'; p.EdgeColor = 'none';
%     daspect([1 1 100]); view(30,45); axis tight; camlight; lighting gouraud;
%     xlabel('x [km]'); ylabel('y [km]'); zlabel('z/z_i'); title(['q_l'' > ',num2str(ql_th)])
%     savefig([outpref,'3dseg_ql_',casename,'_',num2str(time,'%02i'),'_isomedian'])
%     print([outpref,'3dseg_ql_',casename,'_',num2str(time,'%02i'),'_isomedian'],'-depsc','-r600'); close(1)

    %% account for periodicity and get geometric properties
    ccout=binarize_periodic_3d(qlb,ql_th);
    vol=volume_from_extended_objects(ccout,zm,xm,ym); 
    ftoosmall=vol/1e9<0.25; % remove objs with volume lower than 0.25 km3 (ref Brient 2019)
%     if sum(ftoosmall)>0
%         ccout.NumObjects=ccout.NumObjects-sum(ftoosmall);    
%         for iobj=find(ftoosmall)
%             ccout.PixelIdxList{iobj}=[]; %delete object points
%         end
%         ccout=bwconncomp(labelmatrix(ccout)>0); %redo object finding
%     end 
    rp=regionprops3(ccout,'Volume','Centroid','BoundingBox','Orientation','Solidity');
    ci=regionprops3(ccout,'ConvexImage');

    % plot of object "size" distribution
    z0=0.5*( zm(rp.BoundingBox(:,2)+1.5) + zm(rp.BoundingBox(:,2)+0.5) ); 
    z1=0.5*( zm(rp.BoundingBox(:,2)+1.5+rp.BoundingBox(:,5)) + zm(rp.BoundingBox(:,2)+0.5+rp.BoundingBox(:,5)) );
    dz=z1-z0;
    
    x0=0; [~,isorted]=sort(z0); Lh=zeros(size(z0));
    for i=1:length(isorted)
        iobj=isorted(i);
        Lh(iobj)=sqrt(vol(iobj)/dz(iobj))/1000;
        if doplots
            rectangle('Position',[x0 z0(iobj) Lh(iobj) dz(iobj)]); hold on
            x0=x0+sqrt(vol(iobj)/dz(iobj))/1000;
        end
    end
    if doplots
    xlabel('$L_h$ (km)','Interpreter','latex'); ylabel('$z$ (m)','Interpreter','latex')
    title('Object size distribution')
    print([outpref,'3dseg_ql_',num2str(time,'%02i'),'_objsizedistSD'],'-depsc','-r600'); %close(1)
    end
    obj_ql.Lh=Lh; obj_ql.z0=z0; obj_ql.dz=dz;
    %%
    winddir_avgcld=mean(winddir_z(izb:izt))*180/pi;
    u_avgcld=mean(u_z(izb:izt));
    v_avgcld=mean(v_z(izb:izt));

    if doplots
    subplot(131); plot(rp.Orientation(:,1),rp.Volume,'.'); xlabel('Orientation (deg)'); ylabel('Volume (voxels)')
    subplot(132); plot(rp.Orientation(:,2),rp.Volume,'.'); xlabel('Orientation (deg)'); ylabel('Volume (voxels)')
    subplot(133); plot(rp.Orientation(:,3),rp.Volume,'.'); xlabel('Orientation (deg)'); ylabel('Volume (voxels)')
    print([outpref,'3dseg_ql_',num2str(time,'%02i'),'_objorientSD'],'-depsc','-r600'); close(1);
    end
    
    %%
    it=find(ps.time==4*3600);
    [obj_ql.meanw,obj_ql.objsw]=get_cs_meanvar_wobjfilters(ccout,ones(ccout.NumObjects,1),w,nz,nz,nx,ny,ps,it,'b');
    [obj_ql.meantv,obj_ql.objstv]=get_cs_meanvar_wobjfilters(ccout,ones(ccout.NumObjects,1),tv,nz,nz,nx,ny,ps,it,'b');
    [obj_ql.meantl,obj_ql.objstl]=get_cs_meanvar_wobjfilters(ccout,ones(ccout.NumObjects,1),tl,nz,nz,nx,ny,ps,it,'b');
    [obj_ql.meanqt,obj_ql.objsqt]=get_cs_meanvar_wobjfilters(ccout,ones(ccout.NumObjects,1),qt,nz,nz,nx,ny,ps,it,'b');
   
    rp.orient_wrtwind=rp.Orientation(:,2)-winddir_avgcld;
    rp.orient_wrtwind(rp.orient_wrtwind>90)=rp.orient_wrtwind(rp.orient_wrtwind>90)-90;   
    
    obj_ql.rp=rp; obj_ql.vol=vol; obj_ql.cc=ccout;
end %function
  