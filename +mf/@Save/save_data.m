function save_data(obj, s, t, psi)


% save psi if save_psi = 1
if obj.save_psi
    if ~isfield(obj.drs, 'psi')
        obj.drs.psi = [obj.folder, 'psi/'];
        if ~exist(obj.drs.psi, 'dir')
            util.create_folder(obj.drs.psi);
        end
    end
    save([obj.drs.psi 'psi' num2str(s,'%.0f') '.mat'], 'psi');
end


% save angular momentum l
if obj.model.D > 1
    obj.data.l(:, s) = obj.model.get_all_l(psi, t).';
end


% save chemical potential mu
obj.data.mu(:, s) = obj.model.get_all_mu(psi, t).';


% save energy e
obj.data.e(:, s) = obj.model.get_all_e(psi, t).';

% saving all potential amplitudes
all_u = obj.model.get_all_u(t);
fields = fieldnames(all_u);
for i = 1 : length(fields)
    field = fields{i};
    us = all_u.(field);
    obj.data.(['u_' field])(:, s) = us.';
end


%saving time t
obj.data.t(s) = t;


obj.save_model();
end