function r = get_r(obj, t, varargin)

if any(strcmp(varargin, 'nt'))
    grid = obj.model.grid_nt;
else
    grid = obj.model.grid;
end

phi = atan2(grid.Y - obj.get_rc(t).y, grid.X - obj.get_rc(t).x);
if obj.R.x <= 0 && obj.R.y <= 0
    r2 = 0;
else
    r2 = obj.R.x^2*obj.R.y^2./...
        ((obj.R.y*cos(obj.W*t - phi + obj.phi)).^2 + ...
         (obj.R.x*sin(obj.W*t - phi + obj.phi)).^2);
end
r = sqrt(r2) + (obj.wave.r + obj.wave.dr*cos(phi - obj.wave.w*t/obj.wave.n - obj.wave.phi)).*cos(phi*obj.wave.n - obj.wave.phi - obj.wave.w*t);
end