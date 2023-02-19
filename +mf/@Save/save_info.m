function save_info(obj)

% create dir for storing model, sv if it does not exist
if ~isfield(obj.drs, 'model')
    obj.drs.model = [obj.folder, 'model/'];
    if ~exist(obj.drs.model, 'dir')
        util.create_folder(obj.drs.model);
    end
end

% save information about model in text file
info = obj.get_info();
f = fopen([obj.drs.model 'INFO.txt'],'w');
fprintf(f, info);
fclose(f);

end