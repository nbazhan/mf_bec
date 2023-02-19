function [resp,resm] = detect_core(psi,rx,ry)
% Detect vortex cores on a 2D slice of the wave function
% IN:
%   - phi: 2D array of complex numbers (slice of the wave function)
%   - rx, ry: grid of coordinate ponts in x and y 
% OUT:
%   - resp, resm: 2D arrays, each row  represents one detected vortex and contain [x,y] of the core. 
%                 resp (resm) contains only positive (negative) charged vortices
[n, m] = size(psi);
ns = 1;
dx = rx(2) - rx(1);
dy = ry(2) - ry(1);
[XX, YY] = meshgrid(rx, ry);
an = angle(psi);
%ddphi = abs(del2(abs(psi).^2,dx,dy));
idx = ns.*[0 0; 1 0; 1 1; 0 1];
nshift = size(idx,1);
angs = zeros(n,m,nshift,'like',XX);
for i=1:nshift
  angs(:,:,i) = circshift(an,idx(i,:));
end
dif = angs - circshift(angs,[0 0 1]);
res1 = (sum(dif>pi,3)-sum(dif<-pi,3));%.*(ddphi>0.00000001);
res = res1 > 0;
resp = [XX(res)-ns*dx/2 YY(res)-ns*dy/2];
res = res1 < 0;
resm = [XX(res)-ns*dx/2 YY(res)-ns*dy/2];