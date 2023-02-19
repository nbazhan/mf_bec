function hl = get_healing_length(obj, Psi, t)
if ~isempty(obj.Vs.toroidal)
    hl = zeros(size(obj.Vs.toroidal));
    for i = 1 : size(obj.Vs.toroidal, 2)
        Psi_i = Psi.*obj.get_ring_mask(i, t);
        n0 = max(abs(Psi_i(:)).^2);
        if obj.D == 3
            hl(i) = gather(1/sqrt(8*pi*obj.config.as*n0));
        elseif obj.D ==2
            hl(i) = gather(1/sqrt(obj.config.g*n0));
        end
    end
end
end