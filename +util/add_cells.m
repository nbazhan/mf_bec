function cel = add_cells(cel, cel2)
for i = 1 : size(cel2, 2)
    cel{end + 1} = cel2{i};
end
end

