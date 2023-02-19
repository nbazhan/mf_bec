function save_ills_ro(obj, ks, varargin)

if ~isfield(obj.drs, 'ills_ro')
    obj.drs.ills_ro = [obj.folder, 'ills_ro/'];
    if ~exist(obj.drs.ills_ro, 'dir')
        util.create_folder(obj.drs.ills_ro);
    end
end


if isempty(varargin)
    si = 1;
    sf = length(obj.data.t);
elseif size(varargin, 2) == 1
    si = varargin{1};
    sf = length(obj.data.t);
elseif size(varargin, 2) == 2
    disp('YES!')
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

    f = figure('visible', 'off', 'Position', [10 10 1400 600]);
    p = uipanel('Parent', f, 'BorderType', 'none'); 

    psi = obj.load_psi(s);
    t = obj.model.to_time(obj.data.t(s))*1000;
    p.Title = ['t = ', num2str(t, '%0.1f'), ' ms']; 
    p.TitlePosition = 'centertop'; 
    p.FontSize = 24;


    if obj.model.D == 2
        ax = subplot(2, 4, 1, 'Parent', p);
        ax.Position = ax.Position - [0.03 0 0 0];
        psi_xy = sum(abs(psi).^2, 3);
        obj.plot_psi(psi_xy, 'xy')
        c = colorbar('Location','eastoutside');
        c.Position = c.Position + [.025 0 0 0];


        ax = subplot(2, 4, 2, 'Parent', p);
        ax.Position = ax.Position - [0.03 0 0 0];
        phase_xy = angle(psi);
        obj.plot_psi(phase_xy, 'xy')
        c = colorbar('Location','eastoutside');
        c.Position = c.Position + [.025 0 0 0];
        caxis([-pi, pi])


        ax = subplot(2, 4, [3, 4], 'Parent', p);
        ax.Position = ax.Position + [0.03 0 0 0];
        obj.plot_ro(s, ks)


        ax = subplot(2, 4, [5, 6], 'Parent', p);
        ax.Position = ax.Position - [0.03 0 0 0];
        obj.plot_circle_psi(s)


        ax = subplot(2, 4, [7, 8], 'Parent', p);
        ax.Position = ax.Position + [0.03 0 0 0];
        obj.plot_evolution(s)
    
        saveas(f,[obj.drs.ills_ro, 'ill' num2str(s) '.png']);
        disp([num2str(s), ':', num2str(sf),' saved illustration'])
    end
end
end