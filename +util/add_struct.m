function s1 = add_struct(s1, s2)
f = fieldnames(s2);
for i = 1:length(f)
    s1.(f{i}) = s2.(f{i});
end
end

