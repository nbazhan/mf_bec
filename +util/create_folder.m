function create_folder(folder)
% create empty folder
if ~exist(folder, 'dir')
    mkdir(folder)
 end
end