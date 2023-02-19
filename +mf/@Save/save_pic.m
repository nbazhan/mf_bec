function save_pic(obj, s, t, psi)
% saving picture for each dynamics iteration

if ~isfield(obj.drs, 'pictures')
    obj.drs.pictures = [obj.folder, 'pictures/'];
    if ~exist(obj.drs.pictures, 'dir')
        util.create_folder(obj.drs.pictures);
    end
end

if obj.model.D == 1
    f = figure('Position', [300 300 800 400], 'visible', 'off');
    p = uipanel('Parent', f, 'BorderType', 'none'); 

    v = obj.model.get_v(t);
    if isfield(obj.model.Vs, 'box')
        delta = 0.15*abs(obj.model.Vs.box.U.max);
        if obj.model.Vs.box.U.max >= 0
            ylims = [-delta, obj.model.Vs.box.U.max + delta];
        else
            ylims = [obj.model.Vs.box.U.max - delta, delta];
        end
    end

    subplot(2, 1, 1, 'Parent', p);
    psi_xy = abs(psi).^2;
    plot(obj.model.grid.r.x, psi_xy - mean(psi_xy), 'LineWidth', obj.plt.width);
    hold on;
    ylabel(['$\mid \Psi \mid^2$'], 'interpreter', 'latex');

    delta_psi = abs(max(psi_xy - mean(psi_xy)));
    %ylim([-1.25*delta_psi, 1.25*delta_psi])

    yyaxis right
    plot(obj.model.grid.r.x, v, 'LineWidth', 0.8*obj.plt.width);
    hold on;
    ylabel(['$U$'], 'interpreter', 'latex');
    ylim(ylims)

    xlabel(['$x$, $\mu m$'], 'interpreter', 'latex');
    set(gca,'FontSize', 0.9*obj.plt.font)
    

    subplot(2, 1, 2, 'Parent', p);
    phase_xy = angle(psi);
    plot(obj.model.grid.r.x, phase_xy, 'LineWidth', 0.8*obj.plt.width);
    hold on;
    ylabel(['Arg($\Psi$)'], 'interpreter', 'latex');
    ylim([-1.25*pi, 1.25*pi])

    yyaxis right
    plot(obj.model.grid.r.x, v, 'LineWidth', obj.plt.width);
    hold on;
    ylabel(['$U$'], 'interpreter', 'latex');
    ylim(ylims)
    
    xlabel(['$x$, $\mu m$'], 'interpreter', 'latex');
    set(gca,'FontSize', 0.9*obj.plt.font)


% choose specific design for sustem in one plane
elseif obj.model.D == 2 || obj.model.rings.nz == 1
    f = figure('Position', [300 300 800 300*(obj.model.D - 1)], 'visible', 'off');
    p = uipanel('Parent', f, 'BorderType', 'none'); 

    subplot(obj.model.D - 1, 2, 1, 'Parent', p);
    psi_xy = sum(abs(psi).^2, 3);

    obj.plot_psi(psi_xy, 'xy');
    c = colorbar;
    c.Position = c.Position + [0.04 0.02 0 0];
    

    subplot(obj.model.D - 1, 2, 2, 'Parent',p);
    if obj.model.D == 2
        phase_xy = angle(psi);
    elseif obj.model.D == 3 && ~isempty(obj.model.rings.zs)
        phase_xy = angle(psi(:, :, obj.model.to_n(obj.model.rings.zs(1), 'z')));
    else
        phase_xy = angle(psi(:, :, obj.model.grid.N.z/2));
    end
    obj.plot_psi(phase_xy, 'xy');
    c = colorbar;
    c.Position = c.Position + [0.04 0.02 0 0];

    if obj.model.D == 3

        subplot(obj.model.D - 1, 2, 3, 'Parent',p);
        psi_xz = squeeze(sum(abs(psi).^2, 2)).';
        obj.plot_psi(psi_xz, 'xz');%, clims);
    
        subplot(obj.model.D - 1, 2, 4, 'Parent',p);
        phase_xz = squeeze(angle(psi(:, obj.model.grid.N.y/2, :))).';
        obj.plot_psi(phase_xz, 'xz');
    end



elseif obj.model.D == 3 && obj.model.rings.nz > 1
    f = figure('Position', [860, 50, 460, 720], 'visible', 'off');
    p = uipanel('Parent', f, 'BorderType', 'none'); 

    subplot(obj.model.rings.nz + 1, 2, 2*(obj.model.rings.nz + 1) - 1, 'Parent', p);
    psi_xz = squeeze(sum(abs(psi).^2, 2)).';
    clims = [min(psi_xz(:)) max(psi_xz(:))];
    obj.plot_psi(psi_xz, 'xz', clims);
    axis square;
    c = colorbar('southoutside');
    c.Position = c.Position + [-0.075 -0.13 0.17 0.012];


    subplot(obj.model.rings.nz + 1, 2, 2*(obj.model.rings.nz + 1), 'Parent', p);
    phase_xz = squeeze(angle(psi(:, obj.model.grid.N.y/2, :))).';
    obj.plot_psi(phase_xz, 'xz', clims);
    axis square;
    c = colorbar('southoutside');
    c.Position = c.Position + [-0.075 -0.13 0.17 0.012];
    caxis([-pi, pi]); 

    for i = 1 : obj.model.rings.nz

        subplot(obj.model.rings.nz + 1, 2, 2*i - 1, 'Parent', p);
        psi_xy = sum(abs(psi.*obj.model.get_z_mask(i)).^2, 3);
        obj.plot_psi(psi_xy, 'xy', clims);


        subplot(obj.model.rings.nz + 1, 2, 2*i, 'Parent', p);
        phase_xy = angle(psi(:, :, obj.model.to_nz(obj.model.rings.zs(i))));
        obj.plot_psi(phase_xy, 'xy');
    end

end

p.Title = ['t = ', num2str(obj.model.to_time(t), '%0.3f'), ' s']; 
p.TitlePosition = 'centertop'; 
%p.TitlePosition = p.TitlePosition  + [0 -0.1];
p.FontSize = 24;

saveas(f,[obj.drs.pictures, 'pic' num2str(s) '.png']);
clear f;
%shg

end