function plot_jv(obj, s, fit_n)

leg = {};
xts = obj.model.to_time(obj.data.t)*1000;

%fit_n = 2;
fit_ps = zeros(size(obj.data.jvs, 2), fit_n + 1);

for i = 1 : size(obj.data.jvs, 2)
    if i <= size(obj.plt.basic_colors_jv, 2)
        color =  obj.plt.basic_colors_jv{i};
    else
        color = 'black';
    end
    scatter(xts, obj.data.jvs(:, i), 'MarkerEdgeColor', color);
    hold on
    leg{end + 1} = '';
    
    % fit jv location with polynomial
    fit_ps(i, :) = polyfit(xts, obj.data.jvs(:, i)', fit_n);
    xts_fitted = linspace(xts(1), xts(end), size(xts, 2)*10);
    jvs_fitted = polyval(fit_ps(i, :), xts_fitted);

    plot(xts_fitted, jvs_fitted, 'Color', color, ...
                                  'LineWidth', obj.plt.width)
    hold on

    leg{end + 1} = ['$jv_' num2str(i) '$'];
end
     
set(gca,'FontSize', obj.plt.font)
ylabel('$\phi, ~\pi$', 'interpreter', 'latex', ...
                   'FontSize', obj.plt.font);
grid on;
ylim([-0.2, 2*pi + 0.2])


yyaxis right

max_ws = 0;
min_ws = 0;
for i = 1 : size(obj.data.jvs, 2)
    if i <= size(obj.plt.basic_colors_jv, 2)
        color =  obj.plt.basic_colors_jv{i};
    else
        color = 'black';
    end
    fit_ps_der = fit_ps(i, :).*(fit_n:-1:0);
    ws_fitted = zeros(size(jvs_fitted));
    for j = 1 : fit_n 
        ws_fitted = ws_fitted + fit_ps_der(j)*xts_fitted.^(fit_n - j);
    end
    plot(xts_fitted, ws_fitted, 'Color', color, ...
                                  'LineWidth', obj.plt.width, ...
                                  'LineStyle', '--');
    hold on
    leg{end + 1} = ['$\omega_' num2str(i) '$'];

    max_ws = max(max_ws, max(ws_fitted));
    min_ws = min(min_ws, min(ws_fitted));
end

title_equation = '';
for i = 1 : size(obj.data.jvs, 2)
    title_equation = [title_equation, '$\phi_', num2str(i), '(t) \approx '];
    for pp = 1:size(fit_ps(i, :), 2)
        if pp == 1
            title_equation = [title_equation, num2str(fit_ps(i, pp), '%.4f'), 't^', num2str(fit_n +1 - pp), ' + '];
        else
            title_equation = [title_equation, num2str(fit_ps(i, pp), '%.2g'), 't^', num2str(fit_n +1 - pp), ' + '];
        end
    end
    title_equation = [title_equation(1:end - 2), '$'];
    if i < size(obj.data.jvs, 2)
        title_equation = [title_equation, newline];
    end
end
title(title_equation, 'Interpreter', 'latex', 'Fontsize', 0.8*obj.plt.font)

set(gca,'FontSize', obj.plt.font)
ylabel('$\omega$', 'interpreter', 'latex', ...
                              'FontSize', obj.plt.font);
xlabel('t, ms', 'interpreter', 'latex', ...
                'FontSize', obj.plt.font);

ylim_max = max_ws + 0.2*abs(max_ws);
ylim_min = min_ws - 0.2*abs(min_ws);
ylim([ylim_min, ylim_max])
xlim([min(xts), max(xts)])

plot(xts(s)*[1, 1], [ylim_min ylim_max], ...
            'Color', [0.4660 0.6740 0.1880], ...
            'MarkerFaceColor', [0.4660 0.6740 0.1880], ...
            'LineWidth', 0.8*obj.plt.width, ...
            'LineStyle', '--')
    
    
legend(leg, ...
       'interpreter', 'latex', ...
       'FontSize', 0.9*obj.plt.font, ...
       'Orientation','horizontal', ...
       'Location','northwest')%, ...
       %'NumColumns', 2)

save([obj.drs.jv 'jv_fitted_by_polynomial.mat'], 'fit_ps');
end