for ii=1:11
    % load 3D data
    casename=base(ii).name;
    filename=[casename(1:end-4),'hr3_4/'];
    var3d={'w','u','v','tl','tv','qt','ql','LWP'};
    for ivar=1:length(var3d)
        load([filename,'rf01_',var3d{ivar},num2str(time,'%02i')])
    end
    load([filename,'rf01_zm'])
    load([filename,'rf01_xm'])
    load([filename,'rf01_ym'])
    
    %% get mean wind speed profile for future orientations
    [u_z,v_z,winddir_z,sheardir_z]=get_mean_windspeed_z(u,v,w,ps3d(ii).nql_izt,ps(ii).zm);
    ps3d(ii).winddir_zhr4=winddir_z;
    ps3d(ii).sheardir_zhr4=sheardir_z;

end
%%
figure('Position',[1500 0 1200 600])
orients_UD=nan(11,12); orientvert_UD=nan(11,12);
orients_DD=nan(11,12); orientvert_DD=nan(11,12);
orients_cld=nan(11,12); orientvert_cld=nan(11,12);
for ii=1:11
    it=find(ps(ii).time==4*3600);
    iz0=find(ps(ii).zm>0.1*ps(ii).zi(it),1);
    switch ii
        case {1,10,11} %000U cases
            meandir=0;
        otherwise
            meandir_z=rad2deg(ps3d(ii).winddir_zhr4);
            meandir=mean(meandir_z(1:ps3d(ii).nql_izt));
    end
    orient_vert=max(obj_ud(ii).rpUD.Orientation(:,[1,3]),[],2);
    N=histcounts(orient_vert,-90:15:90); orientvert_UD(ii,:)=N/sum(N);
    orient_wrtwind=obj_ud(ii).rpUD.Orientation(:,2);
    orient_wrtwind(orient_wrtwind>90)=orient_wrtwind(orient_wrtwind>90)-90;   
    N=histcounts(orient_wrtwind,-90:15:90); orients_UD(ii,:)=N/sum(N);
    
    orient_vert=max(obj_ud(ii).rpDD.Orientation(:,[1,3]),[],2);
    N=histcounts(orient_vert,-90:15:90); orientvert_DD(ii,:)=N/sum(N);
    orient_wrtwind=obj_ud(ii).rpDD.Orientation(:,2);
    orient_wrtwind(orient_wrtwind>90)=orient_wrtwind(orient_wrtwind>90)-90;   
    N=histcounts(orient_wrtwind,-90:15:90); orients_DD(ii,:)=N/sum(N);
    
    orient_vert=max(obj_ql(ii).rp.Orientation(:,[1,3]),[],2);
    N=histcounts(orient_vert,-90:15:90); orientvert_cld(ii,:)=N/sum(N);
    orient_wrtwind=obj_ql(ii).rp.Orientation(:,2);
    orient_wrtwind(orient_wrtwind>90)=orient_wrtwind(orient_wrtwind>90)-90;   
    N=histcounts(orient_wrtwind,-90:15:90); orients_cld(ii,:)=N/sum(N);
end
sp1=subplot(231); imagesc(orients_UD'); 
xticks([]); %xticks(1:11); xticklabels(gnrl.mylgd);xtickangle(45)
yticks(.5:2:12.5); yticklabels(-90:30:90); caxis([0 0.33])
title('Updrafts','Interpreter','latex')
ylabel('Orientation to mean wind (deg)','Interpreter','latex')
text(0,1.1,'a)','Units','Normalized','VerticalAlignment','Top','FontSize',12,'Interpreter','latex') %subplot label
set(gca,'FontSize',12)

sp2=subplot(232); imagesc(orients_DD'); %ylim([-60 60])
xticks([]); %xticks(1:11); xticklabels(gnrl.mylgd);xtickangle(45)
yticks(.5:2:12.5); yticklabels(-90:30:90); caxis([0 0.33])
title('Downdrafts','Interpreter','latex')
text(0,1.1,'b)','Units','Normalized','VerticalAlignment','Top','FontSize',12,'Interpreter','latex') %subplot label
set(gca,'FontSize',12)

sp3=subplot(233); imagesc(orients_cld'); %ylim([-60 60])
xticks([]); %xticks(1:11); xticklabels(gnrl.mylgd);xtickangle(45)
yticks(.5:2:12.5); yticklabels(-90:30:90); caxis([0 0.33])
title('Cloud cores','Interpreter','latex')
text(0,1.1,'c)','Units','Normalized','VerticalAlignment','Top','FontSize',12,'Interpreter','latex') %subplot label
set(gca,'FontSize',12)
c=colorbar; ylabel(c,'Frequency','Interpreter','latex','Fontsize',12)

sp4=subplot(234); imagesc(orientvert_UD'); 
xticks(1:11); xticklabels(gnrl.mylgd);xtickangle(45)
yticks(.5:2:12.5); yticklabels(-90:30:90); caxis([0 0.8])
% title('Updrafts','Interpreter','latex')
text(0,1.1,'d)','Units','Normalized','VerticalAlignment','Top','FontSize',12,'Interpreter','latex') %subplot label
ylabel('Vertical orientation (deg)','Interpreter','latex')
set(gca,'FontSize',12)

sp5=subplot(235); imagesc(orientvert_DD'); %ylim([-60 60])
xticks(1:11); xticklabels(gnrl.mylgd);xtickangle(45)
yticks(.5:2:12.5); yticklabels(-90:30:90); caxis([0 0.8])
% title('Downdrafts','Interpreter','latex')
text(0,1.1,'e)','Units','Normalized','VerticalAlignment','Top','FontSize',12,'Interpreter','latex') %subplot label
set(gca,'FontSize',12)

sp6=subplot(236); imagesc(orientvert_cld'); %ylim([-60 60])
xticks(1:11); xticklabels(gnrl.mylgd);xtickangle(45)
yticks(.5:2:12.5); yticklabels(-90:30:90); caxis([0 0.8])
% title('Cloud cores','Interpreter','latex')
text(0,1.1,'f)','Units','Normalized','VerticalAlignment','Top','FontSize',12,'Interpreter','latex') %subplot label
set(gca,'FontSize',12)
c=colorbar; ylabel(c,'Frequency','Interpreter','latex','Fontsize',12)

sp1.Position=[.07 .56 .23 .36];
sp2.Position=[.36 .56 .23 .36];
sp3.Position=[.65 .56 .23 .36];
sp4.Position=[.07 .13 .23 .36];
sp5.Position=[.36 .13 .23 .36];
sp6.Position=[.65 .13 .23 .36];
fig=gcf;
fig.PaperUnits='inches';
fig.PaperPosition=[0 0 12 6];
print('../figures/Fig_objectorient','-depsc','-r600'); %close(1);
%%


