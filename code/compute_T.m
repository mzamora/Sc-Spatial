function [T]=compute_T(q_T,p,theta_l)
% This function uses total water mixing ratio (q_T) pressure (p) and liquid
% potential temperature (theta_l) to calculate temperature (T), and potential
% temp (Theta)
def=def_cnstnts;
T(1:size(theta_l,1),1)=0;
for n2=1:size(theta_l,1)
    til=theta_l(n2).*(p(n2)./def.p00).^def.rcp;
    xx=til;
    qs=rslf(p(n2),xx);
    zz=max(q_T(n2)-qs,0.);
    if (zz > 0)
        for iterate=1:1
            x1=def.alvl./(def.cp.*xx);
            xx1=(xx- til.*(1.+x1.*zz));
            xx2=(1+x1*til*(zz/xx+(1+qs*def.ep)*qs*def.alvl/(def.Rm*xx*xx)));
            xx=xx-xx1./xx2;
            qs=rslf(p(n2),xx);
            zz=max(q_T(n2)-qs,0.);
        end
    end
    T(n2)=xx;
end

A1=(def.p00./p(:,:));
A2=A1.^def.rcp;
Theta=T.*A2;



