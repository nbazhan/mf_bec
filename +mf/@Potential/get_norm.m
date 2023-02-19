function norm = get_norm(obj, t)
phi = obj.w*t + obj.phi;
norm = [cos(phi(1))*sin(phi(3)), sin(phi(2))*sin(phi(3)), cos(phi3)];
end

