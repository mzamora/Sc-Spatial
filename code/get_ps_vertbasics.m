function ps=get_ps_vertbasics(base,ts)
    mycol=base.color;
    mystyle=base.style;
 %% vertical profiles
    psfile1=base.psfile_03;
    psfile2=base.psfile_34;
    ps.zm=ncread(psfile1,'zm'); ps.nz=length(ps.zm);
    ps.time=[ncread(psfile1,'time');ncread(psfile2,'time')];
    ps.zi=ts.zis(ismember(ts.times,ps.time));
    ps.zb=ts.zcb(ismember(ts.times,ps.time));
%     ps.zi=mean(ts.zis(ismember(ts.times,ts.time0+(it1:it2)*60))); %mean zi between min 30-45
%     ps.zb=mean(ts.zcb(ismember(ts.times,ts.time0+(it1:it2)*60))); %mean zb between min 30-45

    %% wind things
    ps.u_mean=[convert_zt_to_zm(ncread(psfile1,'u')) , convert_zt_to_zm(ncread(psfile2,'u'))];
    ps.v_mean=[ncread(psfile1,'v'), ncread(psfile2,'v')];
    ps.q_mean=sqrt(ps.u_mean.^2+ps.v_mean.^2); %speed magnitude
    ps.dir_mean=atan2(ps.v_mean,ps.u_mean)*180/pi; %direction in degrees;

    for itime=1:size(ps.u_mean,2)
        filter=ps.zm<ps.zi(itime);
        ps.u0(itime)=trapz(ps.zm(filter),ps.u_mean(filter,itime))/ps.zi(itime); %uBL
        ps.v0(itime)=trapz(ps.zm(filter),ps.v_mean(filter,itime))/ps.zi(itime); %vBL
    end
    ps.q0=sqrt(ps.u0.^2+ps.v0.^2); %speed magnitude in BL
    ps.dir0=atan2(ps.v0,ps.u0)*180/pi; %direction in degrees in BL
    ps.dn0=ncread(psfile1,'dn0');
    
    %%
    ps.qt=[convert_zt_to_zm(ncread(psfile1,'q')),convert_zt_to_zm(ncread(psfile2,'q'))];
    ps.ql=[convert_zt_to_zm(ncread(psfile1,'l')),convert_zt_to_zm(ncread(psfile2,'l'))];
    ps.rflx=[convert_zt_to_zm(ncread(psfile1,'rflx')),convert_zt_to_zm(ncread(psfile2,'rflx'))];
    ps.tl=[convert_zt_to_zm(ncread(psfile1,'t')),convert_zt_to_zm(ncread(psfile2,'t'))];
    ps.u=[convert_zt_to_zm(ncread(psfile1,'u')),convert_zt_to_zm(ncread(psfile2,'u'))];
    
    %% 
    ps.tot_tw=[ncread(psfile1,'tot_tw'),ncread(psfile2,'tot_tw')];
    ps.tot_qw=[ncread(psfile1,'tot_qw'),ncread(psfile2,'tot_qw')];
    ps.uw=[ncread(psfile1,'tot_uw'),ncread(psfile2,'tot_uw')];
    ps.vw=[ncread(psfile1,'tot_vw'),ncread(psfile2,'tot_vw')];
    ps.uvw=sqrt(ps.uw.^2+ps.vw.^2); 
    ps.uvw_alfa=atan2(ps.vw,ps.uw);
    ps.buoy_sfs=[ncread(psfile1,'sfs_boy'),ncread(psfile2,'sfs_boy')];
    ps.buoy_resolved=[ncread(psfile1,'boy_prd'),ncread(psfile2,'boy_prd')];
    ps.buoy_tot=ps.buoy_sfs+ps.buoy_resolved;
    ps.shear_sfs=[ncread(psfile1,'sfs_shr'),ncread(psfile2,'sfs_shr')];
    ps.shear_resolved=[ncread(psfile1,'shr_prd'),ncread(psfile2,'shr_prd')];
    ps.shear_tot=ps.shear_sfs+ps.shear_resolved;
    ps.dissipation=[ncread(psfile1,'diss'),ncread(psfile2,'diss')];
    
    % ql variance and skewness
    ps.ql2=[ncread(psfile1,'l_2'),ncread(psfile2,'l_2')];
    ps.ql3=[ncread(psfile1,'l_3'),ncread(psfile2,'l_3')];
    ps.u2=[ncread(psfile1,'u_2'),ncread(psfile2,'u_2')];
    ps.v2=[ncread(psfile1,'v_2'),ncread(psfile2,'v_2')];
    ps.uv2=sqrt(ps.u2.^2+ps.v2.^2);
    ps.w2=[ncread(psfile1,'w_2'),ncread(psfile2,'w_2')];
    

end