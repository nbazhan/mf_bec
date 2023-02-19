function phase = get_circular_phase_zeros_pi(obj, m, zero_pi)

phase = zeros(size(obj.model.grid.X));

at = atan(obj.model.grid.Y./obj.model.grid.X);
at = at + pi*(obj.model.grid.X < 0) + 2*pi*(obj.model.grid.X > 0).*(obj.model.grid.Y < 0);
%if m == -1
%    at = 2*pi - at;
%    pi_points = 2*pi - pi_points;
%end

phi_pi0 = zero_pi(2) - zero_pi(1) + 2*pi*(zero_pi(2) < zero_pi(1));
phi_0pi = zero_pi(1) - zero_pi(2) + 2*pi*(zero_pi(1) < zero_pi(2));


A1 = pi/phi_pi0;
A2 = pi/phi_0pi;

if m == 1
    eq1 = A1*(at - zero_pi(1) + 2*pi*(at < zero_pi(1)));
    if zero_pi(2) > zero_pi(1)
        phase = phase +  eq1.*(at >= zero_pi(1)).*(at < zero_pi(2));
    else
        phase = phase +  eq1.*(at >= zero_pi(1) | at < zero_pi(2));
    end
    
    eq2 = pi + A2*(at - zero_pi(2) + 2*pi*(at < zero_pi(2)));
    if zero_pi(1) > zero_pi(2)
        phase = phase + eq2.*(at >= zero_pi(2)).*(at < zero_pi(1));
    else
        phase = phase + eq2.*(at >= zero_pi(2) | at < zero_pi(1));
    end

elseif m == -1
    
    eq1 = 2*pi + A1*(zero_pi(1) - at + 2*pi*(at < zero_pi(1)));
    if zero_pi(2) > zero_pi(1)
        phase = phase +  eq1.*(at >= zero_pi(1)).*(at < zero_pi(2));
    else
        phase = phase +  eq1.*(at >= zero_pi(1) | at < zero_pi(2));
    end
    
    eq2 = pi + A2*(zero_pi(2) - at + 2*pi*(at < zero_pi(2)));
    if zero_pi(1) > zero_pi(2)
        phase = phase + eq2.*(at >= zero_pi(2)).*(at < zero_pi(1));
    else
        phase = phase + eq2.*(at >= zero_pi(2) | at < zero_pi(1));
    end
end

end
