function res = detect_core_2d(Psi, X, Y)
% Detect vortex cores on a 3D wave function
% IN:
%   - phi: 3D array of complex numbers
%   - X, Y, Z: grid of coordinate ponts in x, y, z 
% OUT:
%   - resp, resm: 2D arrays, each row  represents one detected vortex and contain [x,y] of the core. 
%                 resp (resm) contains only positive (negative) charged vortices

dX = X(2, 1, 1)- X(1, 1, 1);
dY = Y(1, 2, 1)- Y(1, 1, 1);

densityFilter = (abs(Psi).^2 > 0.01*max(abs(Psi(:))).^2);%.*(sqrt(X.^2));
ang = angle(Psi);

% looking for vortices along each countor (idx)
idx = [0 0; 
       1 0; 
       1 1; 
       0 1];

[nx, ny] = size(ang);
ni = size(idx, 1);

angs = zeros(nx, ny, ni, 'like', X);
for i=1:ni
  angs(:,:,i) = circshift(ang, idx(i,:));
end

dif = angs - circshift(angs,[0 0 1]);
res = (sum(dif > pi, 3)-sum(dif < -pi, 3)).*densityFilter;%.*(ddphi>0.00000001);

resp = [X(res > 0)+dX/2 Y(res > 0)+dY/2 ones(size(X(res > 0)))];
resm = [X(res < 0)+dX/2 Y(res < 0)+dY/2 -ones(size(X(res < 0)))];
res = cat(1, resp, resm);

end