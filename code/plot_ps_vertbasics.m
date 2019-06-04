function plot_ps_vertbasics(base,ps,t_index)
    saveplots=1;
    mycol=base.color;
    mystyle=base.style;
    if nargin<3 % if no desired time is given
        t_index=20:25; %default to avg hr 3 4
    end
    
    %%
    zi=mean(ps.zi(t_index));
    
    figure(1);
    plot(mean(ps.tl(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); %,[ps.q0 ps.q0],[0 ps.zi],'--');
    hold on; xlabel('$\theta_l$ [K]','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])
    
    figure(2);
    plot(mean(ps.qt(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); %,[ps.q0 ps.q0],[0 ps.zi],'--');
    hold on; xlabel('$q_t$ [g~kg$^{-1}$]','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])
    
    figure(3);
    plot(mean(ps.ql(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); 
    hold on; xlabel('$q_l$ [g~kg$^{-1}$]','Interpreter','latex'); ylabel('$z/zi$','Interpreter','latex'); ylim([0 1.1])
    
    figure(4);
    plot(mean(ps.rflx(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); hold on; 
    xlabel('Radiative flux [W~m$^{-2}$]','Interpreter','latex'); ylabel('$z/z_i$ [m]','Interpreter','latex'); ylim([0 1.1])
   
    figure(5); %subplot(345); %total horizontal wind speed
    plot(mean(ps.q_mean(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); %,[ps.q0 ps.q0],[0 ps.zi],'--');
    hold on; xlabel('Wind speed [m~s$^{-1}$]','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])

    figure(6); %subplot(346); 
    plot(mean(ps.dir_mean(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); %,[ps.dir0 ps.dir0],[0 ps.zi],'--'); 
    hold on; xlabel('Wind dir. [$^\circ$]','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])

    % tke contributions %reading from netcdf file
    figure(7); %subplot(3,4,7)
    plot(mean(ps.tot_tw(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); hold on; 
    xlabel('$\overline{w''\theta_l''}$','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])
    
    figure(8); %subplot(3,4,8)
    plot(mean(ps.tot_qw(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); hold on; 
    xlabel('$\overline{w''q_t''}$','Interpreter','latex'); ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.1])
    
    figure(9); %subplot(3,4,9)
    plot(mean(ps.uvw(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); hold on; ylim([0 1.1]); ylabel('$z/z_i$','Interpreter','latex');
    xlabel('$\sqrt{\overline{u''w''}^2+\overline{v''w''}^2}$ [m$^2$~s$^{-2}$]','Interpreter','latex');
    
    figure(10); %subplot(3,4,10)
    plot(mean(ps.buoy_tot(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); hold on; ylim([0 1.1]); ylabel('$z/z_i$','Interpreter','latex');
    xlabel('Buoyancy production [m$^2$~s$^{-2}$]','Interpreter','latex');
    
    figure(11); %subplot(3,4,11) %in zt!!
    plot(mean(ps.shear_tot(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); hold on; ylim([0 1.1]); ylabel('$z/z_i$','Interpreter','latex');
    xlabel('Shear production [m$^2$~s$^{-2}$]','Interpreter','latex');
        
    figure(12); %subplot(3,4,12)
    plot(mean(ps.dissipation(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); hold on; ylim([0 1.1]); ylabel('$z/z_i$','Interpreter','latex');
    xlabel('Dissipation [m$^2$~s$^{-2}$]','Interpreter','latex');
    
    figure(13); %subplot(3,4,12)
    plot(mean(ps.ql2(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); hold on; ylim([0 1.1]); ylabel('$z/z_i$','Interpreter','latex');
    xlabel('$\overline{q_l''^2}$','Interpreter','latex');
    
    figure(14); %subplot(3,4,12)
    plot(mean(ps.ql3(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); hold on; ylim([0 1.1]); ylabel('$z/z_i$','Interpreter','latex');
    xlabel('$\overline{q_l''^3}$','Interpreter','latex');
    
    figure(15); %subplot(3,4,12)
    plot(mean(ps.uv2(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); hold on; ylim([0 1.1]); ylabel('$z/z_i$','Interpreter','latex');
    xlabel('$\sqrt{\overline{u''^2}^2+\overline{v''^2}^2}$ [m$^2$~s$^{-2}$]','Interpreter','latex');
    
    figure(16); %subplot(3,4,12)
    plot(mean(ps.w2(:,t_index),2),ps.zm/zi,mystyle,'Color',mycol); hold on; ylim([0 1.1]); ylabel('$z/z_i$','Interpreter','latex');
    xlabel('$\overline{w''^2}$ [m$^2$~s$^{-2}$]','Interpreter','latex');
    
    %plot cloud boundaries
%     for i=1:12
%         figure(i); %subplot(3,4,i); 
%         plot(xlim,[zb zb],':r',xlim,[zi zi],':r'); hold on
%     end

end
