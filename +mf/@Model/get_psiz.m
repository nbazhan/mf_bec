function psi1 = get_psiz(obj, psi)
psi1 = squeeze(psi(round(obj.grid.N.x/2), round(obj.grid.N.y/2), :));
end
