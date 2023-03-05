function calc_ro_complex(obj, ks)


sf = size(obj.data.t, 2);
if ~isfield(obj.data, 'projec_ks_complex')
    si = 1;
    projec_ks_complex = zeros([size(ks, 2), sf]);
else 
    projec_ks_complex = obj.data.projec_ks_complex;
    si = find(sum(projec_ks_complex, 1) == 0, 1, 'first');
end


for s = si : sf
    t = obj.data.t(s);

    psi = obj.load_psi(s);  
    psi_i = obj.model.get_ring_psi(psi, 1, t);
    psi_1 = obj.model.get_psi_1D_cyl(psi_i, obj.model.Vs.toroidal(1).get_r(t));


    dx = 2*pi*obj.model.Vs.toroidal(1).R.x/size(psi_1, 2);
    n_k_ground = abs(sum(conj(psi_1).*psi_1.*dx)).^2;
   
    
    for k_i = 1 : size(ks, 2)
        k = ks(k_i);

        phi = 2*pi*linspace(0, size(psi_1, 2), size(psi_1, 2))/size(psi_1, 2);
        psi_0 = sqrt(sum(abs(psi_1).^2)/(size(psi_1, 2))).*ones(size(psi_1)).*exp(1i*mod(k*phi, 2*pi));
    
        n_k = sum(conj(psi_1).*psi_0.*dx);
        n_k = n_k/sqrt(n_k_ground);
        
        projec_ks_complex(k_i, s) = n_k;
    end
    disp(['s:', num2str(s), ' projected sum = ', ...
                                  num2str(sum(projec_ks_complex(:, s)), '%.2g')])
end

obj.data.projec_ks_complex = projec_ks_complex;
obj.save_model()
end



