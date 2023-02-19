function v = get_v_plane(obj, t, varargin)

if any(strcmp(varargin, 'nt'))
    grid = obj.model.grid_nt;
else
    grid = obj.model.grid;
end


norm = obj.get_norm(t);
re = norm(1)*(grid.X - obj.init(1)) + ...
     norm(2)*(grid.Y - obj.init(2)); 
if obj.model.D == 3
    re = re + norm(3)*(grid.Z - obj.init(3));
end

v = obj.get_u(t)*exp(-(1/(2*obj.width^2))*re.^2);    

end