classdef Potential < dynamicprops
   properties
      params;
      model;
      typ; % type of potential: toroidal, ladder, cosine, vertical
        
      U = struct('max', 0, ...
                 't', [0, 0.02, 0.04, 0.06], ...
                 'shape', 'rectangular'); % amplitude and protocol

   end
   methods
      function obj = Potential(params)
          if nargin == 1
              obj.params = params;
              
              obj.model = params.model;
              obj.typ = params.typ;

              if strcmp(obj.typ, 'toroidal')
                  obj.init_v_toroidal();
              elseif strcmp(obj.typ, 'vertical')
                  obj.init_v_vertical();
              elseif strcmp(obj.typ, 'cosine')
                  obj.init_v_cosine();
              elseif strcmp(obj.typ, 'ladder')
                  obj.init_v_ladder();
              elseif strcmp(obj.typ, 'plane')
                  obj.init_v_plane();
              elseif strcmp(obj.typ, 'elliptic')
                  obj.init_v_elliptic();
              elseif strcmp(obj.typ, 'box')
                  obj.init_v_box();
              end

              if isfield(params, 'U')
                  obj.U = util.add_struct(obj.U, params.U);
              end
              
              obj.U = struct('max', obj.model.to_energy_dim(obj.U.max),...
                             't', obj.model.to_time_dim(obj.U.t), ...
                             'shape', obj.U.shape);
              
          end
      end

      function v = get_v(obj, t, varargin)

          if any(strcmp(varargin, 'nt'))
              var_nt = 'nt';
          else
              var_nt = '';
          end

          % check if tof is applied to outer or to the inner part of ring
          if any(strcmp(varargin, 'inner'))
              var_tof = 'inner';
          else
              var_tof = 'outer';
          end


          if strcmp(obj.typ, 'toroidal')
              v = obj.get_v_toroidal(t, var_nt, var_tof);
          elseif strcmp(obj.typ, 'vertical')
              v = obj.get_v_vertical(t, var_nt);
          elseif strcmp(obj.typ, 'cosine')
              v = obj.get_v_cosine(t, var_nt);
          elseif strcmp(obj.typ, 'ladder')
              v = obj.get_v_ladder(t, var_nt);
          elseif strcmp(obj.typ, 'plane')
              v = obj.get_v_plane(t, var_nt);
          elseif strcmp(obj.typ, 'elliptic')
              v = obj.get_v_elliptic(t, var_nt);
          elseif strcmp(obj.typ, 'box')
              v = obj.get_v_box(t, var_nt);
          end
      end

   end
end