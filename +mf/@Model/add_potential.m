function add_potential(obj, params)

params.model = obj;
newV = mf.Potential(params);


if ~isfield(obj.Vs, params.typ)
    obj.Vs.(params.typ) = [];
end

% place toroidal potential in order of increasing radius
if ~strcmp(params.typ, 'toroidal')
    obj.Vs.(params.typ) = [obj.Vs.(params.typ) newV];
else
    if isempty(obj.Vs.toroidal)
        obj.Vs.(params.typ) = [obj.Vs.(params.typ) newV];
    else

        newVs = [];
        newAdded = 0;
    
        for i = 1:length(obj.Vs.toroidal) + 1
            if i == length(obj.Vs.toroidal) + 1 && ~newAdded
                newVs = [newVs newV];
            else
                V = obj.Vs.toroidal(i - newAdded);
               
    
                if ~newAdded
                    if obj.D == 3 && (V.c.z < newV.c.z)
                        newVs = [newVs newV];
                        newAdded = 1;
                    elseif (min(V.R.x, V.R.y) > min(newV.R.x, newV.R.y) && ~newAdded) 
                        newVs = [newVs newV];
                        newAdded = 1;
                    else
                        newVs = [newVs V];
                    end
                else
                    newVs = [newVs V];
                end
            end
        end
        obj.Vs.toroidal = newVs;
    end

    obj.rings.n = obj.rings.n + 1;
    if obj.D == 3
        obj.rings.zs = sort(unique([obj.rings.zs, newV.c.z]), 'desc');
        obj.rings.nz = size(obj.rings.zs, 2);
    end
end



end

