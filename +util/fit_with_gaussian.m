function params = fit_with_gaussian(x, yx, init_params)
    y = @(b,x) b(1).*exp(-(x - b(3)).^2/(2*b(2)^2));             % Objective function
    OLS = @(b) sum((y(b,x) - yx).^2);          % Ordinary Least Squares cost function
    opts = optimset('MaxFunEvals',50000, 'MaxIter',10000);
    init_params = init_params.';
    params = fminsearch(OLS, init_params, opts);       % Use (fminsearch) to minimise the 4OLS3 function
end