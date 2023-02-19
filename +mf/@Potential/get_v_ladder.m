function v = get_v_ladder(obj, t, varargin)

u = obj.get_u(t);

if any(strcmp(varargin, 'nt'))
    grid = obj.model.grid_nt;
else
    grid = obj.model.grid;
end

phi = 2*pi/obj.n;
at = atan2(grid.Y, grid.X);
at = mod(at + obj.w*t, 2*pi);
at = at - 2*pi*(at > pi) - 0.5*phi;

%v = u*cos(obj.phi(ceil(obj.n/2))).*ones(size(grid.X));
v = u*obj.phi(ceil(obj.n/2)).*ones(size(grid.X));
for i = 0 : floor(obj.n/2) - 1
    v( (i)*phi <= at & at < (i + 1)*phi) = u*obj.phi(i + 1);
    v( -(i)*phi >= at & at > -(i + 1)*phi) = u*obj.phi(end - i);
    %v( i*phi <= at & at < (i + 1)*phi) = u*cos(obj.phi(i + 1));
    %v( -i*phi >= at & at > -(i + 1)*phi) = u*cos(obj.phi(end - i));
end

v = v.*(sqrt(grid.X.^2 + grid.Y.^2) > min(obj.rlim)).*(sqrt(grid.X.^2 + grid.Y.^2) < max(obj.rlim));

end