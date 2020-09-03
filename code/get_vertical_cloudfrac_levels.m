function ps3d=get_vertical_cloudfrac_levels(ql,LWP,tl,ps)

nz=size(ql,1);

ps3d.nql=zeros(1,nz); % cloud pixel fraction
for iz=1:nz
    qlxy=squeeze(ql(iz,:,:)); % ql in the plane
    ps3d.nql(iz)=sum(sum(qlxy>0))/(size(qlxy,1)*size(qlxy,2));
end

ps3d.zm=ps.zm;
ps3d.nql_izb=find(ps3d.nql>0,1,'first'); % min base cloud
ps3d.nql_izt=find(ps3d.nql>0,1,'last'); % max top cloud
[~,ps3d.nql_max_iz]=max(ps3d.nql); % level of max cloud fraction

%% spatial cloud base, top, zi
for ii=1:size(ql,2)
    for jj=1:size(ql,3)
        tlgrad=diff(squeeze(tl(:,ii,jj)));
        [~,ktlgradmax]=max(tlgrad);
        ps3d.z_maxtlgrad_xy(ii,jj)=ps.zm(ktlgradmax); 
        if LWP(ii,jj)==0 %clear column
            ps3d.cbh_xy(ii,jj)=nan;
            ps3d.cth_xy(ii,jj)=nan;
        else
            ps3d.cbh_xy(ii,jj)=ps.zm(find(squeeze(ql(:,ii,jj))>0,1,'first'));
            ps3d.cth_xy(ii,jj)=ps.zm(find(squeeze(ql(:,ii,jj))>0,1,'last'));
        end
    end
end

%% spatial distributions (pdfs)
[ps3d.pdf_N_LWP,ps3d.pdf_lims_LWP]=histcounts(reshape(LWP,1,size(ql,2)*size(ql,3)),50);
[ps3d.pdf_N_cbh,ps3d.pdf_lims_cbh]=histcounts(ps3d.cbh_xy,25);
[ps3d.pdf_N_cth,ps3d.pdf_lims_cth]=histcounts(ps3d.cth_xy,20);
[ps3d.pdf_N_zmtg,ps3d.pdf_lims_zmtg]=histcounts(ps3d.z_maxtlgrad_xy,10);

end