function v = get_v_box(obj, t, varargin)

u = obj.get_u(t);

if any(strcmp(varargin, 'nt'))
    grid = obj.model.grid_nt;
else
    grid = obj.model.grid;
end

filter = zeros(size(grid.X));

if strcmp(obj.direction, 'cartesian')
    for i = 1 : obj.model.D
        ax = obj.model.xyz(i);
        filter = filter + (grid.(upper(ax)) < min(obj.lim.(ax))) + (grid.(upper(ax)) > max(obj.lim.(ax)));
    end
elseif strcmp(obj.direction, 'polar')
    r = sqrt(grid.X.^2 + grid.Y.^2);
    filter = filter + (r < min(obj.lim.r)) + (r > max(obj.lim.r));
end
v = u*(filter > 0);

end