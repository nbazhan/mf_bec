function check(test, params, varargin)
if test
    fields = fieldnames(params);
    values = struct2cell(params);
    for i = 1 : size(fields, 1)
        value = values{i};
        field = fields{i};
        if length(value) > 1
           disp([field, ': ', num2str(max(value(:))), ...
                             ', ', num2str(sum(value(:)))])
        else
           disp([field, ': ', num2str(value)])
        end
    end
    if length(varargin) == 1
        disp(repmat(varargin{1}, [1, 40]))
    end
end
end