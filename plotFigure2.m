%%This Matlab script generates Figure 2 in the paper:
%
%Ozgecan Ozdogan, Emil Bjornson and Erik G. Larsson, "Intelligent Reflecting 
%Surfaces: Physics, Propagation, and Pathloss Modeling," in IEEE Wireless
%Communications Letters.
%
%Download article: https://arxiv.org/abs/1911.03359
%
%This is version 1.0 (Last edited: 2020-04-07)
%
%License: This code is licensed under the GPLv2 license. If you in any way
%use this code for research that results in publications, please cite our
%paper as described above.


clear; close all; clc;

%Select carrier frequency and wavelength
c=3e8;
fc=3e9;
lambda=c/fc;

%Angle of incidence
theta_i= deg2rad(30);

%Wavenumber
k0=2*pi/lambda; 

%Sizes of the surfaces for comparison
a=[0.2 ,1 ,10]*lambda;
b=[0.2 ,1 ,10]*lambda;

%Define observation angle
theta_s=deg2rad(0:0.00001:90);

%Prepare to save simulation results
S=zeros(length(theta_s),length(a));


%% Go through all surface sizes
for sizes = 1:length(a)
    
    %Go through all observation angles
    for n=1:length(theta_s)
        
        %Calculate the term inside the bracket in Eq. 4
        y = ((k0*b(sizes))/2)*(sin(theta_s(n))-sin(theta_i));
        Y = (sin(y)/y)^2;
        
        %Check for the limit sin(0)/0 = 1
        if isnan(Y)
            Y=1;
        end
        
        %Compute Eq. 4
        S(n,sizes) = ((a(sizes)*b(sizes))^2/(lambda^2))*((cos(theta_i)^2))*Y;
        
    end
    
end


%% Plot simulation results [in degrees]
theta_s=rad2deg(theta_s);

figure;
hold on; box on;
S_dB=pow2db(S);
plot(theta_s,S_dB(:,3),'r-.','LineWidth',2);
plot(theta_s,S_dB(:,2),'b--','LineWidth',2);
plot(theta_s,S_dB(:,1),'k-','LineWidth',2);
ylabel('Normalized $ S(r,\theta_s) $ [dB]','Interpreter','Latex');
xlabel('Observation angle $\theta_s$ [degrees]','Interpreter','Latex');
legend('$a=b=10\lambda$','$a=b=\lambda$','$a=b=\lambda/5$','Location','NorthEast','Interpreter','Latex');
set(gca,'fontsize',18);
xlim([0 90]);
ylim([-60 20]);
