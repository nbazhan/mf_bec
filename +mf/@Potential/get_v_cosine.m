function v = get_v_cosine(obj, t, varargin)

u = obj.get_u(t);

if any(strcmp(varargin, 'nt'))
    grid = obj.model.grid_nt;
else
    grid = obj.model.grid;
end

at = atan2(grid.Y, grid.X);
v = u*cos(obj.n*at - obj.W*t + obj.phi);

end