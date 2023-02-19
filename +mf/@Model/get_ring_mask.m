function mask_i = get_ring_mask(obj, i, t, varargin)
% returns Psi with only 1 ring Vts(i)

if any(strcmp(varargin, 'nt'))
    var_nt = 'nt';
    grid = obj.grid_nt;
else
    var_nt = '';
    grid = obj.grid;
end

if obj.D > 1
    delta = 0.5;
    if i <= length(obj.Vs.toroidal)
        %r = sqrt((grid.X - obj.Vs.toroidal(i).get_rc(t).x).^2 + ...
        %         (grid.Y - obj.Vs.toroidal(i).get_rc(t).y).^2);
        r = sqrt((grid.X).^2 + ...
                 (grid.Y).^2);
        mask_i = ones(size(r));
    
        ri = obj.Vs.toroidal(i).get_r(t, var_nt);
        r_lim_bot = 0;
        r_lim_top = max(grid.L.x, grid.L.y);
        
        if obj.D == 2
            if i > 1
                r_lim_bot = delta*(ri + obj.Vs.toroidal(i - 1).get_r(t, var_nt));
            end
        
            if i < length(obj.Vs.toroidal)
                r_lim_top =  delta*(ri + obj.Vs.toroidal(i + 1).get_r(t, var_nt));
            end
    
        elseif obj.D == 3
            zi = obj.Vs.toroidal(i).c.z;
            dz_lim_bot = zi + grid.L.z;
            dz_lim_top = zi - grid.L.z;
    
            for j = 1 : size(obj.Vs.toroidal, 2)
                zj = obj.Vs.toroidal(j).c.z;
                if zj ~= zi
                    dz_lim_bot = min(dz_lim_bot, zi - zj);
                    dz_lim_top = max(dz_lim_top, zi - zj);
                else
                    if j == i - 1
                        r_lim_bot = ri - delta*abs(ri - obj.Vs.toroidal(j).get_r(t, var_nt));
                    elseif j == i + 1
                        r_lim_top =  ri + delta*abs(obj.Vs.toroidal(j).get_r(t, var_nt) - ri);
                    end
                end
            end
            mask_i = mask_i.*(grid.Z >= (zi - delta*abs(dz_lim_bot))).*...
                             (grid.Z <= (zi + delta*abs(dz_lim_top)));
        end
        mask_i = mask_i.*(r >= r_lim_bot).*(r <= r_lim_top);
    end
end
end

