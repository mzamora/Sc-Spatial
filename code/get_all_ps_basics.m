function pss=get_all_ps_basics(bases,tss,gnrl)
    
for i=gnrl.numcases:-1:1
    ts=tss(i); base=bases(i);
    
    %% vertical profiles
    psfile1=base.psfile_03;
    psfile2=base.psfile_34;
    if i>0; psfile3=base.psfile_45; end
    ps.zm=ncread(psfile1,'zm'); ps.nz=length(ps.zm);
    ps.zt=ncread(psfile1,'zt');
    if i>0; ps.time=[ncread(psfile1,'time');ncread(psfile2,'time');ncread(psfile3,'time')];
    else; ps.time=[ncread(psfile1,'time');ncread(psfile2,'time')]; end
    ps.zi=ts.zis(ismember(ts.times,ps.time));
    ps.zct=ts.zct(ismember(ts.times,ps.time));
    ps.zb=ts.zcb(ismember(ts.times,ps.time));
%     ps.zi=mean(ts.zis(ismember(ts.times,ts.time0+(it1:it2)*60))); %mean zi between min 30-45
%     ps.zb=mean(ts.zcb(ismember(ts.times,ts.time0+(it1:it2)*60))); %mean zb between min 30-45

    %% wind things
    if i>0
        ps.u_mean=[convert_zt_to_zm(ncread(psfile1,'u')) , convert_zt_to_zm(ncread(psfile2,'u')), convert_zt_to_zm(ncread(psfile3,'u'))];
        ps.v_mean=[ncread(psfile1,'v'), ncread(psfile2,'v'), ncread(psfile3,'v')];
    else
        ps.u_mean=[convert_zt_to_zm(ncread(psfile1,'u')) , convert_zt_to_zm(ncread(psfile2,'u'))];
        ps.v_mean=[ncread(psfile1,'v'), ncread(psfile2,'v')];
    end
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
    if i>0
    ps.qt=[convert_zt_to_zm(ncread(psfile1,'q')),convert_zt_to_zm(ncread(psfile2,'q')),convert_zt_to_zm(ncread(psfile3,'q'))];
    ps.ql=[convert_zt_to_zm(ncread(psfile1,'l')),convert_zt_to_zm(ncread(psfile2,'l')),convert_zt_to_zm(ncread(psfile3,'l'))];
    ps.rflx=[convert_zt_to_zm(ncread(psfile1,'rflx')),convert_zt_to_zm(ncread(psfile2,'rflx')),convert_zt_to_zm(ncread(psfile3,'rflx'))];
    ps.tl=[convert_zt_to_zm(ncread(psfile1,'t')),convert_zt_to_zm(ncread(psfile2,'t')),convert_zt_to_zm(ncread(psfile3,'t'))];
    ps.p=[ncread(psfile1,'p'),ncread(psfile2,'p'),ncread(psfile3,'p')];
%     ps.u=[convert_zt_to_zm(ncread(psfile1,'u')),convert_zt_to_zm(ncread(psfile2,'u'))];
    else
    ps.qt=[convert_zt_to_zm(ncread(psfile1,'q')),convert_zt_to_zm(ncread(psfile2,'q'))];
    ps.ql=[convert_zt_to_zm(ncread(psfile1,'l')),convert_zt_to_zm(ncread(psfile2,'l'))];
    ps.rflx=[convert_zt_to_zm(ncread(psfile1,'rflx')),convert_zt_to_zm(ncread(psfile2,'rflx'))];
    ps.tl=[convert_zt_to_zm(ncread(psfile1,'t')),convert_zt_to_zm(ncread(psfile2,'t'))];
    ps.p=[ncread(psfile1,'p'),ncread(psfile2,'p')];
