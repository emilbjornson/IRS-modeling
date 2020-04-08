%%This Matlab script generates Figure 4 in the paper:
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

%Angle of incidence
theta_i= deg2rad(0);

%Desired 'reflection' angles
theta_r= deg2rad([30,50,75]);

%Select carrier frequency(and wavelength)
c=3e8;
f=3e9;
lambda=c/f;

%Wavenumber
k= 2*pi/lambda;

%Define y-axis of the surface: [-8\lambda,8\lambda] corresponds to the case
%that the surface is 16\lambda long along the y-axis
y = lambda*(-8:0.001:8);


%% Ray optics solution
%Prepare to save simulation results
phi_r=zeros(length(y),length(theta_r));


%Go through all desired angles
for m=1:length(theta_r)
    
    %Go through y-axis
    for n=1:length(y)
        
        %Calculate Eq. 14 and normalize the result with respect to 2*pi
        check = mod(k*(-sin(theta_r(m))+ sin(theta_i)).*(y(n)),2*pi);
        
        if  check > pi
            phi_r(n,m)= mod(k*(-sin(theta_r(m))+ sin(theta_i)).*(y(n)),-pi);
            
        else
            phi_r(n,m)= mod(k*(-sin(theta_r(m))+ sin(theta_i)).*(y(n)),pi);
        end
    end
end



%% Quantization part
%Quantize the surface phase using B=3 bits
B=3;
xq=quant(rad2deg(phi_r(:,3)/180),B);%Assumes a full-scale signal in the interval [-1,1]

%Note: to create the exactly same figure as in the paper set theta_i=0
%Plot Figure 4
figure;
plot(y/lambda,rad2deg(phi_r(:,3)),'r-.',y/lambda,xq*180,'k','LineWidth',2)
xlabel('$y/\lambda$','Interpreter','Latex');
ylabel('Local surface phase $\phi_r (y)$ ','Interpreter','Latex');
legend('Exact Phase ','Quantized Phase','Location','NorthEast','Interpreter','Latex');
set(gca,'fontsize',18);
ylim([-185 185])
xlim([-2 2])
