function v = get_v_elliptic(obj, t, varargin)

if any(strcmp(varargin, 'nt'))
    var_nt = 'nt';
    grid = obj.model.grid_nt;
else
    var_nt = '';
    grid = obj.model.grid;
end

% calculate vr
rc = obj.get_rc(t);
r = ((grid.X - rc.x).^2 + (grid.Y - rc.y).^2).^0.5;

u = obj.get_u(t);
v = u*exp(-((r - obj.get_r(t, var_nt)).^2/(2*obj.width^2))); 

end