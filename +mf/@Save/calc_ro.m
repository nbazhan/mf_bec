function calc_ro(obj, ks)

if ~isfield(obj.drs, 'ro')
    obj.drs.ro = [obj.drs.data 'ro/'];
    if ~exist(obj.drs.ro, 'dir')
        util.create_folder(obj.drs.ro);
    end
end


sf = size(obj.data.t, 2);
if ~isfield(obj.data, 'projec_ks')
    si = 1;
    projec_ks = zeros([size(ks, 2), sf]);
else 
    projec_ks = obj.data.projec_ks;
    si = find(sum(projec_ks, 1) == 0, 1, 'first');
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
    
        n_k = abs(sum(conj(psi_1).*psi_0.*dx)).^2;
        n_k = n_k/n_k_ground;
        
        projec_ks(k_i, s) = n_k;
    end
    disp(['s:', num2str(s), ' projected sum = ', ...
                                  num2str(sum(projec_ks(:, s)), '%.2g')])
end

save([obj.drs.ro 'projec_ks.mat'], 'projec_ks');
obj.data.projec_ks = projec_ks;
end



