function [model, sv] = load_model(folder)
load([folder '/model.mat'], 'model');
load([folder '/sv.mat'], 'sv');

%sv.drs = sv.load_drs();
%sv.data = sv.load_data();
%sv = mf.Save(struct('model', model, 'folder', folder));
end

