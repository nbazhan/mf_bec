function v = get_v_toroidal(obj, t, var_nt, var_tof)

if strcmp(var_nt, 'nt')
    grid = obj.model.grid_nt;
else
    grid = obj.model.grid;
end

% if tof - decrease vr amplitude with c coef
tof = obj.tof.(var_tof);
if t <= tof(1) 
    c = 1;
elseif t < tof(2)
    c = 1 - (t - tof(1))/(tof(2) - tof(1));
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