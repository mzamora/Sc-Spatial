%ABL profiles at hour Z
hr=4;
fs=12; %font size
fnt='SansSerif';
lw=1.5;

% for iplt=1:4

figure('Position',[0 0 900 900])
    iis=11:-1:1;
    iis1=5:-1:1;
    iis2=[10 11 8 9 6 7];
    nameplt='all';
% switch iplt
%     case 1
%         iis=[5,4,3,2,1];
%         nameplt='sfc';
%     case 2
%         iis=[6,7,8,9,10,11];
%         nameplt='top';
%     case 3 
%         iis=[7,8,9];%,1,2,3];
%         nameplt='top000U';
%     case 4
%         iis=[1,2,3];
%         nameplt='topCTRL';
% end

% sp1=subplot(241); %qt all
% for ii=iis1
%     it=find(ps(ii).time==3600*hr); 
%     plot(ps(ii).qt(:,it),ps(ii).zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:20:131); hold on
% end
% ylim([0 1.2]); xlim([1 10])
% xlabel('$q_t(z)$ (g kg$^{-1}$) ','Interpreter','latex'); 
% ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
% text(.0,1.08,'a)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp(1)=subplot(341); %qt ABL
for ii=iis1
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    qtm=mean(ps(ii).qt(:,it3:it4),2); zi=mean(ps(ii).zi(it3:it4));
    plot(qtm,ps(ii).zm/zi,base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:15:131); hold on
    if ii==5
        qtm00=qtm;
    end
end
ylim([0 1]); xlim([8.85 9.15])
xlabel('$q_t(z)$ (g kg$^{-1}$) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
text(.0,1.1 ,'a)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
sp(2)=subplot(342); %qt ABL
for ii=iis2
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    qtm=mean(ps(ii).qt(:,it3:it4),2); zi=mean(ps(ii).zi(it3:it4));
    plot(qtm,ps(ii).zm/zi,base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:15:131); hold on
end
plot(qtm00,ps(5).zm/zi,':','Color',[.5 .5 .5],'LineWidth',lw)
ylim([0 1]); xlim([8.85 9.15])
xlabel('$q_t(z)$ (g kg$^{-1}$) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
% text(.0,1.08 ,'b)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp(3)=subplot(343); %qt inversion
for ii=iis1
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    qtm=mean(ps(ii).qt(:,it3:it4),2); zi=mean(ps(ii).zi(it3:it4));
    plot(qtm,ps(ii).zm/zi,base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:3:131); hold on
    if ii==5
        qtm00=qtm;
    end
end
ylim([.93 1.07]); xlim([1 9.5])
xlabel('$q_t(z)$ (g kg$^{-1}$) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
text(.0,1.2,'b)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
sp(4)=subplot(344); %qt inversion
for ii=iis2
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    qtm=mean(ps(ii).qt(:,it3:it4),2); zi=mean(ps(ii).zi(it3:it4));
    plot(qtm,ps(ii).zm/zi,base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:3:131); hold on
end
plot(qtm00,ps(5).zm/zi,':','Color',[.5 .5 .5],'LineWidth',lw)
ylim([.93 1.07]); xlim([1 9.5])
xlabel('$q_t(z)$ (g kg$^{-1}$) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
% text(.0,1.12,'c)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

% sp4=subplot(244); %tl all
% for ii=iis
%     plot(ps(ii).tl(:,it),ps(ii).zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:20:131); hold on
% end
% ylim([0 1.2]); xlim([288 303])
% xlabel('$\theta_l(z)$ (K) ','Interpreter','latex'); 
% ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
% text(.0,1.08,'d)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp(5)=subplot(345); %tl ABL
for ii=iis1
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    tlm=mean(ps(ii).tl(:,it3:it4),2); zi=mean(ps(ii).zi(it3:it4));
    plot(tlm,ps(ii).zm/zi,base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:15:131); hold on
    if ii==5
        tlm00=tlm;
    end
end
ylim([0 1]); xlim([289.3 289.7])
xlabel('$\theta_l(z)$ (K) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
text(.0,1.1,'c)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
sp(6)=subplot(346); %tl ABL
for ii=iis2
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    tlm=mean(ps(ii).tl(:,it3:it4),2); zi=mean(ps(ii).zi(it3:it4));
    plot(tlm,ps(ii).zm/zi,base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:15:131); hold on
end
plot(tlm00,ps(5).zm/zi,':','Color',[.5 .5 .5],'LineWidth',lw)
ylim([0 1]); xlim([289.3 289.7])
xlabel('$\theta_l(z)$ (K) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
% text(.0,1.08,'e)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp(7)=subplot(347); %tl inversion
for ii=iis1
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    tlm=mean(ps(ii).tl(:,it3:it4),2); zi=mean(ps(ii).zi(it3:it4));
    plot(tlm,ps(ii).zm/zi,base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:3:131); hold on
end
ylim([.93 1.07]); xlim([289 302]); xticks([290 294 298 302])
xlabel('$\theta_l(z)$ (K) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
text(.0,1.2,'d)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
sp(8)=subplot(348); %tl inversion
for ii=iis2
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    tlm=mean(ps(ii).tl(:,it3:it4),2); zi=mean(ps(ii).zi(it3:it4));
    plot(tlm,ps(ii).zm/zi,base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:3:131); hold on
end
plot(tlm00,ps(5).zm/zi,':','Color',[.5 .5 .5],'LineWidth',lw)
ylim([.93 1.07]); xlim([289 302]); xticks([290 294 298 302])
xlabel('$\theta_l(z)$ (K) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
% text(.0,1.12,'f)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

% sp7=subplot(247); %wind speed mean(z)
% for ii=1:11
%     it=find(ps(ii).time==3600*hr); 
%     plot(ps(ii).q_mean(:,it),ps(ii).zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
% end
% ylim([0 1.2]); 
% xlabel('$r(z)$ (m s$^{-1}$)','Interpreter','latex');
% ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs,'fontname',fnt)
% text(.0,1.1,'g)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

% calculate adiabatic ql for the 000U case (jan 2021 review)
tl=ps(5).tl(:,it); ql=ps(5).ql(:,it); qt=ps(5).qt(:,it); p=ps(5).p(:,it);

izt=find(zm<=ps(ii).zct(it),1,'last'); %these are from mean values
izb=find(zm>=ps(ii).zb(it),1); 

% inversion jumps
d2tl=diff(diff(tl)./diff(zm)); 
iz0=1; iz1=find(abs(d2tl(iz0:end-5))>5e-3,1); iz2=find(abs(d2tl(iz0:end-5))>5e-3,1,'last');
tlBL=mean(tl(iz0:iz0+iz1)); qtBL=mean(qt(iz0:iz0+iz1));
tl0=tl; tl0(1:iz0+iz1)=tlBL; qt0=qt; qt0(1:iz0+iz1)=qtBL;
T=compute_T(qt0/1000,p,tl0); Tc=T-273.15;
c0=0.6105851e+03; c1=0.4440316e+02; c2=0.1430341e+01; c3=0.2641412e-01;
c4=0.2995057e-03; c5=0.2031998e-05; c6=0.6936113e-08; c7=0.2564861e-11; c8=-.3704404e-13;
esl=c0+Tc.*(c1+Tc.*(c2+Tc.*(c3+Tc.*(c4+Tc.*(c5+Tc.*(c6+Tc.*(c7+Tc.*c8)))))));
es=6.1094*exp((17.625*Tc)./(Tc+243.04))*100; %in hPa
qs=1000*0.622*es./(p-es); %double check with plot(qs,zm,qt,zm,ql,zm)
qladiab=max(qt0-qs,0);

sp(9)=subplot(349); %ql 
for ii=iis
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    qlm=mean(ps(ii).ql(:,it3:it4),2); zi=mean(ps(ii).zi(it3:it4));
    plot(qlm,ps(ii).zm/zi,base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:5:131); hold on
end
plot(qladiab,zm/ps(5).zi(it),':','Color',[.5 .5 .5],'LineWidth',lw)
ylim([0.65 1.05]); xlim([0 0.4]); yticks([.7 .8 .9 1])
xlabel('$q_l(z)$ (g kg$^{-1}$)','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
text(.0,1.1,'e)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
% sp(10)=subplot(2,5,10); %ql 
% for ii=iis2
%     plot(ps(ii).ql(:,it),ps(ii).zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:5:131); hold on
% end
% ylim([0.65 1.05]); xlim([0 0.35]); yticks([.7 .8 .9 1])
% xlabel('$q_l(z)$ (g kg$^{-1}$)','Interpreter','latex');
% ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)

sp(10)=subplot(3,4,10); % w variance
for ii=iis
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    w2=mean(ps(ii).w2(:,it3:it4),2); zi=mean(ps(ii).zi(it3:it4));
    plot(w2,ps(ii).zm./zi,base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',lw,'MarkerIndices',1:20:131); hold on
end
ylabel('$z/z_i$','Interpreter','latex'); ylim([0 1.05]);
xlabel('$\overline{w''w''}$ (m$^2$ s$^{-2}$)','Interpreter','latex'); 
set(gca,'fontsize', fs,'fontname',fnt)
text(0,1.1,'f)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp(11)=subplot(3,4,11); % uv variance
for ii=iis
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    zi=mean(ps(ii).zi(it3:it4));
    q2=mean(sqrt(ps(ii).u2(:,it3:it4).^2+ps(ii).v2(:,it3:it4).^2),2);
    plot(q2,ps(ii).zm./zi,base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',lw,'MarkerIndices',1:20:131); hold on
end
%yticks([.9 .92 .94 .96 .98 1])
ylabel('$z/z_i$','Interpreter','latex'); xlabel('$\sigma_r$ (m$^2$ s$^{-2}$)','Interpreter','latex'); 
set(gca,'fontsize',fs,'fontname',fnt); ylim([0 1.05]);
text(0,1.1,'g)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex')%subplot label

sp(12)=subplot(3,4,12); % q'w' (momentum flux
for ii=1:11
    it3=find(ps(ii).time==3.75*3600)+1;
    it4=find(ps(ii).time==4*3600);
    qw=mean(sqrt(ps(ii).uw(:,it3:it4).^2+ps(ii).vw(:,it3:it4).^2),2);
    plot(qw,ps(ii).zm./ps(ii).zi(end),base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',lw,'MarkerIndices',1:20:131); hold on
end
ylabel('$z/z_i$','Interpreter','latex'); xlabel('$F_r$ (m$^2$ s$^{-2}$)','Interpreter','latex'); 
set(gca,'fontsize', fs,'fontname',fnt); ylim([0 1.05]);
text(0,1.1,'h)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex')%subplot label
%%
set(sp(1),'Position',[0.06 0.74 0.14 0.23])
set(sp(2),'Position',[0.20 0.74 0.14 0.23]); sp(2).YTickLabel=[]; sp(2).YLabel=[];

set(sp(3),'Position',[0.43 0.855 0.3 0.115]); sp(3).XTickLabel=[];sp(3).XLabel=[];
set(sp(4),'Position',[0.43 0.74 0.3 0.115])

set(sp(5),'Position',[0.06 0.4 0.14 0.23])
set(sp(6),'Position',[0.20 0.4 0.14 0.23]); sp(6).YTickLabel=[]; sp(6).YLabel=[];
set(sp(7),'Position',[0.43 0.515 0.3 0.115]); sp(7).XTickLabel=[];sp(7).XLabel=[];
set(sp(8),'Position',[0.43 0.4 0.3 0.115])

set(sp(9) ,'Position',[0.81 0.74 0.18 0.23]); %sp(9).XTickLabel=[];sp(9).XLabel=[];

set(sp(10),'Position',[0.06 0.07 0.26 0.23])
set(sp(11),'Position',[0.395 0.07 0.26 0.23])
set(sp(12),'Position',[0.73 0.07 0.26 0.23])
% lgd.Position=[0.84 0.12 0.1 0.33];
%%
fig=gcf;
fig.PaperUnits='inches';
fig.PaperPosition=[0 0 9 9];
print(['../figures/Fig_ThermoProfiles_jan2021'],'-depsc'); %close(1);