%     ps.u=[convert_zt_to_zm(ncread(psfile1,'u')),convert_zt_to_zm(ncread(psfile2,'u'))];
    end
    
    %calculate theta v
    ps.th=ps.tl+2.5e6/1005*ps.ql/1000;
    ps.tv=ps.th.*(1+0.61.*(ps.qt-ps.ql)/1000-ps.ql/1000);
    %% 
    if i>0
        ps.tot_tw=[ncread(psfile1,'tot_tw'),ncread(psfile2,'tot_tw'),ncread(psfile3,'tot_tw')];
        ps.sfs_tw=[ncread(psfile1,'sfs_tw'),ncread(psfile2,'sfs_tw'),ncread(psfile3,'sfs_tw')];
        ps.tot_qw=[ncread(psfile1,'tot_qw'),ncread(psfile2,'tot_qw'),ncread(psfile3,'tot_qw')];
        ps.sfs_qw=[ncread(psfile1,'sfs_qw'),ncread(psfile2,'sfs_qw'),ncread(psfile3,'sfs_qw')];
        ps.uw=[ncread(psfile1,'tot_uw'),ncread(psfile2,'tot_uw'),ncread(psfile3,'tot_uw')];
        ps.vw=[ncread(psfile1,'tot_vw'),ncread(psfile2,'tot_vw'),ncread(psfile3,'tot_vw')];
        ps.sfs_uw=[ncread(psfile1,'sfs_uw'),ncread(psfile2,'sfs_uw'),ncread(psfile3,'sfs_uw')];
        ps.sfs_vw=[ncread(psfile1,'sfs_vw'),ncread(psfile2,'sfs_vw'),ncread(psfile3,'sfs_vw')];
        ps.buoy_sfs=[ncread(psfile1,'sfs_boy'),ncread(psfile2,'sfs_boy'),ncread(psfile3,'sfs_boy')];
        ps.buoy_resolved=[ncread(psfile1,'boy_prd'),ncread(psfile2,'boy_prd'),ncread(psfile3,'boy_prd')];
        ps.shear_sfs=[ncread(psfile1,'sfs_shr'),ncread(psfile2,'sfs_shr'),ncread(psfile3,'sfs_shr')];
        ps.shear_resolved=[ncread(psfile1,'shr_prd'),ncread(psfile2,'shr_prd'),ncread(psfile3,'shr_prd')];
        ps.dissipation=[ncread(psfile1,'diss'),ncread(psfile2,'diss'),ncread(psfile3,'diss')];
        ps.transport=[ncread(psfile1,'trans'),ncread(psfile2,'trans'),ncread(psfile3,'trans')];
    else
        ps.tot_tw=[ncread(psfile1,'tot_tw'),ncread(psfile2,'tot_tw')];
        ps.sfs_tw=[ncread(psfile1,'sfs_tw'),ncread(psfile2,'sfs_tw')];
        ps.tot_qw=[ncread(psfile1,'tot_qw'),ncread(psfile2,'tot_qw')];
        ps.sfs_qw=[ncread(psfile1,'sfs_qw'),ncread(psfile2,'sfs_qw')];
        ps.uw=[ncread(psfile1,'tot_uw'),ncread(psfile2,'tot_uw')];
        ps.vw=[ncread(psfile1,'tot_vw'),ncread(psfile2,'tot_vw')];
        ps.sfs_uw=[ncread(psfile1,'sfs_uw'),ncread(psfile2,'sfs_uw')];
        ps.sfs_vw=[ncread(psfile1,'sfs_vw'),ncread(psfile2,'sfs_vw')];
        ps.buoy_sfs=[ncread(psfile1,'sfs_boy'),ncread(psfile2,'sfs_boy')];
        ps.buoy_resolved=[ncread(psfile1,'boy_prd'),ncread(psfile2,'boy_prd')];
        ps.shear_sfs=[ncread(psfile1,'sfs_shr'),ncread(psfile2,'sfs_shr')];
        ps.shear_resolved=[ncread(psfile1,'shr_prd'),ncread(psfile2,'shr_prd')];
        ps.dissipation=[ncread(psfile1,'diss'),ncread(psfile2,'diss')];
        ps.transport=[ncread(psfile1,'trans'),ncread(psfile2,'trans')];
    end
    
    ps.uvw=sqrt(ps.uw.^2+ps.vw.^2); 
    ps.sfs_uvw=sqrt(ps.sfs_uw.^2+ps.sfs_vw.^2); 
    ps.uvw_alfa=atan2(ps.vw,ps.uw);
    ps.buoy_tot=ps.buoy_sfs+ps.buoy_resolved;
    ps.shear_tot=ps.shear_sfs+ps.shear_resolved;
        
    % ql variance and skewness
    if i>0
        ps.ql2=[ncread(psfile1,'l_2'),ncread(psfile2,'l_2'),ncread(psfile3,'l_2')];
        ps.ql3=[ncread(psfile1,'l_3'),ncread(psfile2,'l_3'),ncread(psfile3,'l_3')];
        ps.u2=[ncread(psfile1,'u_2'),ncread(psfile2,'u_2'),ncread(psfile3,'u_2')];
        ps.v2=[ncread(psfile1,'v_2'),ncread(psfile2,'v_2'),ncread(psfile3,'v_2')];
        ps.w2=[ncread(psfile1,'w_2'),ncread(psfile2,'w_2'),ncread(psfile3,'w_2')];
        ps.ww_sfs=[ncread(psfile1,'sfs_ww'),ncread(psfile2,'sfs_ww'),ncread(psfile3,'sfs_ww')];
    else
        ps.ql2=[ncread(psfile1,'l_2'),ncread(psfile2,'l_2')];
        ps.ql3=[ncread(psfile1,'l_3'),ncread(psfile2,'l_3')];
        ps.u2=[ncread(psfile1,'u_2'),ncread(psfile2,'u_2')];
        ps.v2=[ncread(psfile1,'v_2'),ncread(psfile2,'v_2')];
        ps.w2=[ncread(psfile1,'w_2'),ncread(psfile2,'w_2')];
        ps.ww_sfs=[ncread(psfile1,'sfs_ww'),ncread(psfile2,'sfs_ww')];
    end
    ps.uv2=sqrt(ps.u2.^2+ps.v2.^2);
    
    % mean windspeed
    ps.q_ABL=mean(ps.q_mean(20:70,:)); %in the ABL
    ps.q_FT=mean(ps.q_mean(120:130,:));
    ps.dU_top=abs(ps.q_FT-ps.q_ABL);
    ps.shearnumber=ps.dU_top./ps.q_ABL;
   
    ps.w_ent=diff(ps.zi)./diff(ps.time)+3.75e-6*ps(1).zi(2:end);
    % 10 min avg entrainment series
    if i>0
        ps.t_10min=[ps.time(2:19);(11400:600:18000)'];
        ps.we_10min=[ps.w_ent(1:18);mean(ps.w_ent(19:28));mean(ps.w_ent(29:38)); ...
        mean(ps.w_ent(39:48));mean(ps.w_ent(49:58));mean(ps.w_ent(59:68)); ...
        mean(ps.w_ent(69:78));mean(ps.w_ent(79:88));mean(ps.w_ent(89:98)); ...
        mean(ps.w_ent(99:108));mean(ps.w_ent(109:118));mean(ps.w_ent(119:128)); ...
        mean(ps.w_ent(129:138));]; 
    else
        ps.t_10min=[ps.time(2:19);(11400:600:14400)'];
        ps.we_10min=[ps.w_ent(1:18);mean(ps.w_ent(19:28));mean(ps.w_ent(29:38)); ...
        mean(ps.w_ent(39:48));mean(ps.w_ent(49:58));mean(ps.w_ent(59:68)); ...
        mean(ps.w_ent(69:78))]; 
    end
    pss(i)=ps;
end