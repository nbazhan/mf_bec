function calc_jv_from_init(obj, init_jvs)

obj.drs.jv = [obj.drs.data 'jv/'];
if ~exist(obj.drs.jv, 'dir')
    util.create_folder(obj.drs.jv);
end


if ~isfield(obj.data, 'jvs') || ~exist(obj.drs.jv, 'dir')
    %s = size(obj.data.t, 2);
    %psi = obj.load_psi(s);
    %t = obj.data.t(s);
    %[rjv, r] = obj.model.get_jv(psi, 1, 2, t);

    s = 1;
    rjv = init_jvs; 
    r_mean = 0.5*(obj.model.Vs.toroidal(1).R.x + obj.model.Vs.toroidal(2).R.x);
    r = r_mean*ones(size(init_jvs));
    jvs = NaN([size(obj.data.t, 2) size(rjv, 2)]);
    rs = NaN([size(obj.data.t, 2) size(rjv, 2)]);
    jvs(s, :) = rjv;
    rs(s, :) = r;
    si = s + 1;
else 
    jvs = obj.data.jvs;
    rs = obj.data.rs;
    si = find(sum(isnan(jvs), 2) ~= size(jvs, 2), 1, 'last');
    si = si + 1;
end

sf = size(obj.data.t, 2);
for s = si : sf
    psi = obj.load_psi(s);
    t = obj.data.t(s);
    
    [rjv, r] = obj.model.get_jv(psi, 1, 2, t);

    for i = 1 : size(rjv, 2)
        jv_prev = jvs(s - 1, :);
        min_dif = min(mod(abs(rjv(i) - jv_prev), 2*pi));
        [min_dif_value, ind] = min(min_dif);
        

        diffs_nan = (sum(isnan([min_dif_value, mod(abs(jvs(s, ind) - jv_prev), 2*pi)])) ~= 0);
        if (~diffs_nan && min_dif_value <= mod(abs(jvs(s, ind) - jv_prev), 2*pi)) || diffs_nan
            jvs(s, ind) = rjv(i);
            rs(s, ind) = r(i);
        end
    end

    disp([num2str(s), ':', num2str(sf), ' jv detected'])
    disp(jvs(s, :))
end 

save([obj.drs.jv 'jvs.mat'], 'jvs');
save([obj.drs.jv 'rs.mat'], 'rs');

obj.data.jvs = jvs;
obj.data.rs = rs;
end



