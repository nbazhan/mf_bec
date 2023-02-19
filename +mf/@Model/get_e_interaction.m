function e = get_e_interaction(obj, Psi)
Psi2 = Psi.*conj(Psi);
e = (0.5*obj.config.g*Psi2).*Psi2;
e = gather(real(sum(e(:).*obj.grid.dV)));
end