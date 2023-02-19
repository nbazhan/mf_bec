function n = get_all_n(obj, Psi, t) 
% return array mu with chemical potential of each ring
n = zeros(1, length(obj.Vs.toroidal));
for i = 1:length(obj.Vs.toroidal)
    Psi_i = obj.get_ring_psi(Psi, i, t);
    n(i) = obj.get_n(Psi_i);
end
end