function plot_wanom_contour(u,v,w,iiz)
xm=-6.965:0.035:7;
uxy=squeeze(u(iiz,:,:)); vxy=squeeze(v(iiz,:,:));
meanu=mean(uxy,'all'); meanv=mean(vxy,'all');
wxy=squeeze(w(iiz,:,:)); wanom=wxy-mean(wxy,'all');
    
contourf(xm,xm,wanom','LineStyle','none'); caxis([-1.5 1.5]); colormap('bone'); hold on
quiver(0,0,meanu,meanv,1,'Color','yellow','LineWidth',3)
c=colorbar; ylabel(c,'$w''(x,y)$ [m/s]','Interpreter','latex');

end