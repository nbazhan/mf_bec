function L = get_all_l(obj, Psi, t)
% return array L with angular momentum of each ring
if isfield(obj.Vs, 'toroidal')
    L = zeros(1, length(obj.Vs.toroidal));
    for i = 1:length(obj.Vs.toroidal)
        Psi_i = obj.get_ring_psi(Psi, i, t);
        L(i) = obj.get_l(Psi_i);
    end
else
    L = [obj.get_l(Psi)];
end
end

