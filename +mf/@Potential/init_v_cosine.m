function init_v_cosine(obj)

      addprop(obj, 'n');
      if isfield(obj.params, 'n')
          obj.n = obj.params.n;
      else
          obj.n = 1;
      end


      addprop(obj, 'phi');
      if isfield(obj.params, 'phi')
          obj.phi = obj.params.phi;
      else
          obj.phi = 0;
      end


      addprop(obj, 'W');
      if isfield(obj.params, 'W')
          obj.W = obj.model.to_omega_dim(obj.params.W);
      else
          obj.W = 0;
      end

end

