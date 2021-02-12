%% sfc wind first
lw=1.5;
for iplt=1:2 % 3
    switch iplt 
        case 1
            iis=1:5; nameplt='sfc'; hr=5;
            nos={'a)','b)','c)','d)'};
        case 2
            iis=[6,7,8,9,10,11]; nameplt='top'; hr=5;
            nos={'e)','f)','g)','h)'};
        case 3
            iis=1:11, nameplt='all', hr=5;
            nos={'a)','b)','c)','d)'};
    end
    
    fs=12; %font size
figure('Position',[0 0 1200 300])
fnt='SansSerif';
sp1=subplot(141); % vtke evol
for ii=iis
% plot(ps(ii).t_10min/3600,ps(ii).we_10min*1000,base(ii).style,'Color',gnrl.cols(ii,:)); hold on
plot(ts(ii).times/3600,ts(ii).vtke/1000,base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',lw,'MarkerIndices',1:240:1201); hold on
end
xlabel('Time (h)','Interpreter','latex'); 
% ylabel('$w_e$ (mm s$^{-1}$)','Interpreter','latex'); 
ylabel('Integrated TKE (m$^3$ s$^{-2}$)','Interpreter','latex'); 
set(gca,'fontsize', fs,'fontname',fnt); ylim([0 1.5])
text(0,1.12,nos{1},'Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
xticks([0 2 4])

sp2=subplot(142); % cloud fraction evol
for ii=iis
plot(ts(ii).times/3600,ts(ii).CF,base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',lw,'MarkerIndices',1:240:1201); hold on
end
%yticks([.9 .92 .94 .96 .98 1])
xlabel('Time (h)','Interpreter','latex'); ylabel('Cloud fraction','Interpreter','latex'); 
set(gca,'fontsize', fs,'fontname',fnt); ylim([.8 1])
text(0,1.12,nos{2},'Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex')%subplot label
xticks([0 2 4])

sp3=subplot(143); % LWP
for ii=iis
plot(ts(ii).times/3600,ts(ii).lwp,base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',lw,'MarkerIndices',1:240:1201); hold on
end
xlabel('Time (h)','Interpreter','latex'); ylabel('Liquid water path (g m$^{-2}$)','Interpreter','latex')
set(gca,'fontsize', fs,'fontname',fnt); ylim([0 80])
text(.0,1.12,nos{3},'Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
xticks([0 2 4])

sp4=subplot(144); % cloud boundaries
for ii=iis
plot(ts(ii).times/3600,ts(ii).zis,base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',lw,'MarkerIndices',1:240:1201); hold on
end
for ii=iis
plot(ts(ii).times/3600,ts(ii).zcb,base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',lw,'MarkerIndices',1:240:1201); hold on
end
xlabel('Time (h)','Interpreter','latex'); ylabel('Cloud boundaries (m)','Interpreter','latex')
legend(gnrl.mylgd(iis),'Location','eastoutside','Interpreter','latex'); 
set(gca,'fontsize', fs,'fontname',fnt); ylim([580 900])
text(.0,1.12,nos{4},'Units','Normalized','VerticalAlignment','Top','FontSize',fs,'Interpreter','latex') %subplot label
xticks([0 2 4])

%  print([outdir,'/statsLES_CFt_',nkxdays{ii},'_',num2str(time,'%02i')],'-depsc')
set(sp1,'Position',[0.06 0.2 0.15 0.7],'XLim',[0 hr])
set(sp2,'Position',[0.28 0.2 0.15 0.7],'XLim',[0 hr])
set(sp3,'Position',[0.49 0.2 0.15 0.7],'XLim',[0 hr])
set(sp4,'Position',[0.71 0.2 0.15 0.7],'XLim',[0 hr])
%% Save plot
filename=['../figures/Fig1_timeevolution_',nameplt];
fig=gcf;
fig.PaperUnits='inches';
fig.PaperPosition=[0 0 12 3];
print(filename,'-depsc')

end