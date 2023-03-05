function save_ills(obj)

if ~isfield(obj.drs, 'ills')
    obj.drs.ills = [obj.folder, 'ills/'];
    if ~exist(obj.drs.ills, 'dir')
        util.create_folder(obj.drs.ills);
    end
end
             

sf = length(obj.data.t);
for s = 1:sf

    f = figure('visible', 'off', 'Position', [10 10 700 600]);
    p = uipanel('Parent', f, 'BorderType', 'none'); 

    psi = obj.load_psi(s);
    t = obj.model.to_time(obj.data.t(s))*1000;
    p.Title = ['t = ', num2str(t, '%0.1f'), ' ms']; 
    p.TitlePosition = 'centertop'; 
    p.FontSize = 24;


    subplot(2, 2, 1, 'Parent', p);
    psi_xy = sum(abs(psi).^2, 3);
    obj.plot_psi(psi_xy, 'xy')
    c = colorbar('Location','eastoutside');
    c.Position = c.Position + [.05 0 0 0];


    subplot(2, 2, 2, 'Parent', p);
    if obj.model.D == 2
        phase_xy = angle(psi);
    elseif obj.model.D == 3 
        phase_xy = angle(psi(:, :, obj.model.grid.N.z/2));
    end
    obj.plot_psi(phase_xy, 'xy');
    c = colorbar('Location','eastoutside');
    c.Position = c.Position + [.05 0 0 0];
    caxis([-pi, pi])


    subplot(2, 2, [3, 4], 'Parent', p);
    % plots graph with time evolution of mu, l, us
    obj.plot_evolution(s)
    
    
    saveas(f,[obj.drs.ills, 'ill' num2str(s) '.png']);
    disp([num2str(s), ':', num2str(sf),' saved illustration'])
end

end