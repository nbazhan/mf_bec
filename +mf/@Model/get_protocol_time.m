function [t1, t2, U1, U2] = get_protocol_time(obj)
% get U amplitudes of all potentials
t1 = 0;
t2 = 0;
U1 = 0;
U2 = 0;

fields = fieldnames(obj.Vs);
for i = 1 : length(fields)
    vs = obj.Vs.(fields{i});
    for j = 1 : size(vs, 2)
        if strcmp(fields{i}, 'toroidal')
            new_t1 = min(vs(j).U.t(1), vs(j).tof(1));
            new_t2 = max(vs(j).U.t(end), vs(j).tof(end));
        else
            new_t1 = vs(j).U.t(1);
            new_t2 = vs(j).U.t(end);
        end
        if new_t1 < t1
            t1 = new_t1;
        end
        if new_t2 > t2
            t2 = new_t2;
        end
        if vs(j).U.max > U2
            U2 = vs(j).U.max;
        end
        if vs(j).U.max < U1
            U1 = vs(j).U.max;
        end
    end
end
end

