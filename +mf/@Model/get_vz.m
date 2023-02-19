function U = get_vz(obj, t)
V = obj.get_v(t);
U = squeeze(V(round(obj.grid.N.x/2), round(obj.grid.N.y/2), :));
end
