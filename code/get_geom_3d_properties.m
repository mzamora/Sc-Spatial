function [ccout,vol,rp]=get_geom_3d_properties(varb,var_th,zm,xm,ym,izt)

ccout=binarize_periodic_3d(varb(1:izt,:,:),var_th(1:izt));
vol=volume_from_extended_objects(ccout,zm(1:izt),xm,ym);
% ftoosmall=vol/1e9<0.25; % remove objs with volume lower than 0.25 m3 (ref Brient 2019)
% if sum(ftoosmall)>0
%     ccout.NumObjects=ccout.NumObjects-sum(ftoosmall);    
%     for iobj=find(ftoosmall)
%         ccout.PixelIdxList{iobj}=[]; %delete object points
%     end
%     ccout=bwconncomp(labelmatrix(ccout)>0); %redo object finding
% end
rp=regionprops3(ccout,'Volume','Centroid','BoundingBox','Orientation','Solidity');
% ci=regionprops3(ccout,'ConvexImage');