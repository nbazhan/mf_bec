function plot_evolution(obj, s)

% plots time evolution of chemical potential, angular momentums of each
% ring and potential amplitudes

leg = {};
coli = 1;
light_coli = 1;
xts = obj.model.to_time(obj.data.t)*1000;

for i = 1 : obj.model.rings.n
    plot(xts, obj.data.l(i, :), 'Color', obj.plt.basic_colors{i}, ...
                            'LineWidth', obj.plt.width);
    hold on
    leg{end + 1} = ['$ring_' num2str(i) '$'];
end
     
set(gca,'FontSize', obj.plt.font)
ylabel('$L_i/N$', 'interpreter', 'latex', ...
                   'FontSize', obj.plt.font);
ylim([min(obj.data.l(:)) - 0.5, max(obj.data.l(:)) + 0.6*obj.model.rings.n])
xlim([min(xts), max(xts)])
grid on;
    
yyaxis right
lims = [0, 0];
    
for mui = 1 : obj.model.rings.n
    plot(xts, obj.data.mu(mui, :), 'Color', obj.plt.light_colors(light_coli, :), ...
                               'LineWidth', obj.plt.width, 'LineStyle', ':');
    hold on;
    leg{end + 1} = ['$\mu_', num2str(mui), '$'];
    lims = [min(min(obj.data.mu(mui, :)), lims(1)), max(max(obj.data.mu(mui, :)), lims(2))];
    light_coli = light_coli + 1;
end

fields = fieldnames(obj.model.Vs);
for i = 1 : length(fields)
    us = obj.data.(['u_' fields{i}]);
    for j = 1 : size(us, 1)
        if abs(obj.model.Vs.(fields{i})(j).U.max) > 0
            plot(xts, us(j, :), 'Color', obj.plt.dark_colors(coli, :), ...
                                'LineStyle', '-', ...
                                'LineWidth', obj.plt.width);   
            hold on;
            leg{end + 1} = [fields{i} num2str(j)];
            coli = coli + 1;
        end
    end
    lims = [min(min(us(:)), lims(1)), max(max(us(:)), lims(2))];
end
    

ylim_max = lims(2) + 0.5*obj.model.rings.n*abs(lims(2));
ylim_min = lims(1) - 0.3*obj.model.rings.n*abs(lims(1));
ylim([ylim_min, ylim_max])
set(gca,'FontSize', obj.plt.font)
ylabel('$U, \hbar \omega_r$', 'interpreter', 'latex', ...
                              'FontSize', obj.plt.font);
xlabel('t, ms', 'interpreter', 'latex', ...
                'FontSize', obj.plt.font);
    
plot(xts(s)*[1, 1], [ylim_min ylim_max], ...
            'Color', [0.4660 0.6740 0.1880], ...
            'MarkerFaceColor',  [0.4660 0.6740 0.1880], ...
            'LineWidth', 0.8*obj.plt.width, ...
            'LineStyle', '--')

    
legend(leg, ...
       'interpreter', 'latex', ...
       'FontSize', 0.9*obj.plt.font, ...
       'Orientation','horizontal', ...
       'Location','northeast')%, ...
       %'NumColumns', obj.model.rings.n)
   
end