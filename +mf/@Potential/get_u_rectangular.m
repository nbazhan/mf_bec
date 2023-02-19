function U = get_u_rectangular(obj, t)

f1 = (t <= obj.U.t(1));
f2 = (t <= obj.U.t(2));
f3 = (t <= obj.U.t(3));
f4 = (t <= obj.U.t(4));


U = zeros(size(t));

if obj.U.t(2) > obj.U.t(1)
    U = U + obj.U.max*((t - obj.U.t(1))/(obj.U.t(2) - obj.U.t(1))).*(~f1.*f2);
else
    U = U + obj.U.max*(t == obj.U.t(1));
end

if obj.U.t(3) > obj.U.t(2)
    U = U + obj.U.max*(~f2.*f3);
end

if obj.U.t(4) > obj.U.t(3)
    U = U + obj.U.max*((obj.U.t(4) - t)/(obj.U.t(4) - obj.U.t(3))).*(~f3.*f4);
end

end