function save_n_difference(obj)
% saving picture for each dynamics iteration

if ~isfield(obj.drs, 'graphs')
    obj.drs.graphs = [obj.folder, 'graphs/'];
    if ~exist(obj.drs.graphs, 'dir')
        util.create_folder(obj.drs.graphs);
    end
end

sf = length(obj.data.t);
n1 = zeros([1 sf]);
n2 = zeros([1 sf]);
for s = 1:sf
    t = obj.data.t(s);
    psi = obj.load_psi(s);
    
    psi1 = obj.model.get_ring_psi(psi, 1, t);
    psi2 = obj.model.get_ring_psi(psi, 2, t);
    
    n1(s) = gather(obj.model.get_n(psi1));
    n2(s) = gather(obj.model.get_n(psi2));
end
dn_mean = mean(n1 - n2)/mean(n1 + n2);
dn_std = std(n1 - n2)/mean(n1 + n2);

f = figure('visible', 'off', 'Position', [10 10 900 350]);
p = uipanel('Parent', f, 'BorderType', 'none'); 
p.TitlePosition = 'centertop'; 
p.Title = ['dN/N = ', num2str(dn_mean, '%0.2g'), ' +- ', num2str(dn_std, '%0.1g')]; 
p.FontSize = 24;


subplot(1, 2, 1, 'Parent', p);
ts = obj.model.to_time(obj.data.t)*1000;
plot(ts, n1/obj.model.config.N, 'LineWidth',obj.plt.width)
hold on 

plot(ts, n2/obj.model.config.N, 'LineWidth',obj.plt.width)
hold on

xlabel('t, ms')
ylabel('$N_i/N$', 'Interpreter','latex')
legend({'$N_1$', '$N_2$'}, 'Interpreter','latex', 'FontSize', obj.plt.font)


subplot(1, 2, 2, 'Parent', p);
psi = obj.load_psi(1);

if obj.model.D == 3 && obj.model.Vs.toroidal(1).c.z ~= obj.model.Vs.toroidal(2).c.z
    psi1 = obj.model.get_psiz(psi);
    v = obj.model.get_vz(0);
    plot(obj.model.grid.r.z, v, 'LineWidth', obj.plt.width);
    hold on
    ylabel('v')

    yyaxis right
    plot(obj.model.grid.r.z, abs(psi1).^2, 'LineWidth', obj.plt.width);
    hold on;
    ylabel('\mid \psi \mid.^2', 'Interpreter','latex')

    xlabel('z')
    z1 = obj.model.Vs.toroidal(1).c.z;
    z2 = obj.model.Vs.toroidal(2).c.z;

    z0 = (z1 + z2)/2;
    dz = abs(z1 - z2);
    xlim([z0 - 1.5*dz, z0 + 1.5*dz]);
else
    psi1 = obj.model.get_psix(psi);
    v = obj.model.get_vx(0);
    plot(obj.model.grid.r.x, v, 'LineWidth', obj.plt.width);
    hold on
    ylabel('v')

    yyaxis right
    plot(obj.model.grid.r.x, abs(psi1).^2, 'LineWidth', obj.plt.width);
    hold on;
    ylabel('$\mid \psi \mid^2$', 'Interpreter','latex')

    xlabel('x')
    x1 = obj.model.Vs.toroidal(1).R.x;
    x2 = obj.model.Vs.toroidal(2).R.x;

    x0 = (x1 + x2)/2;
    dx = abs(x1 - x2);
    xlim([x0 - 1.5*dx, x0 + 1.5*dx])
end
legend({'$V$', '$\mid \psi\mid^2$'}, 'Interpreter','latex', 'FontSize', obj.plt.font)
title('t = 0 s')

saveas(f,[obj.drs.graphs, 'n_oscillations.png']);
end