function [iz,ix,iy]=pixels_3x_to_1x(Pixels,nz,nx,ny)
%LTpixels in 3x matrix
[iz,ix,iy]=ind2sub([nz,3*nx,3*ny],Pixels);
%% periodic: get pixels beyond the right side
ix(ix>2*nx)=ix(ix>2*nx)-nx;
ix(ix<nx+1)=ix(ix<nx+1)+nx;
iy(iy>2*nx)=iy(iy>2*nx)-ny;
iy(iy<ny+1)=iy(iy<ny+1)+ny;

%% all to 1st corner
ix=ix-nx; %now it goes from 1 to nx
iy=iy-ny; 
