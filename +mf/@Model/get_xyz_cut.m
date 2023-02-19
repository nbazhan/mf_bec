function B = get_xyz_cut(obj, A, ax)

sz = ndims(A);
nx = round(obj.grid.N.x/2);
ny = round(obj.grid.N.y/2);
nz = round(obj.grid.N.z/2);

if strcmp(ax, 'x')
    if sz == 3
        B = A(:, ny, nz);
    elseif sz == 2
        B = A(:, ny);
    end

elseif strcmp(ax, 'y')
    if sz == 3
        B = A(nx, :, nz);
    elseif sz == 2
        B = A(nx, :);
    end

elseif strcmp(ax, 'z')
    if sz == 3
        B = squeeze(A(nx, ny, :)).';
    elseif sz == 2
        error('Function get_xyz_cut(A, z) fails. Matrix A does not have z dimension')
    end

elseif strcmp(ax, 'xy')
    if sz == 3
        B = A(:, :, nz);
    elseif sz == 2
        B = A;
    end

elseif strcmp(ax, 'xz')
    if sz == 3
        B = squeeze(A(:, ny, :));
    elseif sz == 2
        B = A;
    end

elseif strcmp(ax, 'yz')
    if sz == 3
        B = squeeze(A(nx, :, :));
    elseif sz == 2
        B = A;
    end
end
