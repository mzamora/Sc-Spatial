% spatial autocorrelation (cartesian)

ii=7; gnrl.mylgd(ii)
% load 3D data
casename=base(ii).name;
filename=[casename(1:end-4),'hr3_4/'];
load([filename,'rf01_w',num2str(time,'%02i')])

iz=floor(0.1*ps3d(ii).nql_izt);
wxy=squeeze(w(iz,:,:));
vec0=wxy; [nx,ny]=size(wxy);
Rww=nan(size(wxy));
parfor ix=1:nx-1
    for iy=1:ny-1
        vec1=[vec0(ix+1:nx,iy+1:ny),vec0(ix+1:nx,1:iy);vec0(1:ix,iy+1:ny),vec0(1:ix,1:iy)];
        C=cov(vec0,vec1);
        Rww(ix,iy)=C(1,2)/C(1,1);
    end
end
contourf(rho/1e3,rad2deg(theta),Rww,50,'LineStyle','none'); caxis([-.1 .3]);
%%
Rww2=[Rww(nx/2+1:nx,ny/2+1:ny),Rww(nx/2+1:nx,1:ny/2);Rww(1:nx/2,ny/2+1:ny),Rww(1:nx/2,1:ny/2)];
contourf(X/1e3,Y/1e3,Rww2,50,'LineStyle','none'); caxis([-.1 .2]);
%% contourf(RLWP',50,'LineStyle','none'); caxis([-.4 .4]); colormap(bone)
load([filename,'rf01_w',num2str(time,'%02i')])

wxy=squeeze(floor(ps3d(ii).nql_izb/2),:,:);
vec0=wxy; [nx,ny]=size(wxy);
RLWP=nan(size(LWP));
for ix=0:nx-1
    for iy=0:ny-1
        vec1=[vec0(ix+1:nx,iy+1:ny),vec0(ix+1:nx,1:iy);vec0(1:ix,iy+1:ny),vec0(1:ix,1:iy)];
        C=cov(vec0,vec1);
        RLWP(ix,iy)=C(1,2)/C(1,1);
    end
end
%%
RLWP2=[RLWP(nx/2+1:nx,ny/2+1:ny),RLWP(nx/2+1:nx,1:ny/2);RLWP(1:nx/2,ny/2+1:ny),RLWP(1:nx/2,1:ny/2)];
contourf(RLWP2,50,'LineStyle','none'); caxis([-.3 .3]); colormap(bone)

%%
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
% contourf(rho,50); colorbar

% contourf(rho,theta,RLWP,'LineStyle','none')
%% polar
figure
subplot(2,3,1); contourf(rho/1e3,rad2deg(theta),RLWP_CTRL,50,'LineStyle','none'); title('CTRL'); caxis([-.2 .4]); xlim([0 7])
subplot(2,3,2); contourf(rho/1e3,rad2deg(theta),RLWP_050U,50,'LineStyle','none'); title('050U'); caxis([-.2 .4]); xlim([0 7])
subplot(2,3,3); contourf(rho/1e3,rad2deg(theta),RLWP_000U,50,'LineStyle','none'); title('000U'); caxis([-.2 .4]); xlim([0 7])
subplot(2,3,4); contourf(rho/1e3,rad2deg(theta),RLWP_CTRLS2,50,'LineStyle','none'); title('CTRL-S2'); caxis([-.2 .4]); xlim([0 7])
subplot(2,3,5); contourf(rho/1e3,rad2deg(theta),RLWP_050US2,50,'LineStyle','none'); title('050U-S2'); caxis([-.2 .4]); xlim([0 7])
subplot(2,3,6); contourf(rho/1e3,rad2deg(theta),RLWP_000US2,50,'LineStyle','none'); title('000U-S2'); caxis([-.2 .4]); xlim([0 7])

for ip=[1,4]; subplot(2,3,ip); ylabel('$\theta$ (deg)','Interpreter','latex'); end
for ip=[2,3,5,6]; subplot(2,3,ip); yticks(''); end
for ip=[4,5,6]; subplot(2,3,ip); xlabel('$\rho$ (km)','Interpreter','latex'); end
for ip=[1,2,3]; subplot(2,3,ip); xticks(''); end
for ip=[4,5,6]; subplot(2,3,ip); xticks([0 2 4 6]); end

fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 6 4];
print('../figures/Spatialcorr_LWP_polar','-dpng','-r300')

