
for ii=1:11
%% mean u
% umean_z=mean(u,[2 3]);
% vmean_z=mean(v,[2 3]);
for it=1:79
qmean_z=ps(ii).q_mean(:,it); %sqrt(umean_z.^2+vmean_z.^2);
d2qz=diff(qmean_z,2); % 2nd derivative of tv
[~,izu1]=max(d2qz(20:end-1)); %skip sometimes spurious last point
[~,izu2]=min(d2qz(20:end-1)); 
DU_U(ii,it)=mean(qmean_z(izu2+20:end))-mean(qmean_z(1:izu1+20));
DZ_U(ii,it)=ps(ii).zm(izu2+20)-ps(ii).zm(izu1+20);

% subplot(131); plot(qmean_z,ps(ii).zm); hold on; set(gca,'FontSize',12)
% plot(xlim,[ps(ii).zm(izu1+20) ps(ii).zm(izu1+20)],'--r',xlim,[ps(ii).zm(izu2+20) ps(ii).zm(izu2+20)],'--r')
% xlabel('$q(z)$ (m s$^{-1}$)','Interpreter','latex'); ylabel('$z$ (m)','Interpreter','latex'); ylim([0 1200])
% 
% subplot(132); plot(diff(qmean_z),ps(ii).zm(1:end-1)); hold on; set(gca,'FontSize',12)
% plot(xlim,[ps(ii).zm(izu1+20) ps(ii).zm(izu1+20)],'--r',xlim,[ps(ii).zm(izu2+20) ps(ii).zm(izu2+20)],'--r')
% xlabel('$\partial_z q(z)$ (s$^{-1}$)','Interpreter','latex'); ylabel('$z$ (m)','Interpreter','latex'); ylim([0 1200])
% 
% subplot(133); plot(diff(qmean_z,2),ps(ii).zm(2:end-1)); hold on; set(gca,'FontSize',12)
% plot(xlim,[ps(ii).zm(izu1+20) ps(ii).zm(izu1+20)],'--r',xlim,[ps(ii).zm(izu2+20) ps(ii).zm(izu2+20)],'--r')
% xlabel('$\partial_z q(z)$ (m$^{-1}$ s$^{-1}$)','Interpreter','latex'); ylabel('$z$ (m)','Interpreter','latex'); ylim([0 1200])
%%
tv_z=ps(ii).tv(:,it); %mean(tv,[2 3]);
DTV_U(ii,it)=tv_z(izu2+20)-tv_z(izu1+20);
d2tv=diff(tv_z,2); % 2nd derivative of tv
[~,izi1]=max(d2tv(1:end-1)); %skip sometimes spurious last point
[~,izi2]=min(d2tv(1:end-1)); 
DTV(ii,it)=tv_z(izi2+1)-tv_z(izi1+1);
DZ(ii,it)=ps(ii).zm(izi2)-ps(ii).zm(izi1);
DU(ii,it)=qmean_z(izi2+1)-qmean_z(izi1+1);

% subplot(131); plot(tv_z,ps(ii).zm); hold on ; set(gca,'FontSize',12)
% plot(xlim,[ps(ii).zm(izi1+1) ps(ii).zm(izi1+1)],'--r',xlim,[ps(ii).zm(izi2+1) ps(ii).zm(izi2+1)],'--r')
% xlabel('$\theta_v(z)$ (K)','Interpreter','latex'); ylabel('$z$ (m)','Interpreter','latex'); ylim([0 1200])
% 
% subplot(132); plot(diff(tv_z),ps(ii).zm(1:end-1)); hold on; set(gca,'FontSize',12)
% plot(xlim,[ps(ii).zm(izi1+1) ps(ii).zm(izi1+1)],'--r',xlim,[ps(ii).zm(izi2+1) ps(ii).zm(izi2+1)],'--r')
% xlabel('$\partial_z \theta_v(z)$ (K m$^{-1}$)','Interpreter','latex'); ylabel('$z$ (m)','Interpreter','latex'); ylim([0 1200])
% 
% subplot(133); plot(diff(tv_z,2),ps(ii).zm(2:end-1)); hold on; set(gca,'FontSize',12)
% plot(xlim,[ps(ii).zm(izi1+1) ps(ii).zm(izi1+1)],'--r',xlim,[ps(ii).zm(izi2+1) ps(ii).zm(izi2+1)],'--r')
% xlabel('$\partial_z \theta_v(z)$ (K m$^{-2}$)','Interpreter','latex'); ylabel('$z$ (m)','Interpreter','latex'); ylim([0 1200])

end
end

%% Plot Dtv, Du, Dz in time (with stratified thickness)
for ii=1:11
sp1=subplot(131); plot(ps(1).time/3600,DTV(ii,:),base(ii).style,'Color',gnrl.cols(ii,:)); hold on
ylabel('$\Delta \theta_v$ (K)','Interpreter','latex'); xlabel('Time (h)','Interpreter','latex')

sp2=subplot(132); plot(ps(1).time/3600,DU(ii,:),base(ii).style,'Color',gnrl.cols(ii,:)); hold on
ylabel('$\Delta q$ (m s$^{-1}$)','Interpreter','latex'); xlabel('Time (h)','Interpreter','latex')

