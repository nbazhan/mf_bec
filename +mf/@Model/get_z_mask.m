function mask_i = get_z_mask(obj, i, varargin)
% returns Psi with only 1 ring Vts(i)

if any(strcmp(varargin, 'nt'))
    grid = obj.grid_nt;
else
    grid = obj.grid;
end

mask_i = ones(size(grid.Z));

if isfield(obj.Vs, 'toroidal') &&  obj.D == 3 

    zs = zeros([1 size(obj.Vs.toroidal, 2)]);
    for j = 1 : size(obj.Vs.toroidal, 2)
        zs(j) = obj.Vs.toroidal(j).c.z;
    end
    zs = unique(zs);
    

    if size(zs, 2) > 1 && i <= size(zs, 2)
        delta = 0.4;
        zi = obj.Vs.toroidal(i).c.z;
        if i > 1
            z_top = zi + delta*abs(zi - obj.Vs.toroidal(i - 1).c.z);
            mask_i = mask_i.*(grid.Z < z_top);
        end
    
        if i < size(zs, 2)
            z_bot = zi - delta*abs(zi - obj.Vs.toroidal(i + 1).c.z);
            mask_i = mask_i.*(grid.Z > z_bot);
        end
    end
end
end