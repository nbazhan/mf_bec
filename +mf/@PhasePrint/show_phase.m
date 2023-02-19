function show_phase(obj, phase)
% show potential images from 2 sides

if obj.model.D == 2
    phase_xy = phase;
elseif obj.model.D == 3
    phase_xy = phase(:, :, obj.model.grid.N.z/2);
    phase_xz = squeeze(phase(:, obj.grid.N.y/2, :)).';
end

figure('Position', [130 180 1000 450])
if obj.model.D == 3
    subplot(1, 2, 1)
end
imagesc(obj.model.grid.r.x, obj.model.grid.r.y, phase_xy)
axis square;
xlabel('x, $l_r$', 'interpreter', 'latex')
ylabel('y, $l_r$', 'interpreter', 'latex')
set(gca,'YDir','normal')
c = colorbar;
%clim([0 2*pi])
ylabel(c, '$\phi$', 'interpreter', 'latex')


if obj.model.D == 3
    subplot(1, 2, 2)
    imagesc(obj.model.grid.r.x, obj.model.grid.r.y, phase_xz)
    axis square;
    xlabel('x, $l_r$', 'interpreter', 'latex')
    ylabel('y, $l_r$', 'interpreter', 'latex')
    set(gca,'YDir','normal')
    c = colorbar;
    clim([0 2*pi])
end

shg
end