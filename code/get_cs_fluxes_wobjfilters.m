function [flux_cs,flux]=get_cs_fluxes_wobjfilters(ccout,filters,var1,var2,izt,nz,nx,ny)
% Compute conditional sampled fluxes for objects identified in the 3x
% domain

flux_cs=zeros(nz,6);
flux=zeros(nz,1);
for ifilter=1:6
    objs=find(filters(:,ifilter)); 
    Pixels=[]; % pixels per each filter
    for iobj=1:length(objs)
        Pixels=[Pixels;ccout.PixelIdxList{objs(iobj)}]; 
        %[kpix,ipix,jpix]=ind2sub([izt,3*nx,3*ny],Pixels); % to check object pixels
        %fs=kpix==2; plot(ipix(fs),jpix(fs),'.')
    end
    [ifz,ifx,ify]=pixels_3x_to_1x(Pixels,izt,nx,ny); %convert pixels from extended canvas
    for iz=1:nz
        var1_xy=squeeze(var1(iz,:,:)); var1_xy=var1_xy-mean(var1_xy,'all');
        var2_xy=squeeze(var2(iz,:,:)); var2_xy=var2_xy-mean(var2_xy,'all');
        fs=(iz==ifz); %get pixels of each filter at that height
        % w'w' conditional sampling per filter
        xx=ifx(fs); yy=ify(fs);
        var1f=var1_xy(sub2ind(size(var1_xy),xx,yy)); %i,j to idx
        var2f=var2_xy(sub2ind(size(var2_xy),xx,yy)); %i,j to idx
        flux_cs(iz,ifilter)=sum(var1f.*var2f,'all')/(nx*ny);
        if ifilter==6
            flux(iz)=sum(var1_xy.*var2_xy,'all')/(nx*ny); %total flux
        end
    end
    clear ifz ifx ify
end