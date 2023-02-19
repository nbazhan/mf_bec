function U = get_u(obj, t)

if strcmp(obj.U.shape, 'rectangular')
    U = obj.get_u_rectangular(t);
elseif strcmp(obj.U.shape, 'blackman')
    U = obj.get_u_blackman(t);
end

end