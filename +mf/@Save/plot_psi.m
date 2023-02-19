function plot_psi(obj, psi, axes, varargin)

%psi = abs(psi);
if ~isempty(varargin)
    clims = varargin{1};
else
    clims = [min(psi(:)), max(psi(:))];
end

if clims(1) < clims(2)
    imagesc(obj.model.grid.r.(axes(1)), obj.model.grid.r.(axes(2)), psi, clims);
else
    imagesc(obj.model.grid.r.(axes(1)), obj.model.grid.r.(axes(2)), psi);
end

hold on;
axis image;
xlabel([axes(1) ', $\mu m$'], 'interpreter', 'latex');
ylabel([axes(2) ', $\mu m$'], 'interpreter', 'latex');
set(gca,'YDir','normal')
set(gca,'FontSize', 0.9*obj.plt.font)
end

