function plot_1d(obj, s)

%leg = {};
psi = obj.load_psi(s);
rmean = mean([obj.model.Vs.toroidal(1).R.x, obj.model.Vs.toroidal(2).R.x]);
cs = [0.96, 0.97, 0.98, 0.99, 1.0, 1.01, 1.02,1.03, 1.04];
for i = 1 : size(cs, 2)
    [psi_1D, ~] = obj.model.get_psi_1D_cyl(psi, cs(i)*rmean);
    [v_1D, rl] = obj.model.get_psi_1D_cyl(obj.model.get_v(obj.data.t(s)), cs(i)*rmean);
    if i == 1
        psi2 = abs(psi_1D).^2;
        v = v_1D;
    else
        psi2 = psi2 + abs(psi_1D).^2;
        v = v + v_1D;
    end
end
rl = rl - 2*pi*(rl > pi);

shift = round(size(rl, 2)/2);
rl = circshift(rl, shift);
psi2 = circshift(psi2, shift)/size(cs,2);
v = circshift(v, shift)/size(cs,2);


plot(rl, psi2*obj.model.grid.dV,  'Color', 'black', 'LineWidth', 0.7*obj.plt.width, ...
                            'LineStyle', '-');
hold on 
%leg{end + 1} = '$\mid\psi\mid^2$';


for i = 1 : size(obj.data.rs, 2)
    if i <= size(obj.plt.basic_colors_jv, 2)
        color =  obj.plt.basic_colors_jv{i};
    else
        color = 'black';
    end
    if ~isnan(obj.data.jvs(s, i))
        xline(obj.data.jvs(s, i) - 2*pi*(obj.data.jvs(s, i) > pi) , 'LineWidth', 0.8*obj.plt.width, 'color', color, 'Linestyle', '--')
        hold on
    end
end

if isfield(obj.model.Vs, 'ladder')
    mean_v = mean([max(v(:)), min(v(:))]);
    if obj.model.Vs.ladder(1).U.max < 0
        main_v = sum(v.*(v > mean_v))/sum(v > mean_v);
    else
        main_v = sum(v.*(v < mean_v))/sum(v < mean_v);
    end
    v = (v - main_v);
    v = obj.model.to_energy_recoil(v);

    %healing_length = obj.model.get_healing_length(psi, obj.data.t(s));
    n0 = max(psi2(:));
    healing_length = gather(1/sqrt(obj.model.config.g*n0));
    % length of single sector part 
    l = 2*pi*rmean/obj.model.Vs.ladder(1).n;
    title(['$\Omega = 2\pi\times', num2str(obj.model.to_omega(obj.model.Vs.ladder(1).w)/(2*pi), '%.2f'), '$ Hz, $U = ', num2str(obj.model.Vs.ladder(1).U.max, '%.2g'), '$, ', ...
           '$l = ', num2str(l, '%.2g'), '~\mu m$, $\xi = ', num2str(healing_length, '%.2g'), '~\mu m $'], 'Interpreter', 'latex', 'FontSize', 0.8*obj.plt.font, 'color', 'blue')
end
%ylim([ymin - 0.2*abs(ymax), ymax + 0.2*abs(ymax)])
%xlim([-1.1*pi, 1.1*pi])
xlabel('$\theta$', 'Interpreter','latex')
ylabel('$n~ \mu m ^{-2}$', 'Interpreter','latex')


yyaxis right
plot(rl, v, 'Color', 'red', 'LineWidth', 0.7*obj.plt.width, ...
                            'LineStyle', '-');
hold on 

if isfield(obj.model.Vs, 'ladder')
    ylabel('$U - U_0, E_{rec}$', 'Interpreter','latex')
else
    ylabel('$U$', 'Interpreter','latex')
end

end