function B = get_xyz_sum(obj, A, ax)

sz = ndims(A);

if strcmp(ax, 'x')
    B = sum(A, [2, 3]);

elseif strcmp(ax, 'y')
    B = sum(A, [1, 3]);

elseif strcmp(ax, 'z')
    if sz == 3
        B = squeeze(sum(A, [1, 2])).';
    else
        error('Function get_xyz_sum(A, z) fails. Matrix A does not have z dimension')
    end

elseif strcmp(ax, 'xy')
    if sz == 3
        B = sum(A, 3);
    else
        B = A;
    end

elseif strcmp(ax, 'xz')
    if sz == 3
        B = squeeze(sum(A, 2));
    else
        error('Function get_xyz_sum(A, xz) fails. Matrix A does not have z dimension')
    end

elseif strcmp(ax, 'yz')
    if sz == 3
        B = squeeze(sum(A, 1));
    else
        error('Function get_xyz_sum(A, yz) fails. Matrix A does not have z dimension')
    end
end
