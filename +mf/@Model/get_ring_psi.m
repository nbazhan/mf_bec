function Psi_i = get_ring_psi(obj, Psi, i, t)
% returns Psi with only 1 ring Vts(i)
Psi_i = Psi.*obj.get_ring_mask(i, t);
end

