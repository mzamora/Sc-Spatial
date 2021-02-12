function tss=get_all_ts_basics(bases,gnrl)

for i=gnrl.numcases:-1:1
    base=bases(i);

    if i<1 %sfc wind cases
        %% time series
        tsfile1=base.tsfile_03;
        tsfile2=base.tsfile_34;
        ts.CF=[ncread(tsfile1,'cfrac');ncread(tsfile2,'cfrac')];
        ts.vtke=[ncread(tsfile1,'tkeint');ncread(tsfile2,'tkeint')];
        ts.times=[ncread(tsfile1,'time');ncread(tsfile2,'time')];
        ts.nt=length(ts.times);
        ts.dt=ts.times(2)-ts.times(1);
        ts.time0=ts.times(1);

        ts.zct=[ncread(tsfile1,'zcmn');ncread(tsfile2,'zcmn')];
        ts.zcb=[ncread(tsfile1,'zbmn');ncread(tsfile2,'zbmn')];
        ts.zis=[ncread(tsfile1,'zi1_bar');ncread(tsfile2,'zi1_bar')];
        ts.lwp=[ncread(tsfile1,'lwp_bar');ncread(tsfile2,'lwp_bar')];
        ts.lwpv=[ncread(tsfile1,'lwp_var');ncread(tsfile2,'lwp_var')];
        tss(i)=ts;
    else %top wind shear cases
          %% time series
        tsfile1=base.tsfile_03;
        tsfile2=base.tsfile_34;
        tsfile3=base.tsfile_45;
        ts.CF=[ncread(tsfile1,'cfrac');ncread(tsfile2,'cfrac');ncread(tsfile3,'cfrac')];
        ts.vtke=[ncread(tsfile1,'tkeint');ncread(tsfile2,'tkeint');ncread(tsfile3,'tkeint')];
        ts.times=[ncread(tsfile1,'time');ncread(tsfile2,'time');ncread(tsfile3,'time')];
        ts.nt=length(ts.times);
        ts.dt=ts.times(2)-ts.times(1);
        ts.time0=ts.times(1);

        ts.zct=[ncread(tsfile1,'zcmn');ncread(tsfile2,'zcmn');ncread(tsfile3,'zcmn')];
        ts.zcb=[ncread(tsfile1,'zbmn');ncread(tsfile2,'zbmn');ncread(tsfile3,'zbmn')];
        ts.zis=[ncread(tsfile1,'zi1_bar');ncread(tsfile2,'zi1_bar');ncread(tsfile3,'zi1_bar')];
        ts.lwp=[ncread(tsfile1,'lwp_bar');ncread(tsfile2,'lwp_bar');ncread(tsfile3,'lwp_bar')];
        ts.lwpv=[ncread(tsfile1,'lwp_var');ncread(tsfile2,'lwp_var');ncread(tsfile3,'lwp_var')];
        ts.shf=[ncread(tsfile1,'shf_bar');ncread(tsfile2,'shf_bar');ncread(tsfile3,'shf_bar')];
        ts.lhf=[ncread(tsfile1,'lhf_bar');ncread(tsfile2,'lhf_bar');ncread(tsfile3,'lhf_bar')];
        
        tss(i)=ts;
    end

end
end
