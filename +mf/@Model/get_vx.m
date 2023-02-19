function U = get_vx(obj, t)
V = obj.get_v(t);
if obj.D == 1
    U = V;
elseif obj.D == 2
    U = V(:, round(obj.grid.N.y/2));
elseif obj.D == 3
    U = V(:, round(obj.grid.N.y/2), round(obj.grid.N.z/2));
end
end
