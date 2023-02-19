function phase = get_circular_phase(obj, m, varargin)

phase = zeros(size(obj.model.grid.X));

at = atan(obj.model.grid.Y./obj.model.grid.X);
at = at + pi*(obj.model.grid.X < 0) + 2*pi*(obj.model.grid.X > 0).*(obj.model.grid.Y < 0);

if isempty(varargin)
    phase = mod(m*at, 2*pi);
else
    pi_points = sort(varargin{1});
    for i = 1 : size(pi_points, 2)
        phix = pi_points(i);
        if i == 1
            phi1 = (pi_points(1) + pi_points(end) + 2*pi)/2;
        else
            phi1 = mean(pi_points(i-1:i));
        end
    
        if i == size(pi_points, 2)
            phi2 = (pi_points(1) + pi_points(end) + 2*pi)/2;
        else
            phi2 = mean(pi_points(i:i+1));
        end
    
        phix1 = phix - phi1 + 2*pi*(phix < phi1);
        phi2x = phi2 - phix + 2*pi*(phix > phi2);
        if m == 1
        
            A1 = pi/phix1;
            eq1 = A1*(at - phi1 + 2*pi*(at < phi1));
            if phix > phi1
                phase = phase +  eq1.*(at >= phi1).*(at < phix);
            else
                phase = phase +  eq1.*(at >= phi1 | at < phix);
            end
        
        
            A2 = pi/phi2x;
            eq2 = pi + A2*(at - phix + 2*pi*(at < phix));
            if phi2 > phix
                phase = phase + eq2.*(at >= phix).*(at < phi2);
            else
                phase = phase + eq2.*(at >= phix | at < phi2);
            end
    
        elseif m == -1
            
            A1 = pi/phix1;
            eq1 = pi + A1*(phix - at + 2*pi*(at > phix));
            if phix > phi1
                phase = phase +  eq1.*(at >= phi1).*(at < phix);
            else
                phase = phase +  eq1.*(at >= phi1 | at < phix);
            end
        
        
            A2 = pi/phi2x;
            eq2 = A2*(phi2 - at + 2*pi*(at > phi2));
            if phi2 > phix
                phase = phase + eq2.*(at >= phix).*(at < phi2);
            else
                phase = phase + eq2.*(at >= phix | at < phi2);
            end
        end
    
    end
end
end
