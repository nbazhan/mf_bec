function save_ills_1d(obj, init_jvs, varargin)

obj.drs.ills_1d = [obj.folder, 'ills_1d/'];
if ~exist(obj.drs.ills_1d, 'dir')
    util.create_folder(obj.drs.ills_1d);
end

if isempty(varargin)
    si = 1;
    sf = length(obj.data.t);
elseif size(varargin, 2) == 1
    si = varargin{1};
    sf = length(obj.data.t);
elseif size(varargin, 2) == 2
    si = varargin{1};
    sf = varargin{2};
end


if isempty(init_jvs)
    obj.calc_jvs();
else
    obj.calc_jv_from_init(init_jvs);
end


for s = si : sf

    f = figure('visible', 'off', 'Position', [10 10 800 600]);
    p = uipanel('Parent', f, 'BorderType', 'none'); 

    psi = obj.load_psi(s);
    t = obj.model.to_time(obj.data.t(s))*1000;
    p.Title = ['t = ', num2str(t, '%0.1f'), ' ms']; 
    p.TitlePosition = 'centertop'; 
    p.FontSize = 24;


    if obj.model.D == 2
        ax = subplot(2, 2, 1, 'Parent', p);
        ax.Position = ax.Position - [0.03 0 0 0];
        psi_xy = sum(abs(psi).^2, 3);
        obj.plot_psi(psi_xy, 'xy')
        hold on
        c = colorbar('Location','eastoutside');
        c.Position = c.Position + [.025 0 0 0];
        title('$\mid \psi\mid^2$', 'Interpreter', 'latex', 'FontSize', 1.1*obj.plt.font)

        for i = 1 : size(obj.data.rs, 2)
            if i <= size(obj.plt.basic_colors_jv, 2)
                color =  obj.plt.basic_colors_jv{i};
            else
                color = 'black';
            end

            if ~isnan(obj.data.jvs(s, i))
                scatter(obj.data.rs(s, i)*cos(obj.data.jvs(s, i)), ....
                        obj.data.rs(s, i)*sin(obj.data.jvs(s, i)), 50, ...
                        'MarkerEdgeColor', color,...
                        'LineWidth', 0.7*obj.plt.width)
                hold on
            end
        end


        ax = subplot(2, 2, 2, 'Parent', p);
        ax.Position = ax.Position - [0.03 0 0 0];
        phase_xy = angle(psi);
        obj.plot_psi(phase_xy, 'xy')
        c = colorbar('Location','eastoutside');
        c.Position = c.Position + [.025 0 0 0];
        caxis([-pi, pi])
        title('$Arg(\psi)$', 'Interpreter', 'latex', 'FontSize', 1.1*obj.plt.font)
        for i = 1 : size(obj.data.rs, 2)
            if i <= size(obj.plt.basic_colors_jv, 2)
                color =  obj.plt.basic_colors_jv{i};
            else
                color = 'black';
            end

            if ~isnan(obj.data.jvs(s, i))
                scatter(obj.data.rs(s, i)*cos(obj.data.jvs(s, i)), ...
                        obj.data.rs(s, i)*sin(obj.data.jvs(s, i)), 50, ...
                        'MarkerEdgeColor', color,...
                        'LineWidth', 0.7*obj.plt.width)
                hold on
            end
        end


        ax = subplot(2, 2, [3, 4], 'Parent', p);
        %ax.Position = ax.Position + [0.03 0 0 0];
        obj.plot_1d(s)

        saveas(f,[obj.drs.ills_1d, 'ill' num2str(s) '.png']);
        disp([num2str(s), ':', num2str(sf),' saved illustration'])
    end
end
end