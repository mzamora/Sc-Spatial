function plot_slices_in_ABL(varb,var_th,zm)

if length(var_th)==1 %constant threshold
    iplot=1; figure;
    for izplot=[20 40 60 80]
        svxy=squeeze(varb(izplot,:,:)); 
        subplot(2,2,iplot); 
        imagesc(svxy>var_th)
        title(['z=',num2str(zm(izplot)),' m'])
        iplot=iplot+1;
    end
elseif length(var_th)==length(zm) % vertical profile
    iplot=1; figure;
    for izplot=[20 40 60 80]
        svxy=squeeze(varb(izplot,:,:)); 
        subplot(2,2,iplot); 
        imagesc(svxy>var_th(izplot))
        title(['z=',num2str(zm(izplot)),' m'])
        iplot=iplot+1;
    end
end
    