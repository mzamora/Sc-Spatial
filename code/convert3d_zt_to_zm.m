function varzm=convert3d_zt_to_zm(varzt)
% transform 3dvariables that are related to the zt vertical grid in uclales

varzm=varzt;
%for each time
for it=1:size(varzt,4)
    %we go level by level in z
    for iz=1:size(varzt,1)-1
        %and average levels up and down 
        varzm(iz,:,:,it)=0.5*(varzt(iz,:,:,it)+varzt(iz+1,:,:,it));
    end
    %last points as before. usually not valuable info

end