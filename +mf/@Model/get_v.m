function v = get_v(obj, t, varargin)

if any(strcmp(varargin, 'nt'))
    var_nt = 'nt';
    grid = obj.grid_nt;
else
    var_nt = '';
    grid = obj.grid;
end

if obj.D == 1
    v = zeros([1, grid.N.x]);
elseif obj.D == 2
    v = zeros([grid.N.x, grid.N.y]);
elseif obj.D == 3
    v = zeros([grid.N.x, grid.N.y, grid.N.z]);
end


typs = fieldnames(obj.Vs);
for i = 1 : length(typs)
    typ = typs{i};
    if ~strcmp('toroidal', typ)
        for j = 1 : length(obj.Vs.(typ))
            v = v + obj.Vs.(typ)(j).get_v(t, var_nt);
        end
    else
        rc = obj.Vs.toroidal(1).get_rc(t);
        r = sqrt((grid.X - rc.x).^2 + ...
                 (grid.Y - rc.y).^2);
        filter = obj.get_ring_mask(1, t,  var_nt).*(r < obj.Vs.toroidal(1).get_r(t, var_nt));
        v = v + obj.Vs.toroidal(1).get_v(t, var_nt).*filter;
        free_space = ~filter;
        if length(obj.Vs.toroidal) > 1
            for j = 2:length(obj.Vs.toroidal)
                rc = obj.Vs.toroidal(j).get_rc(t);
                r = sqrt((grid.X - rc.x).^2 + ...
                         (grid.Y - rc.y).^2);
                filter = obj.get_ring_mask(j - 1, t, var_nt).*(r > obj.Vs.toroidal(j - 1).get_r(t, var_nt));
                v = v + obj.Vs.toroidal(j - 1).get_v(t, var_nt, 'tof').*filter.*free_space;
                free_space = free_space.*~filter;

                filter = obj.get_ring_mask(j, t, var_nt).*...
                        (r < obj.Vs.toroidal(j).get_r(t, var_nt));
                v = v + obj.Vs.toroidal(j).get_v(t, var_nt, 'tof').*filter.*free_space;
                free_space = free_space.*~filter;
            end
        end
        filter = obj.get_ring_mask(length(obj.Vs.toroidal), t, var_nt).*(r > obj.Vs.toroidal(end).get_r(t, var_nt));
        v = v + obj.Vs.toroidal(end).get_v(t, var_nt).*free_space.*filter;
    end
end

end

