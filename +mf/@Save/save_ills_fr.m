function save_ills_fr(obj, varargin)

if ~isfield(obj.drs, 'ills_fr')
    obj.drs.ills_fr = [obj.folder, 'ills_fr/'];
    if ~exist(obj.drs.ills_fr, 'dir')
        util.create_folder(obj.drs.ills_fr);
    end
end


if isempty(varargin)
    si = 1;
    sf = length(obj.data.t);
elseif size(varargin, 2) == 1
    si = 1;
    sf = varargin{1};
elseif size(varargin, 2) == 2
    si = varargin{1};
    sf = varargin{2};
end

for s = si:sf

    f = figure('visible', 'off', 'Position', [10 10 1400 600]);
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
        c = colorbar('Location','eastoutside');
        c.Position = c.Position + [.025 0 0 0];


        subplot(2, 3, 4, 'Parent', p);
        phase_xy = angle(psi);
        obj.plot_psi(phase_xy, 'xy')
        c = colorbar('Location','eastoutside');
        c.Position = c.Position + [.025 0 0 0];
        caxis([-pi, pi])


        subplot(2, 3, [2, 3], 'Parent', p);
        obj.plot_fr(s)


        subplot(2, 3, [5, 6], 'Parent', p);
        obj.plot_evolution(s)
    
    saveas(f,[obj.drs.ills_fr, 'ill' num2str(s) '.png']);
    disp([num2str(s), ':', num2str(sf),' saved illustration'])
end
end
end