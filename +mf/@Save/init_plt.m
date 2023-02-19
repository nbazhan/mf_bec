function init_plt(obj)
    % init common parameters for plotting 
    
    obj.plt.font = 15;
    obj.plt.width = 1.5;

    % c = uisetcolor([0.6 0.8 1])

    obj.plt.basic_colors = {'red', 'blue', 'green', 'black'};
    obj.plt.basic_colors_jv = {'red', 'green', 'magenta', 'cyan'};
    obj.plt.basic_colors_ro = {'black', 'green', 'blue', 'magenta', ...
                               "#0072BD", "#D95319", "#EDB120", ...
                               "#7E2F8E", "#77AC30", "#4DBEEE", ...
                               "#A2142F", 'red', 'cyan', 'yellow'};

    

    obj.plt.dark_colors = [[0, 0, 0];
                           [0.4940, 0.1840, 0.5560];
                           [0.4660, 0.6740, 0.1880];
                           [0.6350, 0.0780, 0.1840];];

    obj.plt.light_colors = [[0.9290, 0.6940, 0.1250];
                            [0.3010, 0.7450, 0.9330];
                            [0.6745    1.0000    0.6000];
                            [0.8196    0.6000    1.0000];];
end