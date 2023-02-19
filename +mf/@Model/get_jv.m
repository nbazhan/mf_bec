function [rl_jv, r_jv] = get_jv(obj, psi, i1, i2, t)

v1 = obj.Vs.toroidal(i1);
v2 = obj.Vs.toroidal(i2);

if obj.D == 3
    psi_sec1 = psi(:, :, obj.to_nz(v1.c.z));
    psi_sec2 = psi(:, :, obj.to_nz(v2.c.z));
elseif obj.D == 2
    psi_sec1 = obj.get_ring_psi(psi, i1, t);
    psi_sec2 = obj.get_ring_psi(psi, i2, t);
end
psi_secs = psi_sec1 + psi_sec2;


dc_works = 0;
[psi_mid, ~] = obj.get_psi_1D_cyl(psi_secs, 0.5*(v1.get_r(t) + v2.get_r(t)));

if min(abs(psi_mid(:)).^2) > 0.01*max(abs(psi_secs(:)).^2)
    if obj.D == 2
        res = util.detect_core_2d(psi_secs, obj.grid.X, obj.grid.Y);
    elseif obj.D == 3
        res = util.detect_core_3d(psi_secs, obj.grid.X, obj.grid.Y, obj.grid.Z);
    end
    dc_works = ~isempty(res);
end
if dc_works
    rl_jv = atan2(res(:, 2).', res(:, 1).');
    r_jv = sqrt(res(:, 2).^2 + res(:, 1).^2).';
else
    
    hls = obj.get_healing_length(psi, t);
    if obj.D == 2 || v1.c.z == v2.c.z
        dhl = 0.5;
    else
        dhl = 0;
    end
    
    if sqrt((v1.R.x - v2.R.x).^2 + (v1.R.y - v2.R.y).^2) > hls(1) + hls(2)
        r1 = v1.get_r(t) + dhl*hls(i1);
        r2 = v2.get_r(t) - dhl*hls(i2);
    else
        r1 = v1.get_r(t) + 0.4*abs(v1.get_r(t) -  v2.get_r(t)) ;
        r2 = v2.get_r(t) - 0.4*abs(v1.get_r(t) -  v2.get_r(t)) ;
    end
    
    
    [psi1, rl] = obj.get_psi_1D_cyl(psi_sec1, r1);
    [psi2, ~] = obj.get_psi_1D_cyl(psi_sec2, r2);
    
    rl_jv = util.detect_jv(psi1, psi2, rl);
    r_jv = zeros(size(rl_jv));
    
    dix =  obj.grid.N.x/4;
    ix = obj.grid.N.x/2 + dix;
    for i = 1 : size(rl_jv, 2)
        iy = obj.grid.N.y/2 + dix*tan(r_jv(i));
        r = (v1.get_r(t) + v2.get_r(t))/2;
        if obj.D == 3
            r = r(ix, iy, obj.grid.N.z/2);
        elseif obj.D == 2
            r = r(ix, iy);
        end
        r_jv(i) = gather(r);
    end
end
end