function [Psi, nt, mu] = get_zng(obj, varargin)

model = obj.model;
grid = model.grid;
grid_nt = model.grid_nt;
config = model.config;
dt = obj.dt;

if model.D < 3
    T = 0;
elseif size(varargin) > 1 
    T = varargin{1};
else
    T = config.T;
end

if T == 0
    disp([num2str(model.D), 'D problem: calculating ITP...'])
else
    disp([num2str(model.D), 'D problem: calculating ZNG: T = ', ...
              num2str(model.to_temp(T)), '...'])
end

v = model.get_v(obj.t);
Nl2 = model.get_v(obj.t, 'nt');

% initial Phi
if isempty(obj.mu)
    if model.D == 1
        phi0 = rand([1, grid.N.x]) + 1i*rand([1, grid.N.x]); 
        phi0 = ones([1, grid.N.x]) + 1i*ones([1, grid.N.x]); 
    elseif model.D == 2
        phi0 = rand(grid.N.x, grid.N.y) + 1i*rand(grid.N.x, grid.N.y); 
        phi0 = ones(grid.N.x, grid.N.y) + ...
                1i*ones(grid.N.x, grid.N.y); 
    elseif model.D == 3
        phi0 = rand(grid.N.x, grid.N.y, grid.N.z) + 1i*rand(grid.N.x, grid.N.y, grid.N.z); 
        phi0 = ones(grid.N.x, grid.N.y, grid.N.z) + ...
                    1i*ones(grid.N.x, grid.N.y, grid.N.z); 
    end
    
    Psi = sqrt(config.N/(sum(sum(sum(abs(phi0).^2)))*grid.dV))*phi0;
else
    %Psi = obj.get_tf(); % use only Thomas-Fermi approximation as initial guess if mu_init is set
    Psi = sqrt((obj.mu - v)/config.g);
end

% add initial angular momentum
if ~isempty(obj.phase)
    Psi = Psi.*exp(1i*obj.phase);
end
	
if isempty(obj.mu)
    Nc = config.N;
else
    Nc = 1;
end

% initial amount of thermal and condensed atoms
nt = zeros(size(grid_nt.X), 'like', v);
nx = round(grid.N.x/2);
ny = round(grid.N.y/2);
if obj.model.D == 3
    nz = round(grid.N.z/2);
end

C = zeros(1000, 1);
c_old = 0;
MU = zeros(1000, 1);

delta = 1;
i = 0;
ekk = exp(-grid.kk * dt);
if(model.w_cs ~= 0)
    ekx = exp(-(grid.k.x.^2 - 2*grid.k.x.*grid.Y*model.w_cs)/2*dt);
    eky = exp(-(grid.k.y.^2 + 2*grid.k.y.*grid.X*model.w_cs)/2*dt);
end


Nl = v + config.g*real(Psi.*conj(Psi));

util.check(model.test, struct('Init_V', v, ...
                            'Init_Nl2', Nl2, ...
                            'Init_ekk', ekk, ...
                            'Init_Nl', Nl), '-');
