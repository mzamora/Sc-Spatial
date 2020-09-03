

nameplt='all';
nos={'a)','b)','c)','d)','e)','f)','g)'};
iis=1:11;
    
fs=12; %fontsize
figure('Position',[0 0 1000 500])
fnt='SansSerif';
sp1=subplot(241); % w variance
for ii=iis
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    w2=mean(ps(ii).w2(:,it3:it4),2); zi=mean(ps(ii).zi(it3:it4));
    plot(w2,ps(ii).zm./zi,base(ii).style,'Color',gnrl.cols(ii,:)); hold on
end
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.05]);
xlabel('$\overline{w''w''}$ (m$^2$ s$^{-2}$)','Interpreter','latex'); 
set(gca,'fontsize', fs,'fontname',fnt)
text(0,1.15,nos{1},'Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp2=subplot(242); % uv variance
for ii=iis
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    zi=mean(ps(ii).zi(it3:it4));
    q2=mean(sqrt(ps(ii).u2(:,it3:it4).^2+ps(ii).v2(:,it3:it4).^2),2);
    plot(q2,ps(ii).zm./zi,base(ii).style,'Color',gnrl.cols(ii,:)); hold on
end
%yticks([.9 .92 .94 .96 .98 1])
ylabel('$z/z_i$','Interpreter','latex'); xlabel('$\sigma_r$ (m$^2$ s$^{-2}$)','Interpreter','latex'); 
set(gca,'fontsize',fs,'fontname',fnt); ylim([0 1.05]);
text(0,1.15,nos{2},'Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex')%subplot label

sp3=subplot(243); % u2+v2+w2 TKE
for ii=iis
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    zi=mean(ps(ii).zi(it3:it4));
    tke=0.5*mean(ps(ii).u2(:,it3:it4)+ps(ii).v2(:,it3:it4)+ps(ii).w2(:,it3:it4),2);
    plot(tke,ps(ii).zm./zi,base(ii).style,'Color',gnrl.cols(ii,:)); hold on
end
ylabel('$z/z_i$','Interpreter','latex'); xlabel('TKE (m$^2$ s$^{-2}$)','Interpreter','latex'); 
set(gca,'fontsize', fs,'fontname',fnt); ylim([0 1.05]);
text(0,1.15,nos{3},'Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex')%subplot label

sp4=subplot(244); % q'w' (momentum flux
for ii=1:11
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    qw=mean(sqrt(ps(ii).uw(:,it3:it4).^2+ps(ii).vw(:,it3:it4).^2),2);
    plot(qw,ps(ii).zm./ps(ii).zi(end),base(ii).style,'Color',gnrl.cols(ii,:)); hold on
end
ylabel('$z/z_i$','Interpreter','latex'); xlabel('$F_r$ (m$^2$ s$^{-2}$)','Interpreter','latex'); 
set(gca,'fontsize', fs,'fontname',fnt); ylim([0 1.05]);
text(0,1.15,nos{4},'Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex')%subplot label

sp5=subplot(245); % wtv
for ii=iis
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    zi=mean(ps(ii).zi(it3:it4));
    buoy=mean(ps(ii).buoy_tot(:,it3:it4),2);
    plot(buoy.*1e4,ps(ii).zm./zi,base(ii).style,'Color',gnrl.cols(ii,:)); hold on
end
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.05]);
xlabel('$\frac{g}{\theta_{v,0}} \overline{w''\theta_v''}$ (cm$^2$ s$^{-3}$)','Interpreter','latex')
set(gca,'fontsize', fs,'fontname',fnt);
text(.0,1.15,nos{5},'Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp6=subplot(246); % wtl
for ii=iis
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    zi=mean(ps(ii).zi(it3:it4));
    tw=mean(ps(ii).tot_tw(:,it3:it4),2);
    dn0=ncread(base(ii).psfile_34,'dn0'); cp=1005;
plot(tw./dn0./cp*100,ps(ii).zm./zi,base(ii).style,'Color',gnrl.cols(ii,:)); hold on
end
ylabel('$z/z_i$','Interpreter','latex'); xlabel('$\overline{w''\theta_l''}$ (cm s$^{-2}$ K$^{-1}$)','Interpreter','latex')
set(gca,'fontsize', fs,'fontname',fnt); ylim([0 1.05])
text(.0,1.15,nos{6},'Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp7=subplot(247); % wqt
for ii=iis
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    zi=mean(ps(ii).zi(it3:it4));
    qw=mean(ps(ii).tot_qw(:,it3:it4),2);
    dn0=ncread(base(ii).psfile_34,'dn0'); Lv=2.5e6;
    plot(qw./dn0./Lv*1e3*100,ps(ii).zm./zi,base(ii).style,'Color',gnrl.cols(ii,:)); hold on
end
ylabel('$z/z_i$','Interpreter','latex'); xlabel('$\overline{w''q_t''}$ (cm s$^{-1}$ g kg$^{-1}$)','Interpreter','latex')
lgd=legend(gnrl.mylgd(iis),'Location','eastoutside','Interpreter','latex','FontSize',10); 
set(gca,'fontsize', fs,'fontname',fnt); ylim([0 1.05])
text(.0,1.15,nos{7},'Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

% for ii=iis
%     it3=find(ps(ii).time==3.75*3600)+1;
%     it4=find(ps(ii).time==4*3600);
%     zi=mean(ps(ii).zi(it3:it4));
%     plot(mean(ps(ii).dissipation(:,it3:it4),2),ps(ii).zm./zi,base(ii).style,'Color',gnrl.cols(ii,:)); hold on
% end
% ylabel('$z/z_i$','Interpreter','latex'); xlabel('$\overline{w''q_t''}$ (cm s$^{-1}$ g kg$^{-1}$)','Interpreter','latex')
% legend(gnrl.mylgd(iis),'Location','eastoutside','Interpreter','latex','FontSize',10); 
% set(gca,'fontsize', fs,'fontname',fnt); ylim([0 1.05])
% text(.0,1.15,nos{7},'Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
% 
% for ii=iis
%     it3=find(ps(ii).time==3.75*3600)+1;
%     it4=find(ps(ii).time==4*3600);
%     zi=mean(ps(ii).zi(it3:it4));
%     plot(mean(ps(ii).shear_tot(:,it3:it4),2),ps(ii).zm./zi,base(ii).style,'Color',gnrl.cols(ii,:)); hold on
% end
% ylabel('$z/z_i$','Interpreter','latex'); xlabel('$\overline{w''q_t''}$ (cm s$^{-1}$ g kg$^{-1}$)','Interpreter','latex')
% legend(gnrl.mylgd(iis),'Location','eastoutside','Interpreter','latex','FontSize',10); 
% set(gca,'fontsize', fs,'fontname',fnt); ylim([0 1.05])
% text(.0,1.15,nos{7},'Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
% 


%%  print([outdir,'/statsLES_CFt_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
set(sp1,'Position',[0.07 0.6 0.17 0.34])
set(sp2,'Position',[0.32 0.6 0.17 0.34])
set(sp3,'Position',[0.57 0.6 0.17 0.34])
set(sp4,'Position',[0.82 0.6 0.17 0.34])
set(sp5,'Position',[0.07 0.12 0.17 0.34])
set(sp6,'Position',[0.32 0.12 0.17 0.34])
set(sp7,'Position',[0.57 0.12 0.175 0.34])
%% Save plot
filename=['../figures/Fig_turbfluxes_',nameplt];
fig=gcf;
fig.PaperUnits='inches';
fig.PaperPosition=[0 0 10 5];
print(filename,'-depsc')