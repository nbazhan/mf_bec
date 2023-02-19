function n = get_n(obj, Psi)
n = sum(abs(Psi(:)).^2) * obj.grid.dV;
end