classdef Save < handle
   properties
      % model itself
      model;

      % main folder with data
      folder;

      % structure with pathes to dirs with data
      drs;

      % structure which stores data
      data;

      % parameter which decides whether to save psi or not
      save_psi = 1;
      save_jv = [];

      % structure which stores plotting parameters
      plt;

   end
   methods
      function obj = Save(params)
          if nargin == 1
              if isfield(params, 'model')
                  obj.model = params.model;
              end
              if isfield(params, 'folder')
                  obj.folder = [params.folder, '/'];
                  util.create_folder(obj.folder);
              end
              if isfield(params, 'save_psi')
                  obj.save_psi = params.save_psi;
              end
          end
          
          % initialize common parameters for plotting
          obj.init_plt();

      end
   end
end