function [base,gnrl]=setup_reading_LES(server)

%% setup
if server
    LESdir1='~/mzz_482b/sfcwind/'; %server
    LESdir2='~/mzz_482b/topwind/';
    outdir='../out/';
else
    LESdir='../in/LESoutput/';
    outdir='../out/sfcwind';
end

cases={'CTRL_14km_zrough_nudge','075U_14km_zrough_nudge','050U_14km_zrough_nudge','025U_14km_zrough_nudge', '000U_14km_zrough_nudge', ...
    'CTRL_14km_zrough_DU05','CTRL_14km_zrough_DU10', ...
    '050U_14km_zrough_DU05','050U_14km_zrough_DU10', ...
    '000U_14km_zrough_DU05','000U_14km_zrough_DU10'    };
gnrl.mylgd={'CTRL','075U','050U','025U','000U','CTRL-S5','CTRL-S10','050U-S5','050U-S10','000U-S5','000U-S10'};
gnrl.bcklgd=flip(gnrl.mylgd);

standardcase='rf01';
numcases=length(cases); gnrl.numcases=numcases;
nxs=396*ones(1,numcases); %set manually here
nzs=131*ones(1,numcases);

%datafolder='../../uclales_output/dycoms_rf01/grid_sens/'; % in the panthers
styles={'-','-','-','-','-','--','-.','--','-.','--','-.'}; %styles=styles(1:numcases);

cols=linspace(1,0,5); cols=[cols',1-cols',1-cols']; %5 cases
% cols=[cols(1,:);cols(1,:);cols;cols(end,:);cols(end,:)]; % plus the 6 extra in the CTRL and 000U
cols=[cols;cols(1,:);cols(1,:);cols(3,:);cols(3,:);cols(end,:);cols(end,:)]; %with top shear cases
gnrl.cols=cols;
if ~isfolder(outdir)
    mkdir(outdir)
end

%% basic setup
if server
    for ii=numcases:-1:1 %backwards preallocates structures... pretty nice trick
        if ii<6
            base(ii).name=[LESdir1,cases{ii},'/',standardcase]; 
            base(ii).datafolder=LESdir1;
        else
            base(ii).name=[LESdir2,cases{ii},'/',standardcase]; 
            base(ii).datafolder=LESdir2;
        end
        base(ii).nx=nxs(ii); base(ii).nz=nzs(ii); base(ii).outfile=[outdir,cases{ii}];
        base(ii).style=styles{ii}; base(ii).color=cols(ii,:); base(ii).casename=cases{ii};
        base(ii).tsfile_03=[base(ii).name,'.ts.nc'];
        base(ii).tsfile_34=strrep(base(ii).tsfile_03,'rf01','hr3_4/rf01');
        base(ii).psfile_03=[base(ii).name,'.ps.nc'];
        base(ii).psfile_34=strrep(base(ii).psfile_03,'rf01','hr3_4/rf01');
        base(ii).tsfile_45=strrep(base(ii).tsfile_03,'rf01','hr4_5/rf01');
        base(ii).psfile_45=strrep(base(ii).psfile_03,'rf01','hr4_5/rf01');
    end
else
    for ii=numcases:-1:1 %backwards preallocates structures... pretty nice trick
        base(ii).name=[LESdir,cases{ii},'/',standardcase]; 
        base(ii).nx=nxs(ii); base(ii).nz=nzs(ii); base(ii).outfile=[outdir,cases{ii}];
        base(ii).style=styles{ii}; base(ii).color=cols(ii,:); base(ii).casename=cases{ii};
        base(ii).datafolder=LESdir;
        base(ii).tsfile_03=[base(ii).name,'.ts.nc'];
        base(ii).tsfile_34=strrep(base(ii).tsfile_03,'rf01','hr3_4/rf01');
        base(ii).psfile_03=[base(ii).name,'.ps.nc'];
        base(ii).psfile_34=strrep(base(ii).psfile_03,'rf01','hr3_4/rf01');
        base(ii).tsfile_45=strrep(base(ii).tsfile_03,'rf01','hr4_5/rf01');
        base(ii).psfile_45=strrep(base(ii).psfile_03,'rf01','hr4_5/rf01');
    end
end
