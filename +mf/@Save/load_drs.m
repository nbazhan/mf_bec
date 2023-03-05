function drs = load_drs(obj)
% LOAD EVERYTHING IN FOLDER WITHOUT SPECIFING
drs = struct();
vars = {'psi', 'pictures', 'ills_ro', 'ills_jv'};
for i = 1 : size(vars, 2)
    if exist([obj.folder, vars{i}], 'dir')
        drs.(vars{i}) = [obj.folder, vars{i}, '/'];
    end
end


end

