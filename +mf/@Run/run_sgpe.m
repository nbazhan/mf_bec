function [Psi, mu, t] = run_sgpe(obj, Psi, mu, t, tf)

s = 0;
sz = size(Psi);
Psi2 = real(Psi.*conj(Psi));

while t < tf
    %% GPE step
    for i = 1 : obj.n_iter_fft/obj.n_rec
        v = obj.model.get_v(t);
        s = s + 1;
        Psi = exp(-0.5*obj.dt_f*(v + obj.model.config.g*Psi2 - mu)).*Psi;
        for j = 1 : obj.n_rec
            Psi = Psi + obj.variance*(randn(sz,'like', v) + 1i*randn(sz,'like', v));
            Psi = ifftn(obj.ekk.*fftn(Psi));
            Psi = exp(-obj.dt_f*(v + obj.model.config.g*Psi.*conj(Psi) - mu)).*Psi;
        end
        Psi = exp(0.5*obj.dt_f*(v + obj.model.config.g*Psi.*conj(Psi) - mu)).*Psi;
        Psi2 = real(Psi.*conj(Psi));
    end
    t = t + obj.dt*obj.n_iter_fft;

    util.check(obj.model.test, struct('s', s, ...
                                      't', t, ...
                                      'mu', mu, ...
                                      'Psi2', abs(Psi).^2));
end
end