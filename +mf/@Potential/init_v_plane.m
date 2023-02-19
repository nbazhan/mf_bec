function init_v_plane(obj)

      addprop(obj, 'w');
      if isfield(obj.params, 'w')
          obj.w = obj.model.to_omega_dim(obj.params.w);
      else
          obj.w = zeros([1 obj.model.D]);
      end


      addprop(obj, 'phi');
      if isfield(obj.params, 'phi')
          obj.phi = obj.params.phi;
      else
          obj.phi = zeros([1 obj.model.D]);
      end


      addprop(obj, 'init');
      if isfield(obj.params, 'init')
          obj.init = obj.model.to_length(obj.params.init);
      else
          obj.init = zeros([1 obj.model.D]);
      end


      addprop(obj, 'width');
      if isfield(obj.params, 'width')
          width = obj.params.width;
      else
          width = 10e-6;
      end
      obj.width = obj.model.to_length_dim(width);


end

