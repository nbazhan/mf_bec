function U = get_u_blackman_equal_time(obj, t)

tau_b = (obj.U.t(4) - obj.U.t(1))/(2*pi);
Ub = obj.U.max*(50/21);

t_mid = 0.5*(obj.U.t(4) + obj.U.t(1));
phi = (t - t_mid)/tau_b;

U = (Ub/50)*(21 + 25*cos(phi) + 4*cos(2*phi)).*(t >= obj.U.t(1)).*(t <= obj.U.t(4));
end