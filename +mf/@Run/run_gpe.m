function [Psi, mu, t] = run_gpe_2(obj, Psi, mu, t, tf)

s = 0;
Psi2 = real(Psi.*conj(Psi));
n = obj.model.get_n(Psi);

while t < tf
    %% GPE step
    for i = 1 : obj.n_iter_fft/obj.n_rec
        s = s + 1;
        v = obj.model.get_v(t);
        Psi = exp(-0.5*obj.dt_f*...
                 (v + obj.model.config.g*Psi2 - mu)).*Psi;
        for j = 1 : obj.n_rec
            Psi = ifftn(obj.ekk.*fftn(Psi));
            if(obj.model.w_cs ~= 0)
                LPsi = Psi;
                for ii = 1:obj.n_l_rec
                    LPsi = Psi + obj.dt_f*obj.model.w_cs*obj.model.applyangm(LPsi, 'z');
                    LPsi = 0.5*(Psi+LPsi);
                end
                Psi = Psi + obj.dt_f*obj.model.w_cs*obj.model.applyangm(LPsi, 'z');
            end
            Psi = exp(-obj.dt_f*(v + obj.model.config.g*Psi.*conj(Psi) - mu)).*Psi;
        end
        Psi = exp(0.5*obj.dt_f*(v + obj.model.config.g*Psi.*conj(Psi) - mu)).*Psi;
        Psi2 = real(Psi.*conj(Psi));
        ncur = sum(Psi2(:).*obj.model.grid.dV);
        
        if(obj.model.config.gamma > 0)
            if(obj.model.config.td > 0)
                n = obj.model.config.N*exp(-t/obj.model.config.td);
            end       
            Psi = Psi*sqrt(n/ncur);
            Psi2 = Psi2*(n/ncur);
            H = obj.model.applyham(Psi, v + obj.model.config.g*(abs(Psi).^2));
            mu = real(sum(H(:)).*obj.model.grid.dV)/n;
        else
            H = obj.model.applyham(Psi, v + obj.model.config.g*(abs(Psi).^2));
            mu = real(sum(H(:)).*obj.model.grid.dV)/ncur;
        end
    end
    t = t + obj.dt*obj.n_iter_fft;

    util.check(obj.model.test, struct('s', s, ...
                                      't', t, ...
                                      'mu', mu, ...
                                      'Psi2', abs(Psi).^2));
end
end