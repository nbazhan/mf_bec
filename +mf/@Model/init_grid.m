function grid = init_grid(obj, init_grid)

% init space grid
L = obj.to_length_dim(init_grid.L);
for i = 1 : size(obj.xyz, 2)
    grid.L.(obj.xyz(i)) = L(i);
    grid.N.(obj.xyz(i)) = init_grid.N(i);
    grid.r.(obj.xyz(i)) = linspace(-L(i)/2, L(i)/2, init_grid.N(i));
    grid.h.(obj.xyz(i)) = grid.r.(obj.xyz(i))(2) - grid.r.(obj.xyz(i))(1); 

    % init momentum grid (works only for even N)
    grid.k.(obj.xyz(i)) =  (2*pi/(L(i) + grid.h.(obj.xyz(i))))*[(0 : init_grid.N(i)/2) -(init_grid.N(i)/2 - 1 : -1 : 1)];
    grid.kh.(obj.xyz(i)) =  grid.k.(obj.xyz(i))(2) - grid.k.(obj.xyz(i))(1);
end

if obj.D == 1
    grid.dV = grid.h.x;
    grid.X = grid.r.x;

    grid.kdV = grid.kh.x;
    grid.KX = grid.k.x;
    grid.kk = (grid.KX.^2)/2; 
    
elseif obj.D == 2
    grid.dV = grid.h.x * grid.h.y;
    [grid.X, grid.Y] = meshgrid(grid.r.x, grid.r.y);

    grid.kdV = grid.kh.x * grid.kh.y;
    [grid.KX, grid.KY] = meshgrid(grid.k.x , grid.k.y);
    grid.kk = (grid.KX.^2 + grid.KY.^2)/2; 
elseif obj.D == 3
    grid.dV = grid.h.x * grid.h.y * grid.h.z;
    [grid.X, grid.Y, grid.Z] = meshgrid(grid.r.x, grid.r.y, grid.r.z);

    grid.kdV = grid.kh.x * grid.kh.y * grid.kh.z;
    [grid.KX, grid.KY, grid.KZ] = meshgrid(grid.k.x , grid.k.y, grid.k.z);
    grid.kk = (grid.KX.^2 + grid.KY.^2 + grid.KZ.^2)/2; 
end

if init_grid.GPU
    XYZ = upper(obj.xyz);
    for i = 1 : obj.D
        grid.(XYZ(i)) = gpuArray(grid.(XYZ(i)));
    end
    grid.kk = gpuArray(grid.kk); 
end


end