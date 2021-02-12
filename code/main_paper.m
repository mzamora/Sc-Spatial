%% Post processing
%stitchdata

%% Necessary processing
clearvars
server=false; %1 if running on a server, 0 on my laptop
[base,gnrl]=setup_reading_LES(server);
ts=get_all_ts_basics(base,gnrl);
ps=get_all_ps_basics(base,ts,gnrl);
ps3d=get_all_ps3d_basics(base,ts,ps,gnrl);
load('../in/LESoutput/075U_14km_zrough_nudge/hr3_4/rf01_xm.mat')
load('../in/LESoutput/075U_14km_zrough_nudge/hr3_4/rf01_ym.mat')

%% process 3D structures (preferred to do semi manually, to supervise results)
% edit get_3Dstructures.m %main program to get the updraft, downdraft objects
% Supplementary figures were also made manually inside that function

% skip the run and just load the results at hour 4:
time=60;
load(['../out/objects_time_jan',num2str(time)]) %january 2021 review
% load(['../out/objects_time_',num2str(time)],'obj_ql','obj_ud')
%% Fig.2  spin-up & time evolution
edit fig_timeevolution.m

%% Fig.3 thermodynamic profiles at hour 0345-0400
edit fig_thermodynprofiles.m

%% Fig.4 turbulent fluxes at hour 0345-0400
edit fig_turbfluxes.m

%% Fig.5 and 6 spatial snapshots
% edit fig_spatialsnapshot.m %slices in xy planes (older version)
% edit fig_verticalslice.m % older version
edit fig_spatialslices.m

%% Fig 7 roll factor (included in January 2021 review)
edit get_rollfactor.m % get the roll factor to show that rolls are more prevalent for some cases

%% Fig. 8 Spatial ztop
% edit fig_spatialcloudtopandbase.m %older version
edit fig_spatial_ztop.m
edit support_ztop_interpretation.m

%% Fig. 9 3D view of I and II objects
edit plot_3dstructuresIandII.m %fig with 3d objects

%% Fig. 10 UDDD objects by class
edit plot_objects_by_category.m % plot the UD DD structures I to VI

%% Fig. 11 
edit plot_objectsvolumefraction.m
%edit plot_objectorientation.m %plot the distribution of objects orientations per case

%% Fig. 12 in jan 2021 review
edit plot_turbflux_contributions_v2.m % turb flux contributions per object type

%% Other
% edit plot_objects_cloudcores_qlw.m %plot cloud cores (ql>0,w>0) in z/dz
% REMOVED in review
% edit plot_objects_cloudcores.m %plot cloud cores (q'>avg ql) in z/dz

%% Fig. 13
% REMOVED
% edit get_match_cloudyxobjects.m

%% For Table 2 and Fig 13 (summary in surface/top shear space)
edit nondimensionalnumbers.m

%% top shear things
edit get_theorericalwavelength
edit get_richardson

%% other things
edit make_finergrid %refine the grid for an extra check up case
edit fig_tkebudget.m % plot tke budget components
edit fig_windspeedprofiles.m
edit get_spatialautocorrelation.m % and plot it like salesky (polar coords)

