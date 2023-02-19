function init_v_box(obj)

      addprop(obj, 'lim');
      for j = 1 : size(obj.model.xyz, 2)
          obj.lim.(obj.model.xyz(j)) = [obj.model.grid.r.(obj.model.xyz(j))(1), obj.model.grid.r.(obj.model.xyz(j))(end)];
      end
      if isfield(obj.params, 'lim')
          axs = fieldnames(obj.params.lim);

          for i = 1 : length(axs)
              obj.lim.(axs{i}) = obj.model.to_length_dim(obj.params.lim.(axs{i}));
          end
      end

end

