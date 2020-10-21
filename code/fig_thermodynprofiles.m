%ABL profiles at hour Z
hr=4;
fs=12; %font size
fnt='SansSerif';
lw=1.2;

% for iplt=1:4

figure('Position',[0 0 1000 600])
    iis=1:11;
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

sp1=subplot(241); %qt all
for ii=iis
    it=find(ps(ii).time==3600*hr); 
    plot(ps(ii).qt(:,it),ps(ii).zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:20:131); hold on
end
ylim([0 1.2]); xlim([1 10])
xlabel('$q_t(z)$ (g kg$^{-1}$) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
text(.0,1.08,'a)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp2=subplot(242); %qt ABL
for ii=iis
    plot(ps(ii).qt(:,it),ps(ii).zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:15:131); hold on
end
ylim([0 1]); xlim([8.9 9.2])
xlabel('$q_t(z)$ (g kg$^{-1}$) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
text(.0,1.08 ,'b)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label


sp3=subplot(243); %qt inversion
for ii=iis
    plot(ps(ii).qt(:,it),ps(ii).zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:3:131); hold on
end
ylim([.95 1.05]); xlim([1 9.5])
xlabel('$q_t(z)$ (g kg$^{-1}$) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
text(.0,1.12,'c)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp4=subplot(244); %tl all
for ii=iis
    plot(ps(ii).tl(:,it),ps(ii).zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:20:131); hold on
end
ylim([0 1.2]); xlim([288 303])
xlabel('$\theta_l(z)$ (K) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
text(.0,1.08,'d)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp5=subplot(245); %tl ABL
for ii=iis
    plot(ps(ii).tl(:,it),ps(ii).zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:15:131); hold on
end
ylim([0 1]); xlim([289.3 289.7])
xlabel('$\theta_l(z)$ (K) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
text(.0,1.08,'e)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp6=subplot(246); %tl inversion
for ii=iis
    plot(ps(ii).tl(:,it),ps(ii).zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:3:131); hold on
end
ylim([.95 1.05]); xlim([289 302]); xticks([290 294 298 302])
xlabel('$\theta_l(z)$ (K) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
text(.0,1.12,'f)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

% sp7=subplot(247); %wind speed mean(z)
% for ii=1:11
%     it=find(ps(ii).time==3600*hr); 
%     plot(ps(ii).q_mean(:,it),ps(ii).zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color); hold on
% end
% ylim([0 1.2]); 
% xlabel('$r(z)$ (m s$^{-1}$)','Interpreter','latex');
% ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', fs,'fontname',fnt)
% text(.0,1.1,'g)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label

sp8=subplot(248); %ql 
for ii=iis
    plot(ps(ii).ql(:,it),ps(ii).zm/ps(ii).zi(it),base(ii).style,'Color',base(ii).color,'LineWidth',lw,'MarkerIndices',1:5:131); hold on
end
ylim([0.7 1.03]); xlim([0 0.35]); yticks([.7 .8 .9 1])
xlabel('$q_l(z)$ (g kg$^{-1}$)','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize',fs,'fontname',fnt)
text(.0,1.08,'g)','Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
lgd=legend(gnrl.mylgd,'Interpreter','latex','fontsize',fs,'fontname',fnt);

set(sp1,'Position',[0.05 0.1 0.13 0.5])
set(sp3,'Position',[0.05 0.74 0.33 0.23])
set(sp2,'Position',[0.24 0.1 0.14 0.5])

set(sp4,'Position',[0.45 0.1 0.13 0.5])
set(sp6,'Position',[0.45 0.74 0.33 .23])
set(sp5,'Position',[0.64 0.1 0.14 0.5])

% set(sp7,'Position',[0.75 0.59 0.13 0.37])
set(sp8,'Position',[0.85 0.52 0.14 0.44])
lgd.Position=[0.87 0.06 0.1 0.33];
sp3.YLabel.Position=[0.3 1.0000 -1];
sp6.YLabel.Position=[287.9 1.0000 -1];
%%
fig=gcf;
fig.PaperUnits='inches';
fig.PaperPosition=[0 0 12 6];
print(['../figures/Fig_ThermoWindz'],'-depsc'); %close(1);


%% extra stuff
figure(2)
sp1=subplot(121);
for ii=iis
    plot(diff(ps(ii).qt(:,it)),ps(ii).zm(2:end)/ps(ii).zi,base(ii).style,'Color',base(ii).color); hold on
end
ylim([0.2 0.7])
xlabel('$\partial_z q_t(z)$ (g kg$^{-1}$ m$^{-1}$)','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', 14,'fontname',fnt)

sp2=subplot(122);
for ii=iis
    plot(diff(ps(ii).tl(:,it)),ps(ii).zm(2:end)/ps(ii).zi,base(ii).style,'Color',base(ii).color); hold on
end
ylim([0.2 0.7])
xlabel('$\partial_z \theta_l(z)$ (K m$^{-1}$)','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', 14,'fontname',fnt)


legend(gnrl.mylgd(iis),'Interpreter','latex','Location','eastoutside')
set(sp1,'Position',[0.07 0.2 0.19 0.7])
set(sp2,'Position',[0.35 0.2 0.19 0.7])

% end

%% version with CTRL as reference case
hr=3;
it=find(ps(1).time==3600*hr); 
figure('Position',[0 0 1200 300])
zzi=0:0.005:1.1;

for iplt=1:3
    %%
    iref=7; % 000U is the reference case
switch iplt
    case 1
        iis=[7,6,5,4,1];
        nameplt='sfc';
    case 2 
        iis=[7,8,9];%,1,2,3];
        nameplt='top000U';
    case 3
        iis=[1,2,3];
        nameplt='topCTRL';
end
figure(1)
sp1=subplot(131);
ref=interp1(ps(iref).zm/ps(iref).zi(it),ps(iref).ql(:,it),zzi);
for ii=iis
    delta=interp1(ps(ii).zm/ps(ii).zi(it),ps(ii).ql(:,it),zzi)-ref;
    plot(delta,zzi,base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1.01]); %xlim([0 0.4])
xlabel('$\delta q_l(z)$ (g kg$^{-1}$)','Interpreter','latex');
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', 14,'fontname',fnt)

sp2=subplot(132);
ref=interp1(ps(iref).zm/ps(iref).zi(it),ps(iref).qt(:,it),zzi);
for ii=iis
    delta=interp1(ps(ii).zm/ps(ii).zi(it),ps(ii).qt(:,it),zzi)-ref;
    plot(delta,zzi,base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1.01])
xlabel('$\delta  q_t(z)$ (g kg$^{-1}$) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', 14,'fontname',fnt)

sp3=subplot(133);
ref=interp1(ps(iref).zm/ps(iref).zi(it),ps(iref).tl(:,it),zzi);
for ii=iis
    delta=interp1(ps(ii).zm/ps(ii).zi(it),ps(ii).tl(:,it),zzi)-ref;
    plot(delta,zzi,base(ii).style,'Color',base(ii).color); hold on
end
ylim([0 1.01])
xlabel('$\theta_l(z)$ (K) ','Interpreter','latex'); 
ylabel('$z/z_i$','Interpreter','latex');set(gca,'fontsize', 14,'fontname',fnt)
legend(gnrl.mylgd(iis),'Interpreter','latex','Location','eastoutside')

set(sp1,'Position',[0.07 0.2 0.19 0.7])
set(sp2,'Position',[0.35 0.2 0.19 0.7])
set(sp3,'Position',[0.64 0.2 0.19 0.7])

 end

%%