sp3=subplot(133); plot(ps(1).time/3600,DZ(ii,:),base(ii).style,'Color',gnrl.cols(ii,:)); hold on
ylabel('$\Delta z$ (m)','Interpreter','latex'); xlabel('Time (h)','Interpreter','latex')
end
legend(gnrl.mylgd)

%% Plot Ri in time
Ri=9.81*DTV.*DZ./289./DU.^2
for ii=1:11
plot(ps(1).time/3600,Ri(ii,:),base(ii).style,'Color',gnrl.cols(ii,:)); hold on
end
plot([0 4],[.25 .25],'--k'); 
ylabel('$Ri_b$','Interpreter','latex'); xlabel('Time (h)','Interpreter','latex')
xlim([2 4]); ylim([0 2])
legend(gnrl.mylgd,'Location','eastoutside')

%% Plot Dtv, Du, Dz in time (with shear layer thickness)
for ii=1:11
sp1=subplot(131); plot(ps(1).time/3600,DTV_U(ii,:),base(ii).style,'Color',gnrl.cols(ii,:)); hold on
ylabel('$\Delta \theta_v$ (K)','Interpreter','latex'); xlabel('Time (h)','Interpreter','latex')

sp2=subplot(132); plot(ps(1).time/3600,DU_U(ii,:),base(ii).style,'Color',gnrl.cols(ii,:)); hold on
ylabel('$\Delta q$ (m s$^{-1}$)','Interpreter','latex'); xlabel('Time (h)','Interpreter','latex')

sp3=subplot(133); plot(ps(1).time/3600,DZ_U(ii,:),base(ii).style,'Color',gnrl.cols(ii,:)); hold on
ylabel('$\Delta z$ (m)','Interpreter','latex'); xlabel('Time (h)','Interpreter','latex')
end
legend(gnrl.mylgd)

%% Plot Ri in time
Ri_U=9.81*DTV_U.*DZ_U./289./DU_U.^2
for ii=1:11
plot(ps(1).time/3600,Ri(ii,:),base(ii).style,'Color',gnrl.cols(ii,:)); hold on
end
plot([0 4],[.25 .25],'--k'); 
ylabel('$Ri_b$','Interpreter','latex'); xlabel('Time (h)','Interpreter','latex')
xlim([2 4]); ylim([0 2])
legend(gnrl.mylgd,'Location','eastoutside')


%% Spatial *hr 4
time=60
ii=11

filename=[base(ii).datafolder,base(ii).casename,'/hr3_4/'];
var3d={'w','u','v','tl','tv','qt','ql','LWP'};
for ivar=1:length(var3d); load([filename,'rf01_',var3d{ivar},num2str(time,'%02i')]); end

izb_xy=nan(base(ii).nx,base(ii).nx); 
izt_xy=nan(base(ii).nx,base(ii).nx); 
izi_min=nan(base(ii).nx,base(ii).nx); 
izi_max=nan(base(ii).nx,base(ii).nx); 
Dzi=nan(base(ii).nx,base(ii).nx); 
Dtv=nan(base(ii).nx,base(ii).nx); 
Dq=nan(base(ii).nx,base(ii).nx); 
% izu_min=nan(base(ii).nx,base(ii).nx); 
% izu_max=nan(base(ii).nx,base(ii).nx); 
% Dzi_u=nan(base(ii).nx,base(ii).nx); 
% Dtv_u=nan(base(ii).nx,base(ii).nx); 
% Dq_u=nan(base(ii).nx,base(ii).nx); 


tv0=289; %ref tv
for ix=1:base(ii).nx
    for iy=1:base(ii).nx
        try % get cloud base height index
            izb_xy(ix,iy)=find(ql(:,ix,iy)>0,1);
        catch
        end
        try % get cloud top height index
            izt_xy(ix,iy)=find(ql(:,ix,iy)>0,1,'last');
        catch
        end
        try % zi min and max based on tv gradient
            d2tv=diff(tv(:,ix,iy),2); % 2nd derivative of tv
            [~,izi1]=max(d2tv(1:end-1)); %skip sometimes spurious last point
            [~,izi2]=min(d2tv(1:end-1)); 
            
            izi_min(ix,iy)=izi1+1; % plus one because 2nd derivative
            izi_max(ix,iy)=izi2+1;
            Dzi(ix,iy)=ps(ii).zm(izi2)-ps(ii).zm(izi1);
            Dtv(ix,iy)=tv(izi2,ix,iy)-tv(izi1,ix,iy);
            q2=sqrt(u(izi2,ix,iy)^2+v(izi2,ix,iy)^2);
            q1=sqrt(u(izi1,ix,iy)^2+v(izi1,ix,iy)^2);
            Dq(ix,iy)=q2-q1;
        catch
        end
        
%         try % zi min and max based on q(u,v) gradient
%             qz=sqrt(u(:,ix,iy).^2+v(:,ix,iy).^2);
%             d2qz=diff(qz(:,ix,iy),2); % 2nd derivative of tv
%             [~,izu1]=max(d2qz(1:end-1)); %skip sometimes spurious last point
%             [~,izu2]=min(d2qz(1:end-1)); 
%             
%             izu_min(ix,iy)=izu1+1; % plus one because 2nd derivative
%             izu_max(ix,iy)=izu2+1;
%             Dzi_u(ix,iy)=ps(ii).zm(izu2)-ps(ii).zm(izu1);
%         catch
%         end
        
        
    end
end

Rib=9.81*Dtv.*Dzi./289./Dq.^2;

