function v = get_critical_velocity(obj, psi)
    
    g = obj.to_g(obj.config.g);
    psi = obj.to_psi(psi);

    if obj.D == 2 && obj.rings.n > 0
        for i = 1 : obj.rings.n
            r = obj.Vs.toroidal(i).R.x; 
            n_ring = mean(abs(obj.get_psi_1D_cyl(psi, r)).^2);
            v(i) = sqrt(g*n_ring/obj.config.M);
        end
    else
         v = sqrt(g*max(psi(:).^2)/obj.config.M);
    end
end