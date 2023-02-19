function save_ills_ro_2(obj, ks, varargin)

if ~isfield(obj.drs, 'ills_ro_2')
    obj.drs.ills_ro_2 = [obj.folder, 'ills_ro_2/'];
    if ~exist(obj.drs.ills_ro_2, 'dir')
        util.create_folder(obj.drs.ills_ro_2);
    end
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

unique_ks = sort(unique(abs(ks)), 'descend');
for i = 1 : size(unique_ks, 2)
    ks(2*i - 1) = unique_ks(i);
    if unique_ks(i) ~= 0
        ks(2*i) = -unique_ks(i);
    end
end

obj.calc_ro(ks);

for s = si:sf

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
        c = colorbar('Location','eastoutside');
        c.Position = c.Position + [.025 0 0 0];
        title('$\mid \psi\mid^2$', 'Interpreter', 'latex', 'FontSize', 1.1*obj.plt.font)


        ax = subplot(2, 2, 2, 'Parent', p);
        ax.Position = ax.Position - [0.03 0 0 0];
        phase_xy = angle(psi);
        obj.plot_psi(phase_xy, 'xy')
        c = colorbar('Location','eastoutside');
        c.Position = c.Position + [.025 0 0 0];
        caxis([-pi, pi])
        title('$Arg(\psi)$', 'Interpreter', 'latex', 'FontSize', 1.1*obj.plt.font)
        

        ax = subplot(2, 2, [3, 4], 'Parent', p);
        ax.Position = ax.Position + [0.03 0 0 0];
        obj.plot_ro(s, ks)
        xlabel('t, ms', 'interpreter', 'latex', ...
                'FontSize', obj.plt.font);

        saveas(f,[obj.drs.ills_ro_2, 'ill' num2str(s) '.png']);
        disp([num2str(s), ':', num2str(sf),' saved illustration'])
    end
end
end