function init_config(obj)
    
    if obj.config.che == 'Na23'
        obj.config.M = 22.9897692809*obj.config.amu; % mass of sodium-23 atom
        obj.config.as = 2.75e-9; % scattering length of sodium-23
    elseif obj.config.che == 'Rb87'
        obj.config.M = 86.909180527*obj.config.amu; % mass of rhubidium-87 atom
        obj.config.as = 100.87*obj.config.a0; %5.77e-9; % scattering length of rhubidium-87
    end

    if ~isempty(obj.w)
                  obj.l.r = sqrt(obj.config.hbar/(obj.config.M*obj.w.r));
                  obj.l.z = sqrt(obj.config.hbar/(obj.config.M*obj.w.z));
    else
                  obj.w.r = obj.config.hbar/(obj.config.M*obj.l.r^2);
                  obj.w.z = obj.config.hbar/(obj.config.M*obj.l.z^2);
    end

    if obj.D == 1
        obj.config.g = 2*(obj.config.as/obj.l.r)*(obj.w_xy/obj.w.r);
    elseif obj.D == 2
        obj.config.g = sqrt(8*pi)*obj.config.as/obj.l.z;
    elseif obj.D == 3
        obj.config.g = 4*pi*obj.config.as/obj.l.r;
    end
              
    obj.config.T = obj.to_temp_dim(obj.config.T);
    obj.config.td = obj.to_time_dim(obj.config.td);

    if isfield('mu', obj.config)
        obj.config.mu = obj.to_energy_dim(obj.config.mu);
    end

end