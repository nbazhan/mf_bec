function [v2, rl] = get_v_1D_cyl(obj, V, r)
    if obj.grid.GPU == 1
        V = gather(V);
    end
    %r = obj.model.Vts(i).R;
    if obj.grid.N.x < 512
        Nphi = 450;
    else
        Nphi = 1000;
    end

    v2 = zeros([1 Nphi]);
    if obj.D == 3
        V = squeeze(sum(V, 3));
    end
    if ndims(r) == 3
        r = r(:, :, 1);
    end
    
    [X,Y] = meshgrid(obj.grid.r.x, obj.grid.r.y);
    
    for l=1 : Nphi
        X1=r*cos(2*pi*l/Nphi);
        Y1=r*sin(2*pi*l/Nphi);
        w=interp2(X,Y, V, X1, Y1);
        v2(l)=w(l);
    end
   
    rl = linspace(0, 2*pi, Nphi);
end
  