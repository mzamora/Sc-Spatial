function vol=volume_from_extended_objects(ccout,zm,xm,ym)

nx=length(xm); ny=length(ym); nz=length(zm); 
dx=(xm(2)-xm(1)); %constant, in m
dy=(ym(2)-ym(1));
vol=zeros(1,ccout.NumObjects); %output is total volume per object in m3
for iobj=1:ccout.NumObjects
    pixels=ccout.PixelIdxList{iobj};
    [zz,~,~]=ind2sub([nz,3*nx,3*ny],pixels); %in the extended canvas
    dzs=zeros(size(zz));
    dzs(zz==nz)=zm(nz)-zm(nz-1);
    dzs(zz==1)=zm(2)-zm(1);
    f=(zz~=nz&zz~=1);
    dzs(f)=0.5*(zm(zz(f)+1)-zm(zz(f)-1)); % delta Z in m (centered) for each pixel
    vol(iobj)=sum(dzs)*dx*dy; %in m3
end