load('../out/LESoutput/objects_gaussianr2n3.mat')

figure('Position',[0 0 800 400])
sp(1)=subplot(231);
for ii=1:11
    plot(0:5,obj_ud(ii).sensrgUD_nobjs,base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',1.3); hold on
end
title('Updrafts','Interpreter','latex'); xlim([0 5])
ylabel('Number of objects','Interpreter','latex'); 

sp(2)=subplot(232);
for ii=1:11
    plot(0:5,obj_ud(ii).sensrgDD_nobjs,base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',1.3); hold on
end
title('Downdrafts','Interpreter','latex'); xlim([0 5])

sp(3)=subplot(233);
for ii=1:11
    plot(0:5,obj_ql(ii).sensrg_nobjs,base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',1.3); hold on
end
title('Cloud centers','Interpreter','latex'); xlim([0 5])


sp(4)=subplot(234);
for ii=1:11
    plot(0:5,obj_ud(ii).sensrgUD_tvol,base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',1.3); hold on
end
ylabel('Total volume (km$^3$)','Interpreter','latex'); 
xlabel('Gaussian radius $r_G$','Interpreter','latex'); xlim([0 5])

sp(5)=subplot(235);
for ii=1:11
    plot(0:5,obj_ud(ii).sensrgDD_tvol,base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',1.3); hold on
end
xlabel('Gaussian radius $r_G$','Interpreter','latex'); xlim([0 5])

sp(6)=subplot(236);
for ii=1:11
    plot(0:5,obj_ql(ii).sensrg_tvol,base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',1.3); hold on
end
xlabel('Gaussian radius $r_G$','Interpreter','latex'); xlim([0 5])

lgd=legend(gnrl.mylgd(1:11),'Location','eastoutside','Interpreter','latex','FontSize',10);
%%
set(sp(1),'Position',[0.08 0.56 .21 .35])
set(sp(2),'Position',[0.35 0.56 .21 .35])
set(sp(3),'Position',[0.61 0.56 .21 .35])
set(sp(4),'Position',[0.08 0.1 .21 .35])
set(sp(5),'Position',[0.35 0.1 .21 .35])
set(sp(6),'Position',[0.61 0.1 .21 .35])
lgd.Position=[.85 .26 .14 .5];
%%
filename=['../figures/Fig_gaussianblur'];
fig=gcf;
fig.PaperUnits='inches';
fig.PaperPosition=[0 0 8 4];
print(filename,'-depsc')