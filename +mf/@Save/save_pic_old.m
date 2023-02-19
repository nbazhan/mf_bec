function save_pic_old(obj, s, t, Psi)

if ~isfield(obj.drs, 'pictures')
    obj.drs.pictures = [obj.folder, 'pictures/'];
    util.create_folder(obj.drs.pictures);
end

n = obj.model.D - 1;
f = figure('Position', [300 300 800 300*n], 'visible', 'off');
p = uipanel('Parent', f, 'BorderType', 'none'); 
p.Title = ['t = ', num2str(obj.model.to_time(t), '%0.3f'), ' s']; 
p.TitlePosition = 'centertop'; 
p.FontSize = 24;

if obj.model.D == 2
    PsiXY = abs(Psi).^2;
    PhaseXY = angle(Psi);
elseif obj.model.D == 3
    PsiXY = sum(abs(Psi).^2, 3);
    PhaseXY = angle(Psi(:, :, obj.model.grid.N.z/2));
    PsiXZ = squeeze(sum(abs(Psi).^2, 2)).';
    PhaseXZ = squeeze(angle(Psi(:, obj.model.grid.N.y/2, :))).';
end


subplot(n, 2, 1, 'Parent', p);
imagesc(obj.model.grid.r.x, obj.model.grid.r.y, PsiXY);
axis image;
ylabel('y, $\mu m$', 'interpreter', 'latex');
xlabel('x, $\mu m$', 'interpreter', 'latex');
set(gca,'YDir','normal')
c = colorbar;
c.Position = c.Position + [0.04 0.02 0 0];

subplot(n, 2, 2, 'Parent',p);
imagesc(obj.model.grid.r.x, obj.model.grid.r.y, PhaseXY);
axis image;
ylabel('y, $\mu m$', 'interpreter', 'latex');
xlabel('x, $\mu m$', 'interpreter', 'latex');
set(gca,'YDir','normal')
c = colorbar;
c.Position = c.Position + [0.04 0.02 0 0];

if obj.model.D == 3
    subplot(n, 2, 3, 'Parent',p);
    imagesc(obj.model.grid.r.x, obj.model.grid.r.z, PsiXZ);
    axis image;
    ylabel('z, $\mu m$', 'interpreter', 'latex');
    xlabel('x, $\mu m$', 'interpreter', 'latex');
    set(gca,'YDir','normal')

    subplot(n, 2, 4, 'Parent',p);
    imagesc(obj.model.grid.r.x, obj.model.grid.r.z, PhaseXZ);
    axis image;
    ylabel('z, $\mu m$', 'interpreter', 'latex');
    xlabel('x, $\mu m$', 'interpreter', 'latex');
    set(gca,'YDir','normal')
end
saveas(f,[obj.drs.pictures, 'pic' num2str(s) '.png']);
clear f;

end