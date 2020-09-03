function plot_isosurface(varb,var_th,xm,ym,zm,color)% isosurface using SD
% isosurface using SD

if length(var_th)==1 %constant threshold
    varp=permute(varb,[2 3 1]);
    p = patch(isosurface(xm,ym,zm,varp,var_th));
elseif length(var_th)==length(zm) %vertical profile
    
    bool=varb>repmat(var_th,[1,length(xm),length(ym)]);
    varp=permute(bool,[2 3 1]);
    p = patch(isosurface(xm,ym,zm,varp,0.5));
end

    isonormals(xm,ym,zm,varp,p)
    p.FaceColor = color;
    p.EdgeColor = 'none';
    daspect([1 1 300])
%     view(20,45)
    axis tight
    camlight
    lighting gouraud   
    xlabel('$x$ (km)','Interpreter','latex');
    ylabel('$y$ (km)','Interpreter','latex');
    zlabel('$z$ (m)','Interpreter','latex')