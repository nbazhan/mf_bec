function show_psi(obj, Psi)
% show potential images from 2 sides

Psi2 = abs(Psi).^2;
if obj.D == 2
    Psixy = Psi;
    Psix2 = sum(Psi2, 1);
elseif obj.D == 3
    Psixy = Psi(:, :, obj.grid.N.z/2);
    Psixz = squeeze(Psi(:, obj.grid.N.y/2, :)).';
    Psix2 = sum(Psi2, [3 1]);
    Psiz2 = squeeze(sum(Psi2, [1 2]));
end

figure('Position', [130 180 1000 450])

subplot(obj.D - 1, 3, 1)
imagesc(obj.grid.r.x, obj.grid.r.y, abs(Psixy).^2)
axis square;
xlabel('x, $l_r$', 'interpreter', 'latex')
ylabel('y, $l_r$', 'interpreter', 'latex')
c = colorbar;
ylabel(c, '$\mid \Psi \mid^2$, $\hbar \omega_r$', 'interpreter', 'latex')


subplot(obj.D - 1, 3, 2)
imagesc(obj.grid.r.x, obj.grid.r.y, angle(Psixy))
axis square;
xlabel('x, $l_r$', 'interpreter', 'latex')
ylabel('y, $l_r$', 'interpreter', 'latex')
c = colorbar;
clim([-pi pi])


subplot(obj.D - 1, 3, 3)
plot(obj.grid.r.x, Psix2)
axis square;
xlabel('x, $l_r$', 'interpreter', 'latex')
ylabel('n', 'interpreter', 'latex')
          
if obj.D == 3
    subplot(obj.D - 1, 3, 4)
    imagesc(obj.grid.r.x, obj.grid.r.z, abs(Psixz).^2)
    axis square;
    xlabel('x, $l_r$', 'interpreter', 'latex')
    ylabel('z, $l_r$', 'interpreter', 'latex')
    c = colorbar;
    ylabel(c, '$\mid \Psi \mid^2$, $\hbar \omega_r$', 'interpreter', 'latex')


    subplot(obj.D - 1, 3, 5)
    imagesc(obj.grid.r.x, obj.grid.r.z, angle(Psixz))
    axis square;
    xlabel('x, $l_r$', 'interpreter', 'latex')
    ylabel('z, $l_r$', 'interpreter', 'latex')
    c = colorbar;
    clim([-pi pi])
    
    
    subplot(obj.D - 1, 3,  6)
    plot(Psiz2, obj.grid.r.z)
    axis square;
    ylabel('z, $l_r$', 'interpreter', 'latex')
    xlabel('n', 'interpreter', 'latex')
end

shg
end