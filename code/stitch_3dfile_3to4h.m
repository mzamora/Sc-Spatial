function stitch_3dfile_3to4h(dir0,casename,nx,ny,nz,npxs,npys,ps)
% saves at each time step for an hour (3 to 4hr files)

%% initialize vars
    nxi=nx/npxs; nyi=ny/npys;
    xt=zeros(nx,1); xm=xt;
    yt=zeros(nx,1); ym=yt;
    file3d=[dir0,casename,'.00000000.nc'];
    zt=ncread(file3d,'zt'); zm=ncread(file3d,'zm');
    times=ncread(file3d,'time'); nt=length(times);
for it=1:nt
        time=times(it); %current time stamp
        u=zeros(nz,nx,ny);
        v=zeros(nz,nx,ny);
        w=zeros(nz,nx,ny);
        tl=zeros(nz,nx,ny);
        p=zeros(nz,nx,ny);
        qt=zeros(nz,nx,ny);
        ql=zeros(nz,nx,ny);
        lw=zeros(nz,nx,ny);
        
        %% loop through
        for npx=1:npxs
            file3d=[dir0,casename,'.',num2str(npx-1,'%04i'),'0000.nc'];
            xs=((1+(npx-1)*nxi):(npx*nxi))';
            xt(xs)=ncread(file3d,'xt');
            xm(xs)=ncread(file3d,'xm');
            
            for npy=1:npys
                file3d=[dir0,casename,'.',num2str(npx-1,'%04i'),num2str(npy-1,'%04i'),'.nc'];
                ys=(1+(npy-1)*nyi):(npy*nyi);
                yt(ys)=ncread(file3d,'yt');
                ym(ys)=ncread(file3d,'ym');
                
                u(:,xs,ys)=ncread(file3d,'u',[1 1 1 it],[nz nxi nyi 1]);
                v(:,xs,ys)=ncread(file3d,'v',[1 1 1 it],[nz nxi nyi 1]);
                w(:,xs,ys)=ncread(file3d,'w',[1 1 1 it],[nz nxi nyi 1]);
                p(:,xs,ys)=ncread(file3d,'p',[1 1 1 it],[nz nxi nyi 1]);
                tl(:,xs,ys)=ncread(file3d,'t',[1 1 1 it],[nz nxi nyi 1]);
                qt(:,xs,ys)=ncread(file3d,'q',[1 1 1 it],[nz nxi nyi 1]);
                ql(:,xs,ys)=ncread(file3d,'l',[1 1 1 it],[nz nxi nyi 1]);
                lw(:,xs,ys)=ncread(file3d,'rflx',[1 1 1 it],[nz nxi nyi 1]);
            end
        end
   
    % convert what's needed to zm
    u=convert3d_zt_to_zm(u);
    v=convert3d_zt_to_zm(v);
    tl=convert3d_zt_to_zm(tl);
    ql=convert3d_zt_to_zm(ql);
    qt=convert3d_zt_to_zm(qt);
    
    th=tl+2.5e6/1005*ql;
    tv=th.*(1+0.61.*(qt-ql)-ql);

    %% compute LWP
   LWP=zeros(nx,ny); cbh=LWP; cth=LWP; z_maxtlgrad=LWP;
   for ix=1:nx
       for iy=1:ny
           LWP(ix,iy)=trapz(ps.zm,ps.dn0.*ql(:,ix,iy))*1000;
           if LWP(ix,iy)==0 %clear column
                cbh(ix,iy)=nan; %no cloud base/top heights
                cth(ix,iy)=nan;
            else
                cbh(ix,iy)=ps.zm(find(ql(:,ix,iy)>0,1)); %cloud base height: first point with ql>0
                cth(ix,iy)=ps.zm(find(ql(:,ix,iy)>0,1,'last')); %cloud top height: last point with ql>0
            end
            [~,i_maxtlgrad]=max(diff(tl(:,ix,iy))./diff(ps.zm));
            z_maxtlgrad(ix,iy)=0.5*(ps.zm(i_maxtlgrad)+ps.zm(i_maxtlgrad+1)); %mid point at max gradient segment
        end
    end
    
    %% save matlab 3D files

    save([dir0,casename,'_u_',num2str(it,'%02i')],'u','-v7.3')
    fprintf(['u saved ',num2str(it,'%02i'),'\n'])
    save([dir0,casename,'_v_',num2str(it,'%02i')],'v','-v7.3')
    fprintf(['v saved ',num2str(it,'%02i'),'\n'])
    save([dir0,casename,'_w_',num2str(it,'%02i')],'w','-v7.3')
    fprintf(['w saved ',num2str(it,'%02i'),'\n'])
    save([dir0,casename,'_tl_',num2str(it,'%02i')],'tl','-v7.3')
    fprintf(['tl saved ',num2str(it,'%02i'),'\n'])
    save([dir0,casename,'_tv_',num2str(it,'%02i')],'tv','-v7.3')
    fprintf(['tv saved ',num2str(it,'%02i'),'\n'])
    save([dir0,casename,'_qt_',num2str(it,'%02i')],'qt','-v7.3')
    fprintf(['qt saved ',num2str(it,'%02i'),'\n'])
    save([dir0,casename,'_ql_',num2str(it,'%02i')],'ql','-v7.3')
    fprintf(['ql saved',num2str(it,'%02i'),' \n'])
    save([dir0,casename,'_LWP_',num2str(it,'%02i')],'LWP','-v7.3')
    fprintf(['LWP saved',num2str(it,'%02i'),' \n'])

    
end %time loop

save([dir0,casename,'_times'],'times','-v7.3')
save([dir0,casename,'_zm'],'zm','-v7.3')     
end
