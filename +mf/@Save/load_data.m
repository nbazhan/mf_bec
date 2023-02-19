function data = load_data(obj)
% LOAD EVERYTHING IN FOLDER WITHOUT SPECIFING
vars = {'t', 'e', 'mu', 'l'};

for i = 1 : size(vars, 2)
    loaded = load([obj.drs.data vars{i} '.mat']);
    data.(vars{i}) = loaded.(vars{i});
end

fields = fieldnames(obj.model.Vs);
for i = 1 : size(fields, 1)
    loaded = load([ obj.drs.data 'u_' fields{i} '.mat']);
    data.(['u_' fields{i}]) = loaded.u;
end

if isfield(obj.drs, 'ro')
    loaded = load([ obj.drs.ro 'projec_ks.mat']);
    data.projec_ks = loaded.projec_ks;
end

if isfield(obj.drs, 'jv') && isfile([ obj.drs.jv 'jvs.mat'])
    loaded = load([ obj.drs.jv 'jvs.mat']);
    data.jvs = loaded.jvs;
    
    loaded = load([ obj.drs.jv 'rs.mat']);
    data.rs = loaded.rs;
elseif isfield(obj.drs, 'jv') && ~isfile([ obj.drs.jv 'jvs.mat'])
    obj.drs = rmfield(obj.drs, 'jv');
end

end

