function show_v(obj, t)
% show potential images from 2 sides

t = obj.to_time_dim(t);

sz = size(t, 2);
for ii = 1 : sz
    subplot(2, sz, ii)
    v = obj.get_v(t(ii));
    value = 0.5*max(v(:));
    isosurface(obj.grid.r.x, obj.grid.r.y, obj.grid.r.z, v, value);
    hold on

    %alpha(0.1);
    %p.FaceColor = 'blue';
    %p.EdgeColor = 'none';
    %view(5, 25);

    ylabel('y');
    xlabel('x');
    zlabel('z');
    set(gca,'LineWidth', 3);
    set(gca,'FontSize', 20);
    %[psi, mu] = obj.
    %subplot(3, sz, ii)
    %psi = (mu - obj.get_v(t(ii)))/obj.config.g;
    %psixy = psi(:, :, obj.grid.N.z/2);
    %imagesc(obj.grid.r.x, obj.grid.r.y, abs(psixy).^2)
    %hold on
    %xlabel('x')
    %ylabel('y')
    title(['t = ', num2str(obj.to_time(t(ii))), ' s']) 

end


[t1, t2, U1, U2] = obj.get_protocol_time();
Umax = 1.1*U2;
Umin = 1.1*U1;

subplot(2, sz, sz + 1: 2*sz)
width = 1.2;
t = (t1:obj.to_time_dim(0.001):t2);
leg = {};
fields = fieldnames(obj.Vs);
for i = 1 : length(fields)
    field = fields{i};
    for j = 1 : length(obj.Vs.(field))
        v = obj.Vs.(field)(j);
        if abs(v.U.max) > 0 
            disp(field)
            disp(v.U.t)
            u = v.get_u(t);
            disp(max(u(:)))
            plot(obj.to_time(t), u, 'Linewidth', width)
            hold on
            leg{end + 1} = [field, num2str(j)];
        end
        if strcmp('toroidal', field)
                x1 = obj.to_time(v.tof(1));
                x2 = obj.to_time(v.tof(2));
                xBox = [x1, x1, x2, x2, x1];
                yBox = [Umin, Umax, Umax, Umin, Umin];
                patch(xBox, yBox, 'white', 'EdgeColor', 'white', 'FaceColor', 'blue', 'FaceAlpha', 0.1);
                hold on
                leg{end + 1} = [field, num2str(j), ' tof'];
        end
    end
end
legend(leg, 'Fontsize', 15, 'Location','north')
shg


end