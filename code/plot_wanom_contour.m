function plot_wanom_contour(u,v,w,iiz)

uxy=squeeze(u(iiz,:,:)); vxy=squeeze(v(iiz,:,:));
meanu=mean(uxy,'all'); meanv=mean(vxy,'all');
wxy=squeeze(w(iiz,:,:)); wanom=wxy-mean(wxy,'all');

contourf(wanom','LineStyle','none'); caxis([-1.5 1.5]); colormap('bone'); hold on
quiver(200,200,meanu,meanv,25,'Color','yellow','LineWidth',3)
c=colorbar; ylabel(c,'$w''(x,y)$ [m/s]','Interpreter','latex');

end