while true 
    i = i + 1;

    Psi = exp(-(dt/2)*Nl).*Psi;
    if(model.w_cs ~= 0)
        Psi = ifft(ekx.*fft(Psi, grid.N.x, 2), grid.N.x, 2);
        Psi = ifft(eky.*fft(Psi, grid.N.y, 1), grid.N.y, 1);
    else
        Psi = ifftn(ekk.*fftn(Psi));
    end
    Psi = exp(-(dt/2)*Nl).*Psi;
    
	Psi2 = real(Psi.*conj(Psi));
    util.check(model.test, struct('Psi2', Psi2), '-')
    %disp(['i : ', num2str(i), 'Psi1 : ', num2str(max(Psi2(:))), ', ', num2str(sum(Psi2(:)))])
    
    if(T > 0 && mod(i,10) == 1 && isempty(obj.mu)) % for better performance and stability we do some initial iterations without a thermal cloud
        Nt = sum(nt(:)).*grid_nt.dV;
        Nc = config.N - Nt;
        util.check(model.test, struct('Nt', Nt, ...
                                      'Nc', Nc))
        if(Nc <= 1)
            Nc = 1;
            nt = nt*config.N/Nt; % we need to get the correct total number of particles even above Tc
        end
    end
    N = sum(Psi2(:)).*grid.dV;
    if isempty(obj.mu)
        c = sqrt(Nc/N);
        N = N*c^2;
        C(i) = gather(log(c)/dt);
    else
        c = exp(obj.mu*dt);
        N = N*c^2;
        C(i) = gather(N);
    end

    Psi =Psi*c;
    Psi2 = Psi2*abs(c)^2;
    Nl = v + config.g*(abs(Psi).^2);
     
    H = model.applyham(Psi, Nl + 2*config.g*model.shrink(nt));
    mu2 = real(sum(H(:)).*grid.dV)/N;
    MU(i) = gather(mu2);

    util.check(model.test, struct('i', i, ...
                                'nt', nt, ...
                                'c', c, ...
                                'Psi2', Psi2, ...
                                'Nl', Nl, ...
                                'mu', mu2));

    if(mod(i,10) == 0)
        %disp([num2str(i), ': ', num2str(delta), '/', num2str(obj.acc)])
        if(T > 0)
            if model.D == 3
                Nl2(nx + 1:3*nx, ny + 1:3*ny, nz+1:3*nz) = v + 2*config.g*real(Psi2);
            elseif model.D == 2
                Nl2(nx + 1:3*nx, ny + 1:3*ny) = v + 2*config.g*real(Psi2);
            end
            util.check(model.test, struct('size_Nl2', size(Nl2), ...
                                            'size_nt', size(nt)));
            Nl2 = Nl2 + 2*config.g*nt;
            ntt = (T/2/pi)^(3/2)*util.my_polylog(1.5, exp((MU(i) - Nl2)/T));
            ntt = ntt.*isfinite(ntt);
            if(Nc <= 1 && isempty(obj.mu))
                Nt = sum(nt(:)).*grid_nt.dV;
		        nt = (nt + ntt*config.N/Nt)*0.5;
		    else
		        nt=(nt+ntt)*0.5;
            end
            util.check(model.test, struct('i', i, ...
                                        'ntt', ntt, ...
                                        'nt', nt,...
                                        'Nl2', Nl2));
        end 
    end
    util.check(model.test, struct('Psi', Psi, 'mu', mu2))
    Nl = Nl + 2*config.g*model.shrink(nt);
    %util.check(model.test, struct('Nl', Nl));
   
    if(i > 50) && mod(i,10) == 5
        delta = (abs(C(i)-C(i-9))/9 + abs(C(i)-C(i-1)))/dt/C(i);
        util.check(model.test, struct('delta', delta))
        if(delta < obj.acc)
            if (dt < obj.acc*10 || dt < 1e-4)
                break;
            else
                dt = dt/1.5;
                ekk = exp(-grid.kk*dt);
                if(model.w_cs ~= 0)
                    ekx = exp(-(grid.k.x.^2-2*grid.k.x.*grid.Y*model.w_cs)/2*dt);
                    eky = exp(-(grid.k.y.^2+2*grid.k.y.*grid.X*model.w_cs)/2*dt);
                end
            end
        end
    end
    if(i>=10000) 
    %if(i>=100000) 
        warning('Convergence not reached');
        break;
    end
end
mu = C(i-1);


util.check(model.test, struct('Last_Psi', Psi))
% Make intial mean phase inside toroidal potential equal to zero 
% substitute mean phase base_phi
if obj.model.D > 1 && isfield(model.Vs, 'toroidal')
    if ~isempty(model.Vs.toroidal)
         r = sqrt(grid.X.^2 + grid.Y.^2);
         R = model.Vs.toroidal(1).R.x;
         psi = Psi;
         filter = (abs(r - R) < 0.01*R);
         if model.D == 3
             psi = psi(:, :, round(grid.N.z./2));
             filter = filter(:, :, round(grid.N.z./2));
         end
         util.check(model.test, struct('Last_Psi_after_psi', Psi))
         base_phi = real(sum(angle(psi).*filter)/sum(filter));
         util.check(model.test, struct('base_phi', base_phi))
         Psi = Psi.*exp(-1i*base_phi);
    end
end
util.check(model.test, struct('Last_Psi_after_phase', Psi))
end
