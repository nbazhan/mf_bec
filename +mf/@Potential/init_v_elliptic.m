function init_v_elliptic(obj)

      % ellipse a, b
      addprop(obj, 'R');
      if isfield(obj.params, 'R')
          R = obj.params.R;
      else
          R = [30*10^(-6), 30*10^(-6)];
      end
      R = obj.model.to_length_dim(R);
      obj.R = struct('x', R(1), 'y', R(2));

      
      % width of gaussian beam
      addprop(obj, 'width');
      if isfield(obj.params, 'width')
          width = obj.params.width;
      else
          width = 10e-6;
      end
      obj.width = obj.model.to_length_dim(width);

      
      % angular velocity of ellipse rotating around itself
      addprop(obj, 'W');
      if isfield(obj.params, 'W')
          obj.W = obj.model.to_omega_dim(obj.params.W);
      else
          obj.W = 0;
      end


      % center of ellipse and r, w of center rotating around itself
      addprop(obj, 'c');
      c = struct('xy', [0, 0], ...
                 'r', [0, 0], 'w', 0);
      if isfield(obj.params, 'c')
          c = util.add_struct(c, obj.params.c);
      end
      c.xy = obj.model.to_length_dim(c.xy);
      c.r = obj.model.to_length_dim(c.r);
      c.w = obj.model.to_omega_dim(c.w);
      obj.c = struct('x', c.xy(1), 'y', c.xy(2), ...
                     'rx', c.r(1), 'ry', c.r(2), 'w', c.w);
      if obj.model.D == 3
          obj.c.z = c.xy(3);
      end


      % initial phase of ellipse
      addprop(obj, 'phi');
      if isfield(obj.params, 'phi')
          obj.phi = obj.params.phi;
      else
          obj.phi = 0;
      end

end

