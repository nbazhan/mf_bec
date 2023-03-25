function init_v_box(obj)

      addprop(obj, 'direction');
      obj.direction = 'cartesian';
      if isfield(obj.params, 'direction')
          obj.direction = obj.params.direction;
      end

      addprop(obj, 'lim');
      if strcmp(obj.direction, 'cartesian')
          for j = 1 : size(obj.model.xyz, 2)
              obj.lim.(obj.model.xyz(j)) = [obj.model.grid.r.(obj.model.xyz(j))(1), obj.model.grid.r.(obj.model.xyz(j))(end)];
          end
          if isfield(obj.params, 'lim')
              axs = fieldnames(obj.params.lim);
    
              for i = 1 : length(axs)
                  obj.lim.(axs{i}) = obj.model.to_length_dim(obj.params.lim.(axs{i}));
              end
          end
      elseif strcmp(obj.direction, 'polar')
          obj.lim.r = [0, sqrt(obj.model.grid.r.x(end)^2 + obj.model.grid.r.y(end)^2)];
          if isfield(obj.params, 'lim')
              obj.lim.r = obj.model.to_length_dim(obj.params.lim);
          end
      end

end

