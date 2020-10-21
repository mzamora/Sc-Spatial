
% initial values od DU and DTV
for ii=11:-1:1
DTV(ii)=sum(diff(ps(ii).tv(87:89,1)));
DU(ii)=sum(diff(ps(ii).q_mean(87:89,1)));
end

% theoretical minimum wavelength for wave growth (in m)
lambda_KH=pi*DU.^2*289/9.81./DTV

%% other stuff
db=DTV(1)*9.81/289
hS_S1=5^2/3/db
hS_S2=10^2/3/db