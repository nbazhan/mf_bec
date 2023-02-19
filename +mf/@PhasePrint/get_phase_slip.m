function phase = get_phase_slip(obj, m, theta, r, dr)

Y2 = obj.model.grid.Y - r*sin(theta);
X2 = obj.model.grid.X - r*cos(theta);
r_mask = (sqrt(Y2.^2 + X2.^2) < dr);
phase = (atan(Y2./X2) + pi*(X2 < 0) + 2*pi*(X2 > 0).*(Y2 < 0) - theta).*r_mask;
phase = mod(m*phase, 2*pi);

end 

