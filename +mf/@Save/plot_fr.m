function plot_fr(obj, s)

leg = {};

ylim_max = 0;
ylim_min = 0;


for i = 1 : obj.model.rings.n
    t = obj.data.t(s);
    psi = obj.load_psi(s);
    psi_i = obj.model.get_ring_psi(psi, i, t);
    psi_1 = obj.model.get_psi_1D_cyl(psi_i, obj.model.Vs.toroidal(i).get_r(t));
    [psi_f, kf] = obj.model.get_fft_psi(psi_1);

    plot(kf.x, abs(psi_f).^2, 'Color', obj.plt.basic_colors{i}, 'LineWidth', obj.plt.width);
    hold on
    leg{end + 1} = ['$\mid fft(\psi)_' num2str(i) '\mid^2$'];
    ylim_max = max(ylim_max, max(abs(psi_f(:)).^2));
    ylim_min = min(ylim_min, min(abs(psi_f(:)).^2));
end
     
set(gca,'FontSize', obj.plt.font)
ylabel('$\phi, ~\pi$', 'interpreter', 'latex', ...
                   'FontSize', obj.plt.font);
grid on;

ylim_max = ylim_max + 0.2*abs(ylim_max);
ylim_min = ylim_min + 0.2*abs(ylim_max);
ylim([ylim_min, ylim_max]);

xlim([-10, 10]);

    
legend(leg, ...
       'interpreter', 'latex', ...
       'FontSize', 0.9*obj.plt.font, ...
       'Orientation','horizontal', ...
       'Location','northeast', ...
       'NumColumns', 4)
end