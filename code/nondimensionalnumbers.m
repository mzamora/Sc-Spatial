function nondim=nondimensionalnumbers(gnrl,base,ts,ps)

% entrainment
for ii=1:11
    it0=find(ps(ii).time==(4-15/60)*3600);
    it1=find(ps(ii).time==4*3600); % for a 10 min average at hour 4
    
    went4(ii)=mean(diff(ps(ii).zi(it0:it1))./diff(ps(ii).time(it0:it1))+3.75e-6*ps(ii).zi(it0+1:it1));
    zi4(ii)=mean(ps(ii).zi(it0:it1));
    zb4(ii)=mean(ps(ii).zb(it0:it1));
    h4(ii)=mean(ps(ii).zi(it0:it1)-ps(ii).zb(it0:it1));
    lwp_ps=interp1(ts(ii).times,ts(ii).lwp,ps(ii).time);
    LWP4(ii)=mean(lwp_ps(it0:it1));

its=60;
nondim(ii).time=10800+its*60;% for now only at time step 1 and 60
nondim(ii).timeh=nondim(ii).time/3600;
timefilter=ismember(ts(ii).times,nondim(ii).time);
nondim(ii).zis=ts(ii).zis(timefilter)';
    

it0=find(ps(ii).time==(4-1/6)*3600);
it1=find(ps(ii).time==4*3600); % for a 10 min average at hour 4
%at the surface
sfcboy=ps(ii).buoy_tot(2,it0:it1)*289/9.81; %actual wtv
wstar0_4(ii)=mean((ps(ii).buoy_tot(2,it0:it1)'.*ps(ii).zi(it0:it1)).^(1/3)); %from sfc wtv

    for it=it0:it1
        fcld=ps(ii).ql(:,it)>0; %where the cloud layer is
        bcld=ps(ii).buoy_tot(fcld,it); %g/tv0 wtv in the cloud layer
        bcldplus=max(bcld,0); %only positive values
        bABL=ps(ii).buoy_tot(:,it);
        bmax=max(bcld);
        wcld(it-it0+1)=trapz(ps(ii).zm(fcld),bcld).^(1/3); % like Ghonima et al
        wcldplus(it-it0+1)=trapz(ps(ii).zm(fcld),bcldplus).^(1/3); % like Schulz and Mellado
        zstarschulz(it-it0+1)=trapz(ps(ii).zm(fcld),bcldplus)./bmax; % in Schulz and Mellado
        wABL(it-it0+1)=trapz(ps(ii).zm,bABL).^(1/3); %like Akyurek et al

        dncld=mean(ps(ii).dn0(fcld));
        Fcld=ps(ii).rflx(fcld,it); %net rad in the cloud
        Frad=Fcld(end)-Fcld(1); %net rad flux divergence
        wrad(it-it0+1)=(9.81*ps(ii).zi(it)*Frad/289/dncld/1005)^(1/3); % like Fang
        Frads(it-it0+1)=Frad;
    end
    Frad_4(ii)=mean(Frads);
    wstarcld_4(ii)=mean(wcld);
    wstarcldplus_4(ii)=mean(wcldplus);
    wstarABL_4(ii)=mean(wABL);
    wstarrad_4(ii)=mean(wrad);
    zstarschulz_4(ii)=mean(zstarschulz);

    % ustars
    ustar0_4(ii)=mean((ps(ii).uw(1,it0:it1).^2+ps(ii).vw(1,it0:it1).^2).^0.25);
%     subplot(122);plot(diff(ps(ii).uvw(:,it),2),ps(ii).zm(2:end-1)); hold on
%     subplot(121); plot(ps(ii).uvw(:,it),ps(ii).zm); hold on
    izuwi=find(ps(ii).zm<840,1,'last'); %this one is a bit tricky but looking at the uvw profiles, it's clear that this is the point where the top max happens
    ustari_4(ii)=mean((ps(ii).uw(izuwi,it0:it1).^2+ps(ii).vw(izuwi,it0:it1).^2).^0.25);
    shearnumber_4(ii)=mean((ps(ii).q_FT(it0:it1)-ps(ii).q_ABL(it0:it1))./ps(ii).q_ABL(it0:it1));
    du_4(ii)=mean(ps(ii).q_FT(it0:it1)-ps(ii).q_ABL(it0:it1));
    uABL_4(ii)=mean(ps(ii).q_ABL(it0:it1));
    
    for it=it0:it1
        qmean_z=ps(ii).q_mean(:,it); %sqrt(umean_z.^2+vmean_z.^2);
        tv_z=ps(ii).tv(:,it); %mean(tv,[2 3]);
        d2tv=diff(tv_z,2); % 2nd derivative of tv
        [~,izi1]=max(d2tv(1:end-1)); %skip sometimes spurious last point
        [~,izi2]=min(d2tv(1:end-1)); 
        DTV(it-it0+1)=tv_z(izi2+1)-tv_z(izi1+1);
        DZ(it-it0+1)=ps(ii).zm(izi2)-ps(ii).zm(izi1);
        DU(it-it0+1)=qmean_z(izi2+1)-qmean_z(izi1+1);
    end
    Rib_4(ii)=mean(9.81*DTV.*DZ./289./DU.^2);

end

Lob_4=-(ustar0_4./wstar0_4).^3.*zi4/.4;
Li_4=-(ustari_4./wstarcld_4).^3.*zi4/.4;
eta0_4=-zi4./Lob_4;
etai_4=-zi4./Li_4;
 

%%
names={'zi','zb','h','LWP','zstarschulz','went','wstar0','wstarcld','ustar0','ustari','shearnumb','du','uABL','Lob','Li','eta0','etai','Rib'}
T=table(zi4',zb4',h4',LWP4',zstarschulz_4',1000*went4',wstar0_4',wstarcld_4', ...
    ustar0_4',ustari_4',shearnumber_4',du_4',uABL_4',...
    Lob_4',Li_4',eta0_4',etai_4',Rib_4','VariableNames',names,'RowNames',gnrl.mylgd)

%%
plot(du_4,wstarcldplus_4,'*'); xlabel('$\Delta q$ (m s$^{-1}$)','Interpreter','latex'); ylabel('$w_{*,cld+}$ (m s$^{-1}$)','Interpreter','latex');
set(gca,'FontSize',12); hold on; plot(xlim,xlim*.25); ylim([.52 .66])

plot(uABL_4,ustar0_4,'*'); xlabel('$q_{ABL}$ (m s$^{-1}$)','Interpreter','latex'); ylabel('$u_{*,0}$ (m s$^{-1}$)','Interpreter','latex');
set(gca,'FontSize',12)

plot(wstar0_4,wstarcld_4,'*'); hold on
plot(wstar0_4,wstarcldplus_4,'*'); 
plot(wstar0_4,wstarABL_4,'*');
plot(wstar0_4,wstarrad_4,'*');
xlabel('$w_{*,0}$ (m s$^{-1}$)','Interpreter','latex'); ylabel('Other $w_{*}$ (m s$^{-1}$)','Interpreter','latex');
set(gca,'FontSize',12); legend('$w_{*,cld}$','$w_{*,cld+}$','$w_{*,ABL}$','$w_{*,rad}$','Interpreter','latex','FontSize',12)

plot(ustar0_4,ustari_4,'*'); xlabel('$u_{*,0}$ (m s$^{-1}$)','Interpreter','latex'); ylabel('$u_{*,i}$ (m s$^{-1}$)','Interpreter','latex');
set(gca,'FontSize',12)

plot(wstar0_4,wstarcld_4,'*'); xlabel('$w_{*,0}$ (m s$^{-1}$)','Interpreter','latex'); ylabel('$w_{*,cld}$ (m s$^{-1}$)','Interpreter','latex');
set(gca,'FontSize',12)

x=ustar0_4./wstar0_4; y=ustari_4./wstarcld_4;
plot(x,y,'*'); xlabel('$u_{*,0}/w_{*,0}$','Interpreter','latex'); ylabel('$u_{*,i}/w_{*,cld}$','Interpreter','latex');
for ii=1:11; text(x(ii)+.01,y(ii),gnrl.mylgd{ii},'Rotation',45); end
set(gca,'FontSize',12)

plot((ustar0_4./wstar0_4).^3,(ustari_4./wstarcld_4).^3,'*'); xlabel('$(u_{*,0}/w_{*,0})^3$','Interpreter','latex'); ylabel('$(u_{*,i}/w_{*,cld})^3$','Interpreter','latex');
set(gca,'FontSize',12)

x=zi4.*(ustar0_4./wstar0_4).^3/.4; y=zi4.*(ustari_4./wstarcld_4).^3/.4;
plot(x,y,'*'); xlabel('$L_{ob}$ (m)','Interpreter','latex'); ylabel('$L_i$ (m)','Interpreter','latex');
for ii=1:11; text(x(ii)+3,y(ii)+1,gnrl.mylgd{ii},'Rotation',45); end
set(gca,'FontSize',12)

x=0.4./(ustar0_4./wstar0_4).^3; y=0.4./(ustari_4./wstarcld_4).^3;
loglog(x,y,'*'); hold on
xlabel('$\eta_0$','Interpreter','latex'); ylabel('$\eta_i$','Interpreter','latex');
for ii=1:11; text(x(ii)*1.1,y(ii)*1.1,gnrl.mylgd{ii}); end
set(gca,'FontSize',12)

% %     dn0=ncread(base.psfile_34,'dn0');
%     % vertical profiles
%     for it=1:length(sp.time)
%         %% load 3d vars at that time
%         time=its(it);
%         filename=[base.datafolder,base.casename,'/hr3_4/'];
%         var3d={'w','u','v','tl','tv','qt','ql','LWP'};
%         for ivar=1:length(var3d); load([filename,'rf01_',var3d{ivar},'_',num2str(time,'%02i')]); end
%     
%         for iz=1:length(ps.zm)
%             wxy=reshape(w(iz,:,:),1,base.nx^2); %w in the plane
%             tvxy=reshape(tv(iz,:,:),1,base.nx^2); %theta v in the plane
%             c=cov(wxy,tvxy,1); %buoyancy flux
%             wtv(iz)=c(1,2); %sum(sum((wxy-mean(mean(wxy))).*(tvxy-mean(mean(tvxy)))))/nx/ny;
% 
%             uxy=reshape(u(iz,:,:),1,base.nx^2); % momentum fluxes
%             vxy=reshape(v(iz,:,:),1,base.nx^2);
%             c=cov(wxy,uxy,1); uw(iz)=c(1,2);
%             c=cov(wxy,vxy,1); vw(iz)=c(1,2);
%             mean_tv(iz)=mean(mean(tvxy));
%         end
% 
%         % column loops for cloud base, top and lwp variance
%         for ix=1:base.nx
%             for iy=1:base.nx
%                 thisql=ql(:,ix,iy);
% %                 LWP(ix,iy)=trapz(ps3d.zm,dn0.*thisql);
%                 izb=find(thisql>0,1);
%                 if isempty(izb)
%                     zct(ix,iy)=nan;
%                     zcb(ix,iy)=nan;
%                 else
%                     izt=find(thisql>0,1,'last');
%                     zct(ix,iy)=ps3d.zm(izt);
%                     zcb(ix,iy)=ps3d.zm(izb);
%                 end
%                 maxql(ix,iy)=max(thisql);
%             end
%         end
%         sp.mean_LWP(it,1)=mean(mean(LWP));
%         sp.var_LWP(it,1)=var(reshape(LWP,1,base.nx^2),1);
%         sp.mean_zcb(it,1)=nanmean(nanmean(zcb));
%         sp.var_zcb(it,1)=nanvar(reshape(zcb,1,base.nx^2),1);
%         sp.mean_zct(it,1)=nanmean(nanmean(zct));
%         sp.var_zct(it,1)=nanvar(reshape(zct,1,base.nx^2),1);
%         sp.mean_qlmax(it,1)=nanmean(nanmean(maxql));
%         sp.var_qlmax(it,1)=nanvar(reshape(maxql,1,base.nx^2),1);
% 
%         [sp.bmin(it,1),iz_bmin]=min(wtv); %minimum buoyancy flux
%         [sp.bmax(it,1),iz_bmax]=max(wtv); %maximum buoyancy flux
%         sp.z_bmin(it,1)=ps3d.zm(iz_bmin); %minimum buoyancy flux height
%         sp.z_bmax(it,1)=ps3d.zm(iz_bmax); %maximum buoyancy flux height
% %        l_ext=15; %temporal value as dycoms 1/(xka*1000*qc)
%         f=(ps3d.zm>sp.mean_zcb(it,1) & ps3d.zm<sp.mean_zct(it,1));
%         sp.B_cld(it,1)=trapz(ps3d.zm(f),max(wtv(f),0)); %integral of B in cloud, only positive values (Schulz and Mellado, 2018)
%         sp.B_ml(it,1)=trapz(ps3d.zm,wtv);
%         sp.tv_bmin(it,1)=mean(mean(tv(iz_bmin,:,:))); %virtual pot temp at min B
%         sp.tv_bmax(it,1)=mean(mean(tv(iz_bmax,:,:))); %virtual pot temp at max B
%         sp.tv_cld(it,1)=mean(mean(mean(tv(f,:,:))));
%         sp.uw_bmin(it,1)=uw(iz_bmin); %uw at min B height
%         [~,izi]=min(abs(ps3d.zm-sp.mean_zct(it,1))); %inversion height
%         sp.uw_i(it,1)=uw(izi);
%         sp.uw_cld(it,1)=mean(uw(f)); %average in the cloud region
%         sp.vw_bmin(it,1)=vw(iz_bmin); %vw at min buoy height
%         sp.vw_i(it,1)=vw(izi);
%         sp.vw_cld(it,1)=mean(vw(f)); %avg in the cloud region
%         sp.uw_srf(it,1)=uw(2); %uw near surface
%         sp.vw_srf(it,1)=vw(2); %vw near surface
%         sp.b_srf(it,1)=wtv(2); %buoyancy flux near surface (shouldn't be used?)
%         sp.th_srf(it,1)=mean(mean(tv(2,:,:))); %virt pot temp near surface
%         sp.wtv(it,:)=wtv; %saving the whole B profile just in case
%     end
% 
%     sp.bflx_i=sp.bmax;
%     sp.tv_i=sp.tv_cld;
%     sp.w_star_i=(9.81*sp.B_cld./sp.tv_0).^(1/3);
%     sp.z_star_i=sp.B_cld./sp.bmax; % Schulz and Mellado, 2018
%     sp.T_star_i2=sp.z_star_i./sp.w_star_i; %based on z*
%     sp.T_star_i=ts.zct(timefilter)./sp.w_star_i;
% 
%     sp.u_star_0=(sp.uw_srf.^2+sp.vw_srf.^2).^0.25;
%     sp.L_ob_0=-sp.u_star_0.^3.*sp.tv_0./(0.4*9.81*sp.bflx_0);
%     sp.zeta_0=-ts.zct(timefilter)./sp.L_ob_0;
% 
%     sp.u_star_i=(sp.uw_i.^2+sp.vw_i.^2).^0.25;
%     sp.L_ob_i=-sp.u_star_i.^3.*sp.tv_bmax./(0.4*9.81*sp.bmax); %minus sign out because bmin<0
%     sp.zeta_i2=-sp.z_star_i./sp.L_ob_i;
%     sp.zeta_i=-ts.zct(timefilter)./sp.L_ob_i;
% 
% end %function

        