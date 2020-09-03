function obj_qlw=segmentation_3d_qlw(ql,zm,xm,ym,izb,izt,outpref,time,winddir_z,u_z,v_z,iz_nqlmax,w,tv,tl,qt,ps)
doplots=0;

% cloud core definition with ql>0 and w>0 as thijs suggested
% how can we blur this? 1st try without blurring?

    %% Setup
    nx=length(xm); ny=length(ym); nz=length(zm);
   
    %% blur it
    qlb=imgaussfilt3(ql,3); %blur it
    wb=imgaussfilt3(w,2); %blur it
    
    % account for periodicity and get geometric properties
    fieldin=qlb>0 & wb>0; %1 if complies
    ccout=binarize_periodic_3d(fieldin,0.5); %points with field>0.5 are points with 1
    vol=volume_from_extended_objects(ccout,zm,xm,ym); 
%     ftoosmall=vol/1e9<0.25; % remove objs with volume lower than 0.25 km3 (ref Brient 2019)
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
    print([outpref,'3dseg_qlw_',num2str(time,'%02i'),'_objsizedistSD'],'-depsc','-r600'); %close(1)
    end
    obj_qlw.Lh=Lh; obj_qlw.z0=z0; obj_qlw.dz=dz;
    %%
    winddir_avgcld=mean(winddir_z(izb:izt))*180/pi;
    u_avgcld=mean(u_z(izb:izt));
    v_avgcld=mean(v_z(izb:izt));

    if doplots
    subplot(131); plot(rp.Orientation(:,1),rp.Volume,'.'); xlabel('Orientation (deg)'); ylabel('Volume (voxels)')
    subplot(132); plot(rp.Orientation(:,2),rp.Volume,'.'); xlabel('Orientation (deg)'); ylabel('Volume (voxels)')
    subplot(133); plot(rp.Orientation(:,3),rp.Volume,'.'); xlabel('Orientation (deg)'); ylabel('Volume (voxels)')
    print([outpref,'3dseg_qlw_',num2str(time,'%02i'),'_objorientSD'],'-depsc','-r600'); close(1);
    end
    
    %%
    it=find(ps.time==4*3600);
    [obj_qlw.meanw,obj_qlw.objsw]=get_cs_meanvar_wobjfilters(ccout,ones(ccout.NumObjects,1),w,nz,nz,nx,ny,ps,it,'b');
    [obj_qlw.meantv,obj_qlw.objstv]=get_cs_meanvar_wobjfilters(ccout,ones(ccout.NumObjects,1),tv,nz,nz,nx,ny,ps,it,'b');
    [obj_qlw.meantl,obj_qlw.objstl]=get_cs_meanvar_wobjfilters(ccout,ones(ccout.NumObjects,1),tl,nz,nz,nx,ny,ps,it,'b');
    [obj_qlw.meanqt,obj_qlw.objsqt]=get_cs_meanvar_wobjfilters(ccout,ones(ccout.NumObjects,1),qt,nz,nz,nx,ny,ps,it,'b');
   
    rp.orient_wrtwind=rp.Orientation(:,2)-winddir_avgcld;
    rp.orient_wrtwind(rp.orient_wrtwind>90)=rp.orient_wrtwind(rp.orient_wrtwind>90)-90;   
    
    obj_qlw.rp=rp; obj_qlw.vol=vol; obj_qlw.cc=ccout;
end %function
  