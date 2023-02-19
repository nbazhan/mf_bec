function U = get_u_blackman(obj, t)

tau_b = (50/21)*(obj.U.t(4) - obj.U.t(1))/(2*pi);
t_mid = 0.5*(obj.U.t(4) + obj.U.t(1));
phi = (t - t_mid)/tau_b;

U = (obj.U.max/50)*(21 + 25*cos(phi) + 4*cos(2*phi)).*(t >= t_mid - 0.5*tau_b).*(t <= t_mid + 0.5*tau_b);
end