function res = detect_core_3d(Psi, X, Y, Z)
% Detect vortex cores on a 3D wave function
% IN:
%   - phi: 3D array of complex numbers
%   - X, Y, Z: grid of coordinate ponts in x, y, z 
% OUT:
%   - resp, resm: 2D arrays, each row  represents one detected vortex and contain [x,y] of the core. 
%                 resp (resm) contains only positive (negative) charged vortices

dX = X(2, 1, 1)- X(1, 1, 1);
dY = Y(1, 2, 1)- Y(1, 1, 1);
dZ = Z(1, 1, 2)- Z(1, 1, 1);

densityFilter = (abs(Psi).^2 > 0.01*max(abs(Psi(:)).^2));%.*(sqrt(X.^2 ));
ang = angle(Psi);

% looking for vortices along each countor (idx)
idx(:, :, 1) = [0 1 0; 1 1 0; 1 0 0; 0 0 0;]; % 2-3-4-1: z
idx(:, :, 2) = [0 0 1; 1 0 1; 1 0 0; 0 0 0;]; % 5-8-4-1: x
idx(:, :, 3) = [0 1 0; 0 1 1; 0 0 1; 0 0 0;]; % 2-6-5-1: y
idx(:, :, 4) = [0 1 0; 1 1 1; 1 0 1; 0 0 0;]; % 2-7-8-1
idx(:, :, 5) = [1 0 0; 0 0 1; 0 1 1; 1 1 0;]; % 4-5-6-3
idx(:, :, 6) = [0 1 1; 1 1 1; 1 0 0; 0 0 0;]; % 6-7-4-1
idx(:, :, 7) = [0 1 0; 0 0 1; 1 0 1; 1 1 0;]; % 2-5-8-3
idx(:, :, 8) = [1 1 0; 1 1 1; 0 0 1; 0 0 0;]; % 3-7-5-1
idx(:, :, 9) = [1 0 0; 1 0 1; 0 1 1; 0 1 0;]; % 4-8-6-2

[nx, ny, nz] = size(ang);
ni = size(idx, 1);

angs = zeros(nx, ny, nz, ni, 'like', X);
resp = [];
resm = [];

for ii = size(idx, 3) : -1 : 1
    for jj = 1 : ni
        angs(:, :, :, jj) = circshift(ang, idx(jj, :, ii));
    end
    dif = angs - circshift(angs,[0 0 0 1]);
    
    % count phase slips along the countor
    res = (sum(dif > pi, 4) - sum(dif < - pi, 4)).*densityFilter;
    
    corp = [X(res > 0)+dX/2 Y(res > 0)+dY/2 Z(res > 0)+dZ/2];
    corm = [X(res < 0)+dX/2 Y(res < 0)+dY/2 Z(res < 0)+dZ/2];

    % -1 - blue color, 1 - red color, 0 - black
    if ii == 1
        % concat 1, -1 for vertical vortices
        corp = cat(2, corp, repmat(-1, size(corp, 1), 1));
        corm = cat(2, corm, ones(size(corm, 1), 1));
    else
        % concat 0 for horizontal vortices
        corp = cat(2, corp, zeros(size(corp, 1), 1));
        corm = cat(2, corm, zeros(size(corm, 1), 1));
    end
    
    resp = cat(1, resp, corp);
    resm = cat(1, resm, corm);

    res = cat(1, resm, resp);
end