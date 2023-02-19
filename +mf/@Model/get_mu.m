function mu = get_mu(obj, Psi, t) 
% return chemical potential mu
N = obj.get_n(Psi);
H = obj.applyham(Psi, obj.get_v(t) + obj.config.g*(abs(Psi).^2));
mu = real(sum(H(:)).*obj.grid.dV)/N;
end