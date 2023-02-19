function plot_circle_psi(obj, s)

leg = {};
psi = obj.load_psi(s);
t = obj.data.t(s);


for i = 1 : obj.model.rings.n
    psi_i = obj.model.get_ring_psi(psi, i, t);
    [psi_1, rl] = obj.model.get_psi_1D_cyl(psi_i, obj.model.Vs.toroidal(i).get_r(t));

    plot(rl, (abs(psi_1).^2 - mean(abs(psi_1).^2))/(max(abs(psi_1).^2) - mean(abs(psi_1).^2)), 'Color', 'black', ...% obj.plt.basic_colors{i}, ...
                            'LineWidth', obj.plt.width)
    hold on
    leg{end + 1} = ['$\delta \mid \psi_' num2str(i) '\mid^2$'];

    if isfield(obj.model.Vs, 'cosine')
        v = obj.model.Vs.cosine(1).get_v(t).*obj.model.get_ring_mask(i, t);
        [w, rl] = obj.model.get_v_1D_cyl(v, obj.model.Vs.toroidal(i).get_r(t));
        plot(rl, w/obj.model.Vs.cosine(1).U.max, 'Color', 'blue', ...% obj.plt.basic_colors{i}, ...
                                           'LineWidth', 0.8*obj.plt.width, ...
                                           'LineStyle', ':')
        hold on
        leg{end + 1} = ['$V_{cos}$'];
    end

    ylabel(['$\delta \mid \psi \mid^2$'], 'interpreter', 'latex');
    ylim([-1.2, 1.2])

    yyaxis right
    plot(rl, angle(psi_1)./pi, 'Color', 'red', ...% obj.plt.basic_colors{i}, ...
                            'LineWidth', obj.plt.width, ...
                            'LineStyle', '--')
    hold on
    leg{end + 1} = ['$\phi_' num2str(i) '$'];
    ylabel(['$\phi, ~\pi$'], 'interpreter', 'latex');
    ylim([-1.2, 1.2])
end

xlim([0, 2*pi])
xlabel(['$x_{\theta}, ~\mu m$'], 'interpreter', 'latex');
set(gca,'FontSize', obj.plt.font)

    
legend(leg, ...
       'interpreter', 'latex', ...
       'FontSize', 0.9*obj.plt.font, ...
       'Orientation','horizontal', ...
       'Location','northeast')%, ...
%       'NumColumns', obj.model.rings.n)
end
