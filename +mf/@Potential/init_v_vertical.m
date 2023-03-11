function init_v_vertical(obj)

      addprop(obj, 'W');
      if isfield(obj.params, 'W')
          obj.W = obj.model.to_omega_dim(obj.params.W);
      else
          obj.W = 0;
      end


      addprop(obj, 'n');
      if isfield(obj.params, 'n')
          obj.n = obj.params.n;
      else
          obj.n = 1;
      end


      addprop(obj, 'width');
      if isfield(obj.params, 'width')
          width = obj.params.width;
      else
          width = 1e-6;
      end
      obj.width = obj.model.to_length_dim(width);


      addprop(obj, 'rlim');
      if isfield(obj.params, 'rlim')
          obj.rlim = obj.model.to_length_dim(obj.params.rlim);
      else
          obj.rlim = [0, sqrt((obj.model.grid.L.x/2).^2 + (obj.model.grid.L.y/2).^2)];
      end


      addprop(obj, 'phi');
      if isfield(obj.params, 'phi')
          obj.phi = obj.params.phi;
      else
          obj.phi = zeros([1 obj.n]);
      end

end

