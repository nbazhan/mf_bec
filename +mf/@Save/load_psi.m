function psi = load_psi(obj, s)
    load([obj.drs.psi 'psi' num2str(s, '%.0f') '.mat'], 'psi');
end

