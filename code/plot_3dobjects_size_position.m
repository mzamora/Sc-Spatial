function [z0,dz,Lh]=plot_3dobjects_size_position(rp,vol,zm)

z00=rp.BoundingBox(:,2);
dzz=rp.BoundingBox(:,5);
%z00(z00==0.5)=1.5; %manual fix
z0=zm(z00+0.5); %0.5*( zm(z00+0.5) + zm(z00-0.5) ); 
z1=zm(z00-0.5+dzz);  %zm(0.5*( zm(min(z00+0.5+dzz,length(zm))) + zm(min(z00-0.5+dzz,length(zm)-1)) );
dz=z1-z0;
dz(dz==0)=1;
x0=0; [~,isorted]=sort(z0);
Lh=zeros(size(z0));
for i=1:length(isorted)
    iobj=isorted(i);
    Lh(iobj)=sqrt(vol(iobj)/dz(iobj))/1000;
    rectangle('Position',[x0 z0(iobj) Lh(iobj) dz(iobj)]); hold on
    x0=x0+Lh(iobj);
end
xlabel('$L_h$ (km)','Interpreter','latex'); ylabel('$z$ (m)','Interpreter','latex')
title('Object size distribution')