%% cartesian
figure
RLWP2_CTRL=[RLWP_CTRL(nx/2+1:nx,ny/2+1:ny),RLWP_CTRL(nx/2+1:nx,1:ny/2);RLWP_CTRL(1:nx/2,ny/2+1:ny),RLWP_CTRL(1:nx/2,1:ny/2)];
subplot(2,3,1); contourf(X/1e3,Y/1e3,RLWP2_CTRL,50,'LineStyle','none'); title('CTRL'); caxis([-.2 .4])
RLWP2_050U=[RLWP_050U(nx/2+1:nx,ny/2+1:ny),RLWP_050U(nx/2+1:nx,1:ny/2);RLWP_050U(1:nx/2,ny/2+1:ny),RLWP_050U(1:nx/2,1:ny/2)];
subplot(2,3,2); contourf(X/1e3,Y/1e3,RLWP2_050U,50,'LineStyle','none'); title('050U'); caxis([-.2 .4])
RLWP2_000U=[RLWP_000U(nx/2+1:nx,ny/2+1:ny),RLWP_000U(nx/2+1:nx,1:ny/2);RLWP_000U(1:nx/2,ny/2+1:ny),RLWP_000U(1:nx/2,1:ny/2)];
subplot(2,3,3); contourf(X/1e3,Y/1e3,RLWP2_000U,50,'LineStyle','none'); title('000U'); caxis([-.2 .4])
RLWP2_CTRLS2=[RLWP_CTRLS2(nx/2+1:nx,ny/2+1:ny),RLWP_CTRLS2(nx/2+1:nx,1:ny/2);RLWP_CTRLS2(1:nx/2,ny/2+1:ny),RLWP_CTRLS2(1:nx/2,1:ny/2)];
subplot(2,3,4); contourf(X/1e3,Y/1e3,RLWP2_CTRLS2,50,'LineStyle','none'); title('CTRL-S2'); caxis([-.2 .4])
RLWP2_050US2=[RLWP_050US2(nx/2+1:nx,ny/2+1:ny),RLWP_050US2(nx/2+1:nx,1:ny/2);RLWP_050US2(1:nx/2,ny/2+1:ny),RLWP_050US2(1:nx/2,1:ny/2)];
subplot(2,3,5); contourf(X/1e3,Y/1e3,RLWP2_050US2,50,'LineStyle','none'); title('050U-S2'); caxis([-.2 .4])
RLWP2_000US2=[RLWP_000US2(nx/2+1:nx,ny/2+1:ny),RLWP_000US2(nx/2+1:nx,1:ny/2);RLWP_000US2(1:nx/2,ny/2+1:ny),RLWP_000US2(1:nx/2,1:ny/2)];
subplot(2,3,6); contourf(X/1e3,Y/1e3,RLWP2_000US2,50,'LineStyle','none'); title('000U-S2'); caxis([-.2 .4])

for ip=[1,4]; subplot(2,3,ip); ylabel('$y$ (km)','Interpreter','latex'); yticks(1:3:13); yticklabels(-6:3:6); end
for ip=[2,3,5,6]; subplot(2,3,ip); yticks(''); end
for ip=[4,5,6]; subplot(2,3,ip); xlabel('$x$ (km)','Interpreter','latex'); xticks(1:3:13); xticklabels(-6:3:6); end
for ip=[1,2,3]; subplot(2,3,ip); xticks(''); end

fig=gcf; fig.PaperUnits='inches'; fig.PaperPosition=[0 0 6 4];
print('../figures/Spatialcorr_LWP_cartesian','-dpng','-r300')

%%
vec0=LWP;
for theta=-pi:.3:pi
    for rho=1:nx/2
        vec1=0;
    end
end