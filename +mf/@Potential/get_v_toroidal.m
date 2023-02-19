function v = get_v_toroidal(obj, t, varargin)

if any(strcmp(varargin, 'nt'))
    var_nt = 'nt';
    grid = obj.model.grid_nt;
else
    var_nt = '';
    grid = obj.model.grid;
end

% if tof - decrease vr amplitude with c coef
if t <= obj.tof(1) || ~any(strcmp(varargin, 'tof'))
    c = 1;
elseif t < obj.tof(2)
    c = 1 - (t - obj.tof(1))/(obj.tof(2) - obj.tof(1));
else
    c = 0;
end

% calculate vr
rc = obj.get_rc(t);
r = ((grid.X - rc.x).^2 + (grid.Y - rc.y).^2).^0.5;
v = c*0.5*(obj.w.r/obj.model.w.r)^2*(r - obj.get_r(t, var_nt)).^2;

% add vz 
if obj.model.D == 3
    v = v + 0.5*(obj.w.z/obj.model.w.r)^2*(grid.Z - rc.z).^2;
end

% add bias
v = v + obj.get_u(t);
end