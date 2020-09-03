function ccout=binarize_periodic_3d(field,threshold)
% sdxy is the standard deviation of the field at the current slice, useed
% as the third threshold here. 

nz=size(field,1); nx=size(field,2); ny=size(field,3); %uclales style 
% we assume the field it's already blurred
    
if length(threshold)~=nz %constant threshold(s)
    %% normalize
    thrsh=threshold/(max(field,[],'all'));
    field=field/(max(field,[],'all'));

    %% extend canvas to fix periodicity
    IP3=false(nz,3*nx,3*ny); %new bigger canvas
    ixs=1+nx:2*nx; iys=1+ny:2*ny;%indices to copy old canvas

    %% binarize for given and normalized threshold
    TP=thrsh;

    %%
    for ith=length(TP):-1:1 %thresholds
        %% binarize as is
%         IP=imbinarize(P,TP(ith)); %imshow(IP(:,:,ith))

        %% binarize in 3x canvas
        IP3(:,ixs,iys)=field>TP(ith); %copying old data into the center
        I3=bwareaopen(IP3,25); %take out cores with less than 25 pixels
%         imshow(squeeze(I3(81,:,:)))

        %% detect all objects
        cc=bwconncomp(I3,26); %detect objects with connectivity 8
        if cc.NumObjects==0
            ccout(ith)=cc;
            continue
        end

        %% periodic: get objects touching the right side
        sides.right.exist=zeros(1,cc.NumObjects); %to id objs touching
        for iobj=1:cc.NumObjects %going though detected objects
            points=cc.PixelIdxList{iobj}; %get points that belong
            [~,points_x,~]=ind2sub(size(IP3),points); %arrange them in z,x,y fashion
            if sum(points_x==2*nx)>0 %there are points touching the right boundary
                sides.right.exist(iobj)=1; %we id this object
            end
        end

        %% periodic: move all objects touching the right to the left 
        ccMerged=cc;
        for iright=find(sides.right.exist) %the ones touching the right
            [right_z,right_x,right_y]=ind2sub(size(IP3),ccMerged.PixelIdxList{iright}); %get their x,y points
            right_x=right_x-nx; %move right to the left
            right_moved=sub2ind(size(IP3),right_z,right_x,right_y); %idx points
            ccMerged.PixelIdxList{iright}=right_moved; %moved points
        end

        %% periodic: get objects touching the top side
        sides.top.exist=zeros(1,cc.NumObjects); 
        for iobj=1:cc.NumObjects
            points=cc.PixelIdxList{iobj};
            [~,~,points_y]=ind2sub(size(IP3),points);
            if sum(points_y==2*ny)>0
                sides.top.exist(iobj)=1;
            end
        end

        %% periodic: move objects touching the top to the bottom
        for itop=find(sides.top.exist)
            [top_z,top_x,top_y]=ind2sub(size(IP3),ccMerged.PixelIdxList{itop});
            top_y=top_y-nx; %move top to the bottom
            top_moved=sub2ind(size(IP3),top_z,top_x,top_y); %idx points
            ccMerged.PixelIdxList{itop}=top_moved; %moved points
        end
        
        %% re-obtain objects
        ccout(ith)=bwconncomp(labelmatrix(ccMerged)>0);
        % imshow(label2rgb(labelmatrix(cc2),'jet','w','shuffle')) % check plot
    end
    
else % vertical profile of thresholds
    %% extend canvas to fix periodicity
    IP3=false(nz,3*nx,3*ny); %new bigger canvas
    ixs=1+nx:2*nx; iys=1+ny:2*ny;%indices to copy old canvas

    %% binarize in 3x canvas
    field_01=0*field;
    for iz=1:nz
        field_01(iz,:,:)=field(iz,:,:)>threshold(iz);
    end
    IP3(:,ixs,iys)=field_01; %copying old data into the center
%     I3=bwareaopen(IP3,25); %take out cores with less than 25 pixels

    %% detect all objects
    cc=bwconncomp(IP3,26); %detect objects with connectivity 8
    if cc.NumObjects==0
        ccout=cc;
        return
    end

    %% periodic: get objects touching the right side
    sides.right.exist=zeros(1,cc.NumObjects); %to id objs touching
    for iobj=1:cc.NumObjects %going though detected objects
        points=cc.PixelIdxList{iobj}; %get points that belong
        [~,points_x,~]=ind2sub(size(IP3),points); %arrange them in z,x,y fashion
        if sum(points_x==2*nx)>0 %there are points touching the right boundary
            sides.right.exist(iobj)=1; %we id this object
        end
    end

    %% periodic: move all objects touching the right to the left 
    ccMerged=cc;
    for iright=find(sides.right.exist) %the ones touching the right
        [right_z,right_x,right_y]=ind2sub(size(IP3),ccMerged.PixelIdxList{iright}); %get their x,y points
        right_x=right_x-nx; %move right to the left
        right_moved=sub2ind(size(IP3),right_z,right_x,right_y); %idx points
        ccMerged.PixelIdxList{iright}=right_moved; %moved points
    end

    %% periodic: get objects touching the top side
    sides.top.exist=zeros(1,cc.NumObjects); 
    for iobj=1:cc.NumObjects
        points=cc.PixelIdxList{iobj};
        [~,~,points_y]=ind2sub(size(IP3),points);
        if sum(points_y==2*ny)>0
            sides.top.exist(iobj)=1;
        end
    end

    %% periodic: move objects touching the top to the bottom
    for itop=find(sides.top.exist)
        [top_z,top_x,top_y]=ind2sub(size(IP3),ccMerged.PixelIdxList{itop});
        top_y=top_y-nx; %move top to the bottom
        top_moved=sub2ind(size(IP3),top_z,top_x,top_y); %idx points
        ccMerged.PixelIdxList{itop}=top_moved; %moved points
    end

    %% re-obtain objects
    ccout=bwconncomp(labelmatrix(ccMerged)>0);
%     imshow(label2rgb(labelmatrix(ccout,'jet','w','shuffle')) % check plot
end %if    
               
end %function