classdef Run < handle
   properties
      model; 

      dt = 2*10^-6;
      dt_f; % time step (with gamma included)
      inv_td;
      ekk;

      n_iter = 500;
      n_iter_fft = 10;
      n_rec = 10;
      n_l_rec = 3; 
      
      ecut = 0;
      variance; 

   end
   methods
      function obj = Run(params)
          if nargin == 1
              if isfield(params, 'model')
                  obj.model = params.model;
              end
              if isfield(params, 'dt')
                  obj.dt = params.dt;
              end
              if isfield(params, 'ecut')
                  obj.ecut = params.ecut;
              end
          end
          
          obj.inv_td = 1/(obj.model.config.td);
          
          obj.dt = obj.model.to_time_dim(obj.dt);
          obj.dt_f = obj.dt*1i/(1 + 1i*obj.model.config.gamma);% time step (with gamma included)
          
          obj.ecut = obj.model.to_energy_dim(obj.ecut);
          if(obj.ecut > 0 && obj.model.config.T > 0)
              mask = obj.model.grid.kk < obj.ecut;
              obj.ekk = exp(-obj.model.grid.kk*obj.dt_f).*mask; % mask in fourier space implements cut-off of high-energy modes 
          else
              obj.ekk = exp(-obj.model.grid.kk*obj.dt_f);
          end

          obj.variance = sqrt(obj.model.config.T*obj.model.config.gamma*obj.dt/obj.model.grid.dV);
          

      end
   end
end