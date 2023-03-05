function calc_jv(obj)


if ~isfield(obj.data, 'jvs')
    s = size(obj.data.t, 2);
    
    psi = obj.load_psi(s);
    t = obj.data.t(s);
    [rjv, r] = obj.model.get_jv(psi, 1, 2, t);
    
    jvs = zeros([s size(rjv, 2)]);
    rs = zeros([s size(rjv, 2)]);
    jvs(s, :) = rjv;
    rs(s, :) = r;

    sf = s - 1;
else 
    jvs = obj.data.jvs;
    rs = obj.data.rs;
    sf = find(sum(jvs, 1) == 0, 1, 'last');
end


for s = sf : -1 : 1
    psi = obj.load_psi(s);
    t = obj.data.t(s);
    
    [rjv, r] = obj.model.get_jv(psi, 1, 2, t);
    
    for i = 1 : size(jvs, 2)
        jv_prev = jvs(s + 1, i);
        min_dif = min(abs(rjv - jv_prev), ...
                  min(abs(rjv - jv_prev + 2*pi), ...
                      abs(rjv - jv_prev - 2*pi)));
        [~, ind] = min(min_dif);
        jvs(s, i) = rjv(ind);
        rs(s, i) = r(ind);
    end
    disp([num2str(s), ':', num2str(sf), ' jv detected'])
end 

obj.data.jvs = jvs;
obj.data.rs = rs;

obj.save_model()
end



