function [angr0, rl] = get_psi_1D_cyl(obj, Psi, r)
    if obj.grid.GPU == 1
        Psi = gather(Psi);
    end
    %r = obj.model.Vts(i).R;
    if obj.grid.N.x < 512
        Nphi = 450;
    else
        Nphi = 1000;
    end

    angr0 = zeros([1 Nphi]);
    v = zeros([1 Nphi]);
    
    if obj.D == 3
        Psi = squeeze(sum(Psi, 3));
    end
    if ndims(r) == 3
        r = r(:, :, 1);
    end
    
    [X,Y] = meshgrid(obj.grid.r.x, obj.grid.r.y);
    psirp=real(Psi);
    angrp=imag(Psi);
    
    for l=1 : Nphi
        X1=r*cos(2*pi*l/Nphi);
        Y1=r*sin(2*pi*l/Nphi);
        psirazb=interp2(X,Y, psirp, X1, Y1);
        angrrazb=interp2(X,Y,angrp, X1, Y1);
        angr0(l)= gather((psirazb(1, 1))+(1i*angrrazb(1, 1)));
        v(l)=abs(angr0(l))^2;
    end
   
    rl = linspace(0, 2*pi, Nphi);
end
  