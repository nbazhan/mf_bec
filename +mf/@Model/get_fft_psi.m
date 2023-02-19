function [psif, kf] = get_fft_psi(obj, psi)

nd = sum(size(psi) > 1);
shift_param = zeros([1, nd]);

if nd == 1
    nx = size(psi, 2);
    kf.(obj.xyz(1)) = linspace(- nx/2, nx/2 - 1, nx);
    shift_param(1) = nx/2;
else
    for i = 1 : nd
        kf.(obj.xyz(i)) = linspace(-size(psi, i)/2, size(psi, i)/2, size(psi, i));
        shift_param(i) = size(psi, i)/2 - 1;
    end
end
psif = circshift(fftn(psi), shift_param);

end