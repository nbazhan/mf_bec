function e = get_e(obj, Psi, t)
Psi2 = Psi.*conj(Psi);
e = 0.5*conj(Psi).*ifftn(obj.grid.kk.*fftn(Psi)) + ...
    0.5*Psi.*ifftn(obj.grid.kk.*fftn(conj(Psi))) + ...
    (obj.get_v(t) + 0.5*obj.config.g*Psi2).*Psi2;
e = gather(real(sum(e(:).*obj.grid.dV)));
end