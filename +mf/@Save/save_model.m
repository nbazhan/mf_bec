function save_model(obj)

% create dir for storing model, sv if it does not exist
if ~isfield(obj.drs, 'model')
    obj.drs.model = [obj.folder, 'model/'];
    if ~exist(obj.drs.model, 'dir')
        util.create_folder(obj.drs.model);
    end
end


model = obj.model;
save([obj.drs.model 'model.mat'], 'model');

sv = obj;
save([obj.drs.model 'sv.mat'], 'sv');

% save information about model in text file
info = obj.get_info();
f = fopen([obj.drs.model 'INFO.txt'],'w');
fprintf(f, info);
fclose(f);

end