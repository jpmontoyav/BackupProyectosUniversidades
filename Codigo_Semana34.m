global Mu_Zero E_Zero c Kclco neffcl neffco %Beta_2

Mu_Zero=4*pi*1e-7;
E_Zero=8.854187*1e-12;

c=(1/sqrt(Mu_Zero*E_Zero));          %%%% speed of light in vacuum

Lambda_o=linspace(1540e-9,1750e-9,1000); %%% excitation spectrum

%% LPFBG characteristics (simplified as in Erdogan)
%neffco=1.4522851; %of CORE!
%neffcl=neff; %of Cladding
%delta_neff=3e-4;        %%% change of the effective refractive index due to the perturbation
 delta_neff=1e-8;        %%% change of the effective refractive index due to the perturbation
v=1;                    %%%% fringe visibility
diffneff= neffco-neffcl;  %"normal" value for the difference between neffcore and neff cladding, Δn_eff

LAMBDA_GRAT= 570e-6;     %%%% required grating for synchronism
Lambda_desing=LAMBDA_GRAT*diffneff;      %%%wavelength where we want to have synchronism

%copropagating beta_1 and beta_2
Beta_1=diffneff*((2*pi)./Lambda_o);        
Omega_1=Beta_1*c;
Beta_2= Beta_1-(Lambda_o./ LAMBDA_GRAT);       
Omega_2=Beta_2*c;


kappa = Kclco;

%kappa=0.9843; %example from coefficient code
%kappa=(v/2)*sigma_coupling; %THIS CANNOT BE DONE IN LPGs

%%%% FBG length
% % L=3/(((v*pi)./Lambda_desing)*delta_neff)
L=pi/(2*max(kappa));
z=L;%slicing

%For LPGs 
sigma_coupling=((2*pi)./Lambda_o)*delta_neff; % LP01 coefficient !!!
%can be sent to zero

delta= (1/2)*(Beta_1-Beta_2)-(pi/LAMBDA_GRAT); %eq. 37 of erdogan's paper, only works for LP01?

sigmahat=delta+sigma_coupling;
%resonances at lambda=(diffneff)*LAMBDA_GRAT

 %for transmission gratings



for j = 1:length(kappa)
  GammaC=(kappa(j)^2+sigmahat.^2);  
%%% transfer matrixes (eq 52, for LPFBG
FBm_1_1=cos(GammaC.*z)+complex(0,1).*(sigmahat./GammaC).*sin(GammaC.*z);
FBm_1_2=complex(0,1)*(kappa(j)./GammaC).*sin(GammaC.*z);
FBm_2_1=complex(0,1)*(kappa(j)./GammaC).*sin(GammaC.*z);
FBm_2_2=cos(GammaC.*z)-complex(0,1)*(sigmahat./GammaC).*sin(GammaC.*z);


%%%% solving S_0 and R_L from the tranfer matrix when S_L=0 and R_0=1
S_0(j,:)=-(FBm_2_1)./(FBm_2_2);
R_L(j,:)=FBm_1_1+FBm_1_2.*(-FBm_2_1./FBm_2_2);


%%% Defining LambdaMax for transmission grating
LambdaMax=(1+(delta_neff/diffneff))*Lambda_desing;
%for h = 1:100 %size(R_L,2)
reflSpectra(j,:)=abs(R_L(j,:)).^2;
end

figure
plot(Lambda_o*1e9,(reflSpectra(7,:)),'linewidth',2)
xlabel('\lambda [nm]','fontsize',14)
hold on
ylabel('Transmission','fontsize',14)
set(gca,'fontsize',14)
%end
% % % 
% % % figure
% % % plot(Lambda_o/LambdaMax,reflSpectra)
% % % xlabel('\lambda/\lambda_{max}','fontsize',14)
% % % grid on
% % % ylabel('Reflectivity','fontsize',14)
% % % set(gca,'fontsize',14)