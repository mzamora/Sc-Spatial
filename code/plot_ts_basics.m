function ts=plot_ts_basics(base)
    mycol=base.color;
    mystyle=base.style;

    %% time series
    tsfile1=base.tsfile_03;
    tsfile2=base.tsfile_34;
    ts.CF=[ncread(tsfile1,'cfrac');ncread(tsfile2,'cfrac')];
    ts.vtke=[ncread(tsfile1,'vtke');ncread(tsfile2,'vtke')];
    ts.times=[ncread(tsfile1,'time');ncread(tsfile2,'time')];
    ts.nt=length(ts.times);
    ts.dt=ts.times(2)-ts.times(1);
    ts.time0=ts.times(1);
   
    ts.zct=[ncread(tsfile1,'zcmn');ncread(tsfile2,'zcmn')];
    ts.zcb=[ncread(tsfile1,'zbmn');ncread(tsfile2,'zbmn')];
    ts.zis=[ncread(tsfile1,'zi1_bar');ncread(tsfile2,'zi1_bar')];
    ts.lwp=[ncread(tsfile1,'lwp_bar');ncread(tsfile2,'lwp_bar')];
    ts.lwpv=[ncread(tsfile1,'lwp_var');ncread(tsfile2,'lwp_var')];
        
    subplot(2,2,1); plot(ts.times/3600,ts.CF,mystyle,'Color',mycol); xlabel('Time [h]'); ylabel('Cloud fraction'); hold on
    subplot(2,2,2); plot(ts.times/3600,ts.vtke,mystyle,'Color',mycol); xlabel('Time [h]'); ylabel('TKE_{BL} [kg/s]'); hold on
    subplot(2,2,3); plot(ts.times/3600,ts.zct,mystyle,'Color',mycol); hold on
    plot(ts.times/3600,ts.zcb,mystyle,'Color',mycol);
    xlabel('Time [h]'); ylabel('Cloud boundaries'); hold on
    subplot(2,2,4); plot(ts.times/3600,ts.lwp,mystyle,'Color',mycol); xlabel('Time [h]'); ylabel('LWP [g/m^2]'); hold on

end
