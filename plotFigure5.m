%%This Matlab script generates Figure 5 in the paper:
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

%Desired 'reflection' angle 
theta_r = deg2rad(60); 

%Sizes of the surfaces for comparison
a=[0.5,10,50]*lambda; 
b=[0.5,10,50]*lambda;

%Define observation angle
theta_s=deg2rad(-90:0.00001:90); %to have better resolution reduce the step size

%Define the distances and the antenna gains
dt=50; dr=25; %transmitter (dt) and receiver (dr) antenna distances (from IRS)
Gt=db2pow(5); Gr=db2pow(5);  %transmitter (Gt) and receiver (Gr) antenna gains

%Prepare to save simulation results
beta_IRS=zeros(length(theta_s),length(a));


%% Go through all surface sizes
for sizes=1:length(a)
    
    %Go through all observation angles
    for n=1:length(theta_s)
       
        %Calculate the term inside the bracket in Eq. (18)
        y=((k0*b(sizes))/2)*(sin(theta_s(n)) - sin(theta_r));
        Y=(sin(y)/y)^2;
        
        %Check for the limit sin(0)/0 = 1
        if isnan(Y) 
            Y=1;
        end
        
        %Compute Eq. (18)
        beta_IRS(n,sizes) = (Gt*Gr/((4*pi)^2))*((a(sizes)*b(sizes))/(dt*dr))^2 *(cos(theta_i)^2)*Y;
    end
    
end


%% Plot simulation results [in degrees]
theta_s=rad2deg(theta_s);

figure;
pathloss_dB=pow2db(beta_IRS);
hold on; box on;
plot(theta_s,pathloss_dB(:,3),'r-','LineWidth',2);
plot(theta_s,pathloss_dB(:,2),'b--','LineWidth',2);
plot(theta_s,pathloss_dB(:,1),'k-.','LineWidth',2);
ylabel('Pathloss $\beta_\mathrm{IRS}$ [dB]','Interpreter','Latex')
xlabel('Observation angle $\theta_s$ [degrees]','Interpreter','Latex');
legend('$a=b=50\lambda$', '$a=b=10\lambda$', '$a=b= \lambda/2$','Interpreter','Latex','Location','NorthWest');
set(gca,'fontsize',18);
ylim([-200 -45])
xlim([-90 90])
