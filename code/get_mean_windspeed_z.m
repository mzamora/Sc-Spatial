function [u_z,v_z,winddir_z,sheardir_z]=get_mean_windspeed_z(u,v,w,izt,zm)
%% mean wind angle
    u_z=mean(u,[2,3]); v_z=mean(v,[2,3]); 
    windmag_z=sqrt(u_z.^2+v_z.^2);
    winddir_z=atan2(v_z,u_z); %in radians
    winddir_z(abs(windmag_z)<0.1)=0; %if wind is too weak, consider orientation to not be important
    
    %% mean shear angle
    uwls_z=zeros(size(zm)); vwls_z=uwls_z;
    for iz=1:izt
        uxy=squeeze(u(iz,:,:)); vxy=squeeze(v(iz,:,:)); wxy=squeeze(w(iz,:,:));
        cc=cov(uxy,wxy); uwls_z(iz)=cc(1,2);
        cc=cov(vxy,wxy); vwls_z(iz)=cc(1,2);
    end
    sheardir_z=atan2(-vwls_z,uwls_z); %not needed right now?
    
end