

%clear all
%close all
%clc

global Mu_Zero E_Zero c

Mu_Zero=4*pi*1e-7;
E_Zero=8.854187*1e-12;

c=(1/sqrt(Mu_Zero*E_Zero));          %%%% speed of light in vacuum

Lambda_o=linspace(1556.5e-9,1561.5e-9,1000); %%% excitation spectrum

%% FBG characteristics (simplified as in Erdogan)
neff=1.45;
delta_neff=8e-4;        %%% change of the effective refractive index due to the perturbation
% % delta_neff=1e-3;        %%% change of the effective refractive index due to the perturbation
v=1;                    %%%% fringe visibility

Beta_o=neff*((2*pi)./Lambda_o);        %% propagation constant of the forward waves that will be coupled to an indentical backward wave
Omega_0=Beta_o*c;


Lambda_desing=1558e-9;      %%%wavelength where we want to have synchronism
LAMBDA_GRAT=Lambda_desing/(2*neff);     %%%% required grating for synchronism

delta=Beta_o-(pi/LAMBDA_GRAT);
sigma_coupling=((2*pi)./Lambda_o)*delta_neff;

kappa=(v/2)*sigma_coupling;

sigmahat=delta+sigma_coupling;


GammaB=sqrt(kappa.^2-sigmahat.^2);


%%%% FBG length
% % L=3/(((v*pi)./Lambda_desing)*delta_neff)
L=1e-3;
z=linspace(0,L,1000);

%%% transfer matrix
FBm_1_1=cosh(GammaB.*z)-complex(0,1).*(sigmahat./GammaB).*sinh(GammaB.*z);
FBm_1_2=-complex(0,1)*(kappa./GammaB).*sinh(GammaB.*z);
FBm_2_1=+complex(0,1)*(kappa./GammaB).*sinh(GammaB.*z);
FBm_2_2=cosh(GammaB.*z)+complex(0,1)*(sigmahat./GammaB).*sinh(GammaB.*z);


%%%% solving S_0 and R_L from the tranfer matrix when S_L=0 and R_0=1
S_0=-(FBm_2_1)./(FBm_2_2);
R_L=FBm_1_1+FBm_1_2.*(-FBm_2_1./FBm_2_2);


%%% Defining LambdaMax
LambdaMax=(1+(delta_neff/neff))*Lambda_desing;

reflSpectra=abs(R_L).^2;

figure
plot(Lambda_o*1e9,reflSpectra,'r--','linewidth',2)
xlabel('\lambda [nm]','fontsize',14)
grid on
ylabel('Reflectivity','fontsize',14)
legend({'Uniform'},'fontsize',14)
set(gca,'fontsize',14)



% % % 
% % % figure
% % % plot(Lambda_o/LambdaMax,reflSpectra)
% % % xlabel('\lambda/\lambda_{max}','fontsize',14)
% % % grid on
% % % ylabel('Reflectivity','fontsize',14)
% % % set(gca,'fontsize',14)