function varzm=convert_zt_to_zm(varzt)
% transform variables that are related to the zt vertical grid in uclales

varzm=varzt;
for it=1:size(varzt,2) %in case the variable has both z and t
    for iz=1:size(varzt,1)-1
        varzm(iz,it)=0.5*(varzt(iz,it)+varzt(iz+1,it));
    end
end
%last point as before. usually not valuable info

end