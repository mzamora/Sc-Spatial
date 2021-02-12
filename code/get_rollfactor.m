
%% polar space
nx=length(xm); ny=length(ym);
[X,Y]=meshgrid(35*(1:nx),35*(1:ny)');
rho=nan(nx,ny); theta=nan(nx,ny);

is=[1:nx/2]; js=[1:ny/2]; x0=0; y0=0; 
rho(is,js)=sqrt((X(is,js)-x0).^2+(Y(is,js)-y0).^2);
theta(is,js)=atan2(Y(is,js)-y0,X(is,js)-x0);

is=[1:nx/2]; js=[ny/2+1:ny]; x0=nx*35; y0=0; 
rho(is,js)=sqrt((X(is,js)-x0).^2+(Y(is,js)-y0).^2);
theta(is,js)=atan2(Y(is,js)-y0,X(is,js)-x0);

is=[nx/2+1:nx]; js=[1:ny/2]; x0=0; y0=ny*35; 
rho(is,js)=sqrt((X(is,js)-x0).^2+(Y(is,js)-y0).^2);
theta(is,js)=atan2(Y(is,js)-y0,X(is,js)-x0);

is=[nx/2+1:nx]; js=[ny/2+1:ny]; x0=nx*35; y0=ny*35; 
rho(is,js)=sqrt((X(is,js)-x0).^2+(Y(is,js)-y0).^2);
theta(is,js)=atan2(Y(is,js)-y0,X(is,js)-x0);
theta(theta<0)=theta(theta<0)+2*pi;
% contourf(rho,50); colorbar
%%
ii=11; gnrl.mylgd(ii)
% load 3D data
casename=base(ii).name;
filename=[casename(1:end-4),'hr3_4/'];
load([filename,'rf01_w',num2str(time,'%02i')])
time=60;
%%
Rwwout=nan(size(w,2),size(w,3),size(w,1));
for iz=2:ps3d(ii,time).nql_izt
    wxy=squeeze(w(iz,:,:)); %contourf(wxy)
    vec0=wxy; [nx,ny]=size(wxy);
    Rww=nan(size(wxy));
    
    %% spatial autocorrelation
    parfor ix=1:nx-1
        for iy=1:ny-1
            vec1=[vec0(ix+1:nx,iy+1:ny),vec0(ix+1:nx,1:iy);vec0(1:ix,iy+1:ny),vec0(1:ix,1:iy)];
            C=cov(vec0,vec1);
            Rww(ix,iy)=C(1,2)/C(1,1);
        end
    end
    %contourf(rho/1e3,rad2deg(theta),Rww,50,'LineStyle','none'); %caxis([-.1 .3]);
    
    Rwwout(:,:,iz)=Rww;
end
ps3d(ii,60).Rww=Rwwout;
save('ps3d','ps3d')

% or skip it (takes forever)
load('ps3d')

%% Computing the roll factor (for each case, for each height)

% create regular grid on the rho theta space
rhs=0:0.005:6.5; nrh=length(rhs);
ths=0:0.005:2*pi; nth=length(ths);
[R,T]=meshgrid(rhs,ths);
% try to interpolate the Rww into that regular grid to ease the search.
% this must be done in the loop for each z anyway, this is just a test
tic
Rww_interp=griddata(rho/1e3,theta,ps3d(1,60).Rww(:,:,20),R,T);
toc
% check the result
subplot(121); surf(rho/1e3,theta,ps3d(1,60).Rww(:,:,20),'LineStyle','none'); view(0,90); caxis([0 1]); xlim([0 6.5]); ylim([0 2*pi])
subplot(122); surf(R,T,Rww_interp,'LineStyle','none'); view(0,90); caxis([0 1]); xlim([0 6.5]); ylim([0 2*pi])

max(Rww_interp,[],'all')
max(ps3d(1,60).Rww(:,:,20),[],'all')
rollfactor=zeros(11,length(ps(1).zm));
%%
for ii=2:11 %1:-1:1
    it=find(ps(ii).time==4*3600);
    zi=ps(ii).zi(it);
    f05zi=rhs*1e3>0.5*zi; %filter for the rollfactor calc
    for iz=2:ps3d(ii,60).nql_izt
        Rww_interp=griddata(rho/1e3,theta,ps3d(ii,60).Rww(:,:,iz),R,T);
        for irh=1:nrh %rhos
            Rww_forarho=Rww_interp(:,irh);
            R_rho(irh)=nanmax(Rww_forarho)-nanmin(Rww_forarho);
        end
        rollfactor(ii,iz)=max(R_rho(f05zi));
        iz
    end
end
save('rollfactor','rollfactor')
%%
for ii=11:-1:1
    it=find(ps(ii).time==4*3600);
    zi=ps(ii).zi(it);
    plot(rollfactor(ii,:),ps(1).zm/zi,base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',1.3,'MarkerIndices',1:9:131); hold on
end
lgd=legend(gnrl.bcklgd,'Interpreter','latex')
ylim([0 1.1])
xlabel('Roll factor $\mathcal{R}$','Interpreter','latex')
ylabel('$z/z_i$','Interpreter','latex')
