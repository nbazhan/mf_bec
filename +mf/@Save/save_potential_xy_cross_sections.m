function save_potential_xy_cross_sections(obj, s)

if ~isfield(obj.drs, 'graphs')
    obj.drs.graphs = [obj.folder, 'graphs/'];
    if ~exist(obj.drs.graphs, 'dir')
        util.create_folder(obj.drs.graphs);
    end
end

t = obj.data.t(s);
psi = obj.load_psi(s);

psix = obj.model.get_xyz_cut(psi, 'x');
psix2 = abs(psix).^2;

psiy = obj.model.get_xyz_cut(psi, 'y');
psiy2 = abs(psiy).^2;

vx = obj.model.get_xyz_cut(obj.model.get_v(t), 'x');
vy = obj.model.get_xyz_cut(obj.model.get_v(t), 'y');
    
mean_x = 0;
mean_y = 0;
if isfield(obj.model.Vs, 'toroidal')
    for i = 1 : size(obj.model.Vs.toroidal, 2)
        mean_x = mean_x + obj.model.Vs.toroidal(i).R.x;
        mean_y = mean_y + obj.model.Vs.toroidal(i).R.y;
    end
    mean_x = mean_x/size(obj.model.Vs.toroidal, 2);
    mean_y = mean_y/size(obj.model.Vs.toroidal, 2);
end

% choosing random dx, dy
dx = 8;
dy = 8;


f = figure('visible', 'off', 'Position', [10 10 900 350]);
p = uipanel('Parent', f, 'BorderType', 'none'); 
p.TitlePosition = 'centertop'; 
p.Title = ['t = ', num2str(obj.model.to_time(t), '%0.2g'), ' s']; 
p.FontSize = 24;


subplot(1, 2, 1, 'Parent', p);
plot(obj.model.grid.r.x, vx, 'LineWidth', obj.plt.width);
hold on
ylabel('v')

yyaxis right
plot(obj.model.grid.r.x, psix2, 'LineWidth', obj.plt.width);
hold on;
ylabel('$\mid \psi \mid^2$', 'Interpreter','latex')
xlabel('x')
xlim([mean_x - dx, mean_x + dx])
ylim([min(psix2), max(psix2) + 0.4*abs(max(psix2))])
legend({'$V$', '$\mid \psi(x, 0)\mid^2$'}, 'Interpreter','latex', 'FontSize', obj.plt.font)


subplot(1, 2, 2, 'Parent', p);
plot(obj.model.grid.r.y, vy, 'LineWidth', obj.plt.width);
hold on
ylabel('v')

yyaxis right
plot(obj.model.grid.r.y, psiy2, 'LineWidth', obj.plt.width);
hold on;
ylabel('$\mid \psi \mid^2$', 'Interpreter','latex')
xlabel('x')
xlim([mean_y - dy, mean_y + dy])
ylim([min(psiy2), max(psiy2) + 0.4*abs(max(psiy2))])
legend({'$V$', '$\mid \psi(0, y)\mid^2$'}, 'Interpreter','latex', 'FontSize', obj.plt.font)


saveas(f,[obj.drs.graphs, 'xy_cross_sections_s=', num2str(s), '.png']);
end