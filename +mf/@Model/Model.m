classdef Model < handle
   properties

       D = 3; % dimensions 
       l = struct('r', 1e-6, 'z', 0.5e-6); % oscillator length
       w;
       w_cs = 0; % angular velocity of coordinate system
       test = 0; % if test - display variables during execution
       xyz = 'xyz';

       w_xy = 2*pi*2*1000; % for case of 1D BEC - transverse confinement
       
       config = struct('hbar', 1.054571800e-34, ... % Planck constant
                       'kb', 1.38064852e-23, ... % Boltzmann constant
                       'amu', 1.660539040e-27, ... % atomic mass unit
                       'a0', 5.2917721067e-11, ... % Bohr radius
                       'td',  10, ... % sec, time of decay
                       'gamma', 0.015, ... % dissipation parameter
                       'T', 0, ... % temperature
                       'che', 'Rb87', ... % type of atoms (chemical element)
                       'N', 100000)% N particles
      
       grid = struct('GPU', 1, ...
                     'N', [128, 128, 32], ...
                     'L', [100e-6, 100e-6, 30e-6]);
       
       grid_nt;
       Vs;
       rings = struct('n', 0);
       
   end
   methods
      function obj = Model(params)
          if nargin == 1
              if isfield(params, 'config')
                  obj.config = util.add_struct(obj.config, params.config);
              end
              if isfield(params, 'grid')
                  if isfield(params.grid, 'L')
                      obj.grid.L = cat(2, params.grid.L, obj.grid.L(size(params.grid.L, 2) + 1 : end));
                  end
                  if isfield(params.grid, 'N')
                      obj.grid.N = cat(2, params.grid.N, obj.grid.N(size(params.grid.N, 2) + 1 : end));
                  end
                  if isfield(params.grid, 'GPU')
                    obj.grid.GPU = params.grid.GPU;
                  end
              end
              if isfield(params, 'test')
                  obj.test = params.test;
              end
              if isfield(params, 'D')
                  obj.D = params.D;
              end
              if isfield(params, 'w')
                  obj.w = struct('r', params.w(1), ...
                                 'z', params.w(2));
              end
              if isfield(params, 'l')
                  obj.l = struct('r', params.l(1), ...
                                 'z', params.l(2));
              end
              if isfield(params, 'w_cs')
                  obj.w_cs = params.w_cs;
              end
              if isfield(params, 'w_xy')
                  obj.w_xy = params.w_xy;
              end
          end

          obj.init_config();

          obj.grid_nt = struct('GPU', obj.grid.GPU, ...
                               'L', 2*obj.grid.L, ...
                               'N', 2*obj.grid.N);
          obj.grid = util.add_struct(obj.grid, obj.init_grid(obj.grid));
          obj.grid_nt = util.add_struct(obj.grid_nt, obj.init_grid(obj.grid_nt));
          
          obj.w_cs = obj.to_omega_dim(obj.w_cs);
          if obj.D == 3
              obj.rings.zs = [];
              obj.rings.nz = 0;
          end
      end

 %% functions
 % calculate hamiltonian
      function H = applyham(obj, psi, V)
          if obj.w_cs == 0
              Hk = conj(psi).*ifftn(obj.grid.kk.*fftn(psi));
          else
              Hk = conj(psi).*(ifft((0.5*obj.grid.k.x.^2 - obj.grid.k.x.*obj.grid.Y*obj.w_cs).*fft(psi, obj.grid.N.x, 1), obj.grid.N.x, 1) + ...
                               ifft((0.5*obj.grid.k.y.^2 + obj.grid.k.y.*obj.grid.X*obj.w_cs).*fft(psi, obj.grid.N.y, 2), obj.grid.N.y, 2));
              if obj.D == 3
                  Hk = Hk + ifft((0.5*obj.grid.k.z.^2).*fft(psi, obj.grid.N.z, 3), obj.grid.N.z, 3);
              end
          end
          Hi = conj(psi).*V.*psi;
          H = Hk + Hi;
      end

      function angm = applyangm(obj, psi, ax, r0)
          %% Calculates action of the Lz operator on the arbitrary state phi
          %% Optioanal argumant r0 allows to set the coordinates of the center

          if(nargin <= 3)
              r0=[0,0];
          end
          if strcmp(ax, 'z')
	          angm = -1i*((obj.grid.X - r0(1)).*obj.deriv(psi, 'y') - (obj.grid.Y - r0(2)).*obj.deriv(psi, 'x'));
          else
              error('Function applyangm is not written for specified axis')
          end
      end

      function ret = deriv(obj, psi, ax)
          if strcmp(ax, 'x')
              if obj.D == 1
                ret = (-circshift(psi, 2) + 8*circshift(psi,1) - ...
                      8*circshift(psi,-1) + circshift(psi,-2))./(12*obj.grid.h.x);
              elseif obj.D == 2 || obj.D == 3
                ret = (-circshift(psi, [0 2]) + 8*circshift(psi,[0 1]) - ...
                      8*circshift(psi,[0 -1]) + circshift(psi,[0 -2]))./(12*obj.grid.h.x);
              end
          elseif strcmp(ax, 'y')
              ret = (-circshift(psi,[2 0]) + 8*circshift(psi,[1 0]) - ...
                    8*circshift(psi,[-1 0]) + circshift(psi,[-2 0]))./(12*obj.grid.h.y);
          elseif strcmp(ax, 'z')
              ret = (-circshift(psi,[0 0 2]) + 8*circshift(psi,[0 0 1]) - ...
                    8*circshift(psi,[0 0 -1]) + circshift(psi,[0 0 -2]))./(12*obj.grid.h.z);
          end
      end

      
      function res = shrink(obj, psi)
          nx = round(obj.grid.N.x/2);
          ny = round(obj.grid.N.y/2);
          nz = round(obj.grid.N.z/2);
          if obj.D == 1
              res = psi(nx + 1 : 3*nx);
          elseif obj.D == 2
              res = psi(nx + 1 : 3*nx, ny + 1 : 3*ny);
          elseif obj.D == 3
              res = psi(nx + 1 : 3*nx, ny + 1 : 3*ny, nz + 1 : 3*nz);
          end
      end
      
      function res = extend(obj, psi)
            nx = round(obj.grid.N.x/2);
            ny = round(obj.grid.N.y/2);
            nz = round(obj.grid.N.z/2);
            if obj.D == 1
                res = zeros(4*nx);
                res(nx + 1 : 3*nx) = psi;
            elseif obj.D == 2
                res = zeros(4*nx, 4*ny);
                res(nx + 1 : 3*nx, ny + 1 : 3*ny) = psi;
            elseif obj.D == 3
                res = zeros(4*nx, 4*ny, 4*nz);
                res(nx + 1 : 3*nx, ny + 1 : 3*ny, nz + 1 : 3*nz) = psi;
            end
      end
      

      %% converting functions  
      % convert 
      function n = to_n(obj, l, ax)
          n = round(obj.grid.N.(ax)*(l - obj.grid.r.(ax)(1))/obj.grid.L.(ax));
      end

      % convert length
      function converted_length = to_length_dim(obj, length)
          converted_length = length/obj.l.r;
      end

      function length = to_length(obj, converted_length)
          length = converted_length*obj.l.r;
      end

      % convert time
      function converted_time = to_time_dim(obj, time)
          converted_time = time*obj.w.r;
      end

      function time = to_time(obj, converted_time)
          time = converted_time/obj.w.r;
      end

      % convert energy
      function converted_energy = to_energy_dim(obj, energy)
          converted_energy = energy/(obj.config.hbar*obj.w.r);
      end

      function energy = to_energy(obj, converted_energy)
          energy = converted_energy*obj.config.hbar*obj.w.r;
      end

      function energy_recoil = to_energy_recoil(obj, converted_energy)
          energy_recoil = converted_energy*obj.config.hbar*obj.w.r/(0.25*10^(-29));
      end

      % convert omega
      function converted_omega = to_omega_dim(obj, omega)
          converted_omega = omega/obj.w.r;
      end

      function omega = to_omega(obj, converted_omega)
          omega = converted_omega*obj.w.r;
      end

      % convert temperature
      function converted_temperature = to_temp_dim(obj, temperature)
          converted_temperature = temperature/(obj.config.hbar*obj.w.r/obj.config.kb);
      end

      function temperature = to_temp(obj, converted_temperature)
          temperature = converted_temperature*obj.config.hbar*obj.w.r/obj.config.kb;
      end

      % convert psi
      function converted_psi = to_psi_dim(obj, psi)
          converted_psi = psi*obj.l.r^(ndims(psi)*0.5);
      end
   end
end