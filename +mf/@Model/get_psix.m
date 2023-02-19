function psi1 = get_psix(obj, psi)
if obj.D == 3
    psi1 = psi(:, round(obj.grid.N.y/2), round(obj.grid.N.z/2));
elseif obj.D == 2
    psi1 = psi(:, round(obj.grid.N.y/2));
end
end
