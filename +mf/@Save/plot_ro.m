function plot_ro(obj, s, ks)

leg = {};
xts = obj.model.to_time(obj.data.t)*1000;

unique_ks = sort(unique(abs(ks)), 'descend');
for k_i = 1 : size(unique_ks, 2)
    plot(xts, obj.data.projec_ks(2*k_i - 1, :), ...
         'Color', obj.plt.basic_colors_ro{k_i}, 'LineWidth', obj.plt.width)
    hold on
    leg{end + 1} = ['$k = ' num2str(ks(2*k_i - 1)) '$'];
    
    if ks(2*k_i - 1) ~= 0
        plot(xts, obj.data.projec_ks(2*k_i, :), ...
             'Color', obj.plt.basic_colors_ro{k_i}, ...
             'LineWidth', obj.plt.width, ...
             'LineStyle', '--')
        hold on
        leg{end + 1} = ['$k = ' num2str(ks(2*k_i)) '$'];
    end
end

projec_ks_left = 1 -  sum(obj.data.projec_ks, 1);
plot(xts, projec_ks_left, 'Color', 'red', 'LineWidth', obj.plt.width)
hold on
leg{end + 1} = 'other modes';

ymin = -0.1;
ymax = 1.5;
ylim([ymin, ymax]);
xlim([min(xts), max(xts)])
     
set(gca,'FontSize', obj.plt.font)
ylabel('$N_k/N$', 'interpreter', 'latex', ...
                   'FontSize', obj.plt.font);
grid on;

plot(xts(s)*[1, 1], [ymin, ymax], ...
            'Color', [0.4660 0.6740 0.1880], ...
            'MarkerFaceColor',  [0.4660 0.6740 0.1880], ...
            'LineWidth', 0.8*obj.plt.width, ...
            'LineStyle', '--')

legend(leg, ...
       'interpreter', 'latex', ...
       'FontSize', obj.plt.font, ...
       'Orientation','horizontal', ...
       'Location','best', ...
       'NumColumns', 3)
end