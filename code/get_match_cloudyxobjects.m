% percentage of cloud elements on UD and DD types
nmatchUD=zeros(6,11); nmatchDD=zeros(6,11); vol_cld=zeros(1,6);
volmatchedUD=zeros(6,11); volmatchedDD=zeros(6,11);
nx=length(xm); ny=length(ym); nz=length(zm);
for ii=1:11
    zm=ps(ii).zm; Pixels_cld=[];
    for iobj=1:obj_ql(ii).cc.NumObjects
        Pixels_cld=[Pixels_cld;obj_ql(ii).cc.PixelIdxList{iobj}];
    end
    imgsz=obj_ql(ii).cc.ImageSize;
    [izcld,ixcld,iycld]=pixels_3x_to_1x(Pixels_cld,imgsz(1),nx,ny);
    pixels_cld=sub2ind([nz,nx,ny],izcld,ixcld,iycld);
    [zz,~,~]=ind2sub([nz,nx,ny],pixels_cld); %in the extended canvas
    dzs=zeros(size(zz)); dzs(zz==nz)=zm(nz)-zm(nz-1); dzs(zz==1)=zm(2)-zm(1);
    f=(zz~=nz&zz~=1); dzs(f)=0.5*(zm(zz(f)+1)-zm(zz(f)-1)); % delta Z in m (centered) for each pixel
    vol_cld(ii)=sum(dzs)*35*35; %in m3

    for ifilter=1:6
        Pixels_UD=[];
        objs=find(obj_ud(ii).filters_UD(:,ifilter)); nobjs=length(objs);
        if nobjs>0
            for iobj=objs'
                Pixels_UD=[Pixels_UD;obj_ud(ii).ccUD.PixelIdxList{iobj}];
            end
            imgsz=obj_ud(ii).ccUD.ImageSize;
            [izUD,ixUD,iyUD]=pixels_3x_to_1x(Pixels_UD,imgsz(1),nx,ny);
            pixels_UD=sub2ind([nz,nx,ny],izUD,ixUD,iyUD);
            matched=intersect(pixels_cld,pixels_UD);
            [zz,~,~]=ind2sub([nz,nx,ny],matched); %in the extended canvas
            dzs=zeros(size(zz)); dzs(zz==nz)=zm(nz)-zm(nz-1); dzs(zz==1)=zm(2)-zm(1);
            f=(zz~=nz&zz~=1); dzs(f)=0.5*(zm(zz(f)+1)-zm(zz(f)-1)); % delta Z in m (centered) for each pixel
            volmatchedUD(ifilter,ii)=sum(dzs)*35*35; %in m3
            nmatchUD(ifilter,ii)=length(matched);
        end
    end

    for ifilter=1:6
        Pixels_DD=[];
        objs=find(obj_ud(ii).filters_DD(:,ifilter)); nobjs=length(objs);
        if nobjs>0
            for iobj=objs'
                Pixels_DD=[Pixels_DD;obj_ud(ii).ccDD.PixelIdxList{iobj}];
            end
            imgsz=obj_ud(ii).ccDD.ImageSize;
            [izDD,ixDD,iyDD]=pixels_3x_to_1x(Pixels_DD,imgsz(1),nx,ny);
            pixels_DD=sub2ind([nz,nx,ny],izDD,ixDD,iyDD);
            matched=intersect(pixels_cld,pixels_DD);
            [zz,~,~]=ind2sub([nz,nx,ny],matched); %in the extended canvas
            dzs=zeros(size(zz)); dzs(zz==nz)=zm(nz)-zm(nz-1); dzs(zz==1)=zm(2)-zm(1);
            f=(zz~=nz&zz~=1); dzs(f)=0.5*(zm(zz(f)+1)-zm(zz(f)-1)); % delta Z in m (centered) for each pixel
            volmatchedDD(ifilter,ii)=sum(dzs)*35*35; %in m3
            nmatchDD(ifilter,ii)=length(matched);
        end
    end
end

%% fraction of volume match between cloud and different UD/DD classes
subplot(121)
plot((volmatchedUD./repmat(vol_cld,[6 1]))','.-'); 
legend('UD$^{\rm I}$','UD$^{\rm II}$','UD$^{\rm III}$','UD$^{\rm IV}$', ...
    'UD$^{\rm V}$','UD$^{\rm VI}$','Interpreter','latex','FontSize',fs)
ylabel('Cloud element volume fraction','Interpreter','latex','FontSize',fs)
xticks(1:11); xticklabels(gnrl.mylgd); xtickangle(45)
set(gca,'fontsize', fs);
text(.0,1.08,'a)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

subplot(122)
plot((volmatchedDD./repmat(vol_cld,[6 1]))','.-'); 
legend('DD$^{\rm I}$','DD$^{\rm II}$','DD$^{\rm III}$','DD$^{\rm IV}$', ...
    'DD$^{\rm V}$','DD$^{\rm VI}$','Interpreter','latex','FontSize',fs)
ylabel('Cloud element volume fraction','Interpreter','latex','FontSize',fs)
xticks(1:11); xticklabels(gnrl.mylgd); xtickangle(45)
set(gca,'fontsize', fs);
text(.0,1.08,'b)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 8 4];
print('../figures/Fig_cloudyvolperclass','-depsc')


