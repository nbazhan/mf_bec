function save_ills_jv(obj, fit_n, init_jvs)

if ~isfield(obj.drs, 'ills_jv')
    obj.drs.ills_jv = [obj.folder, 'ills_jv/'];
    if ~exist(obj.drs.ills_jv, 'dir')
        util.create_folder(obj.drs.ills_jv);
    end
end
             

sf = length(obj.data.t);

if isempty(init_jvs)
    obj.calc_jvs();
else
    obj.calc_jv_from_init(init_jvs);
end

for s = 1:sf
    f = figure('visible', 'off', 'Position', [10 10 1400 800]);
    p = uipanel('Parent', f, 'BorderType', 'none'); 

    psi = obj.load_psi(s);
    t = obj.model.to_time(obj.data.t(s))*1000;
    p.Title = ['t = ', num2str(t, '%0.1f'), ' ms']; 
    p.TitlePosition = 'centertop'; 
    p.FontSize = 24;

    if obj.model.D == 2
        subplot(2, 3, 1, 'Parent', p);
        psi_xy = sum(abs(psi).^2, 3);
        obj.plot_psi(psi_xy, 'xy')
        for i = 1 : size(obj.data.rs, 2)
            if i <= size(obj.plt.basic_colors_jv, 2)
                color =  obj.plt.basic_colors_jv{i};
            else
                color = 'black';
            end
            scatter(obj.data.rs(s, i)*cos(obj.data.jvs(s, i)), ....
                    obj.data.rs(s, i)*sin(obj.data.jvs(s, i)), 50, ...
                    'MarkerEdgeColor', color,...
                    'LineWidth', 0.7*obj.plt.width)
            hold on
        end
        c = colorbar('Location','eastoutside');
        c.Position = c.Position + [.025 0 0 0];


        subplot(2, 3, 4, 'Parent', p);
        phase_xy = angle(psi);
        obj.plot_psi(phase_xy, 'xy')
        for i = 1 : size(obj.data.rs, 2)
            if i <= size(obj.plt.basic_colors_jv, 2)
                color =  obj.plt.basic_colors_jv{i};
            else
                color = 'black';
            end
            scatter(obj.data.rs(s, i)*cos(obj.data.jvs(s, i)), ...
                    obj.data.rs(s, i)*sin(obj.data.jvs(s, i)), 50, ...
                    'MarkerEdgeColor', color,...
                    'LineWidth', 0.7*obj.plt.width)
            hold on
        end
        c = colorbar('Location','eastoutside');
        c.Position = c.Position + [.025 0 0 0];
        caxis([-pi, pi])


        subplot(2, 3, [2, 3], 'Parent', p);
        obj.plot_jv(s, fit_n)


        subplot(2, 3, [5, 6], 'Parent', p);
        obj.plot_evolution(s)
    
    saveas(f,[obj.drs.ills_jv, 'ill' num2str(s) '.png']);
    disp([num2str(s), ':', num2str(sf),' saved illustration'])
    end
end