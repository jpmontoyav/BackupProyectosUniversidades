clear;

for ns = [1.0];
    for theta = [0],

        clear -global;
        % function main
        yc_smf_28_1550;

        fiber.n = [nco; ncl; ns];
        fiber.r = [rco; rcl; rs];
        dr = 0.08;
        [r] = yc_gen_unif_mesh_fiber(fiber,dr);

        opts.pml.m = 8;
        opts.pml.R = 1e-0;
        opts.pml.n = round(10/dr);
        opts.pml.kappa = 0;

        opts.sortmode = 'lr';

        Dn.lam = 570;
         %!!!!! 
        Dn.chi = @(z) 1e-4/pi;%1.8*6e-4/pi;%*yc_gaussian(z,0,8e3); !TODOgetfrompreviousresults
        Dn.sigma =@(z) 2*Dn.chi(z);
        Dn.dphi = @(z) zeros(size(z));
        Dn.phi = @(z) zeros(size(z));
        Dn.theta = theta *pi/180;
        Dn.L = 14e3;
        RI.n = @(r) nco;
        RI.P = @(r) 1;
        RI.rmin = 0;
        RI.rmax = rco;

%         z = linspace(-Dn.L/2,Dn.L/2,1024);
%         plot(z,Dn.chi(z));

        grating.Dn = Dn;
        grating.RI = RI;
        grating.polarization = 'p';

        mode_solver.opts = opts;
        mode_solver.m1 = 1;
        mode_solver.nmodes1 = 143;
        mode_solver.sel_nmodes1 = 1;
        mode_solver.dir = 'S0_LPF';
        mode_solver.m = 1;
        mode_solver.nmodes = 1430;
        mode_solver.sel_nmodes = 1430;
        mode_solver.r = r;
        mode_solver.savemodes = false;
        mode_solver.loadmodes = false;
        mode_solver.sol_modes = false;

        lambda = 0.8:0.001:1.8;
        % lambda = 1.185:0.001:1.2;

        [TT,TTT,res] = yc_lpg(lambda,fiber,mode_solver,grating);

        name = ['S0_',num2str(theta),'_',...
            num2str(max(mode_solver.m)),'_',...
            num2str(mode_solver.sel_nmodes),'_'...
            num2str(ns),'.mat'];
        save(name);

        idx = 1:1:length(lambda);
        figure
        plot(lambda(idx),10*log10(TT(idx,:)));
  %      hold on;
   %     plot(lambda(idx),10*log10(TTT(idx,:)), 'r');
   %     xlabel(num2str(theta));

    end
end
