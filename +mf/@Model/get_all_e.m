function e = get_all_e(obj, Psi, t) 
% return array mu with chemical potential of each ring
if isfield(obj.Vs, 'toroidal')
    e = zeros(1, length(obj.Vs.toroidal));
    for i = 1:length(obj.Vs.toroidal)
        Psi_i = obj.get_ring_psi(Psi, i, t);
        e(i) = obj.get_e(Psi_i, t);
    end
else
    e = [obj.get_e(Psi, t)];
end
end