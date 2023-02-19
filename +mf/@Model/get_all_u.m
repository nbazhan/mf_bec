function U = get_all_u(obj, t)
% get U amplitudes of all potentials
U = struct();

fields = fieldnames(obj.Vs);
for i = 1 : length(fields)
    vs = obj.Vs.(fields{i});
    U.(fields{i}) = zeros(size(vs));
    for j = 1 : size(vs, 2)
        U.(fields{i})(j) = vs(j).get_u(t);
    end
end
end

