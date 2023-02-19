function mu = get_all_mu(obj, Psi, t) 
% return array mu with chemical potential of each ring
if isfield(obj.Vs, 'toroidal')
    mu = zeros(1, length(obj.Vs.toroidal));
    for i = 1:length(obj.Vs.toroidal)
        Psi_i = obj.get_ring_psi(Psi, i, t);
        mu(i) = gather(obj.get_mu(Psi_i, t));
    end
else
    mu = [gather(obj.get_mu(Psi, t))];
end
end