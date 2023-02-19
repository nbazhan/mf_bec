function drs = load_drs(obj)
% LOAD EVERYTHING IN FOLDER WITHOUT SPECIFING
drs = struct();
vars = {'data', 'psi', 'pictures', 'ills_ro', 'ills_jv'};
for i = 1 : size(vars, 2)
    if exist([obj.folder, vars{i}], 'dir')
        drs.(vars{i}) = [obj.folder, vars{i}, '/'];
    end
end

if exist([obj.folder, 'data/ro'], 'dir')
    drs.ro = [obj.folder, 'data/ro/'];
end

if exist([obj.folder, 'data/jv'], 'dir')
    drs.jv = [obj.folder, 'data/jv/'];
end

end

