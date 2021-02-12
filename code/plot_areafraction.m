
for ii=1:11
    gnrl.mylgd(ii)

%% type I updrafts
zm=ps(ii).zm;
iobjs=find(obj_ud(ii).filters_UD(:,1));
maskUD=zeros(obj_ud(ii).ccUD.ImageSize(1),396,396);
for i=1:length(iobjs)
    iobj=iobjs(i);
    %transform 3x to 1x
    [iz,ix,iy]=pixels_3x_to_1x(obj_ud(ii).ccUD.PixelIdxList{iobj},obj_ud(ii).ccUD.ImageSize(1),396,396); % get 
    maskUD(sub2ind(size(maskUD),iz,ix,iy))=1;
end

% type II updrafts
iobjs=find(obj_ud(ii).filters_UD(:,2));
maskUD2=zeros(obj_ud(ii).ccUD.ImageSize(1),396,396);
for i=1:length(iobjs)
    iobj=iobjs(i);
    %transform 3x to 1x
    [iz,ix,iy]=pixels_3x_to_1x(obj_ud(ii).ccUD.PixelIdxList{iobj},obj_ud(ii).ccUD.ImageSize(1),396,396); % get 
    maskUD2(sub2ind(size(maskUD2),iz,ix,iy))=1;
end

% type I downdrafts
iobjs=find(obj_ud(ii).filters_DD(:,1));
maskDD=zeros(obj_ud(ii).ccDD.ImageSize(1),396,396);
for i=1:length(iobjs)
    iobj=iobjs(i);
    %transform 3x to 1x
    [iz,ix,iy]=pixels_3x_to_1x(obj_ud(ii).ccDD.PixelIdxList{iobj},obj_ud(ii).ccDD.ImageSize(1),396,396); % get 
    maskDD(sub2ind(size(maskDD),iz,ix,iy))=1;
end

% type II downdrafts
iobjs=find(obj_ud(ii).filters_DD(:,2));
maskDD2=zeros(obj_ud(ii).ccDD.ImageSize(1),396,396);
for i=1:length(iobjs)
    iobj=iobjs(i);
    %transform 3x to 1x
    [iz,ix,iy]=pixels_3x_to_1x(obj_ud(ii).ccDD.PixelIdxList{iobj},obj_ud(ii).ccDD.ImageSize(1),396,396); % get 
    maskDD2(sub2ind(size(maskDD2),iz,ix,iy))=1;
end

for iz=1:size(maskUD,1)
    afracUDI(ii,iz)=sum(maskUD(iz,:,:),[2 3])/(nx*ny);
    afracUDII(ii,iz)=sum(maskUD2(iz,:,:),[2 3])/(nx*ny);
    afracDDI(ii,iz)=sum(maskDD(iz,:,:),[2 3])/(nx*ny);
    afracDDII(ii,iz)=sum(maskDD2(iz,:,:),[2 3])/(nx*ny);
end

end
%%
figure('Position',[0 0 900 300])
sp(1)=subplot(121);
for ii=1:11
    it=find(ps(ii).time==4*3600);
    plot(afracUDI(ii,:)+afracUDII(ii,:),zm(1:size(maskUD,1))/ps(ii).zi(it),base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',lw,'MarkerIndices',1:10:100); hold on
end
ylim([0 1])
ylabel('$z/z_i$','FontSize',12,'Interpreter','latex'); xlabel('$\rm UD^{I+II}$ Area fraction','FontSize',12,'Interpreter','latex')
text(.0,1.1,'d)','Units','Normalized','VerticalAlignment','Top','FontSize',12,'Interpreter','latex') %subplot label

sp(2)=subplot(122);
for ii=1:11
    it=find(ps(ii).time==4*3600);
    plot(afracDDI(ii,:)+afracDDII(ii,:),zm(1:size(maskUD,1))/ps(ii).zi(it),base(ii).style,'Color',gnrl.cols(ii,:),'LineWidth',lw,'MarkerIndices',1:10:100); hold on
end
ylim([0 1])
ylabel('$z/z_i$','FontSize',12,'Interpreter','latex'); xlabel('$\rm DD^{I+II}$ Area fraction','FontSize',12,'Interpreter','latex')
text(.0,1.1,'e)','Units','Normalized','VerticalAlignment','Top','FontSize',12,'Interpreter','latex') %subplot label

lgd=legend(gnrl.mylgd,'Location','eastoutside','FontSize',12,'Interpreter','latex');

%%
sp(1).Position=[.07 .14 .33 .78]
sp(2).Position=[.5 .14 .33 .78]
lgd.Position=[.85 .17 .14 .74]
%%
print('../figures/Fig_areafraction','-depsc')