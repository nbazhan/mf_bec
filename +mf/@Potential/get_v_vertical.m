function v = get_v_vertical(obj, t, varargin)
v = 0;
u = obj.get_u(t);
phi = obj.W*t;

if any(strcmp(varargin, 'nt'))
    grid = obj.model.grid_nt;
else
    grid = obj.model.grid;
end

r2 = grid.X.^2 + grid.Y.^2;
filter = (r2 >= obj.rlim(1)).*(r2 <= obj.rlim(2));

if obj.n > 0
    for i = 1 : obj.n
        theta =  ((grid.X.*cos(phi + obj.phi(i)) + ...
                   grid.Y.*sin(phi + obj.phi(i))) > 0);
        v = v + u*exp(-(1/(2*obj.width^2))*...
                     (grid.X.*sin(phi + obj.phi(i))- ...
                      grid.Y.*cos(phi + obj.phi(i))).^2).*theta;    
    end
end
v = v.*filter;
end