classdef Init < handle
   properties
      model; 
      model_nt;      
      
      mu;
      phase;

      t = 0;
      dt = 2e-5;
      acc = 1e-5;

   end
   methods
       function obj = Init(params)
          if nargin == 1
              if isfield(params, 'model')
                  obj.model = params.model;
              end
              if isfield(params, 'dt')
                  obj.dt = params.dt;
              end
              if isfield(params, 't')
                  obj.t = params.t;
              end
              if isfield(params, 'mu')
                  obj.mu = params.mu;
              end
              if isfield(params, 'acc')
                  obj.acc = params.acc;
              end
              if isfield(params, 'phase')
                  obj.phase = params.phase;
              end
          end
          
          obj.t = obj.model.to_time_dim(obj.t);
          obj.dt = obj.model.to_time_dim(obj.dt);
          obj.mu = obj.model.to_energy_dim(obj.mu);

       end
   end
end