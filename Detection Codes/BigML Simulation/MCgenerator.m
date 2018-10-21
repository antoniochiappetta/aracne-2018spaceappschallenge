%% BigML simulation for impact location
% An infinite plate impact is simulated and the output is given to the
% online BigML tool to perform a deepnet analysis. 
clear all

% Sensors location and area under interest
L    = 10; % rectangular area side
l    = 1; % sensors placed on a square of size 1
N    = 500; % number of simulations
V    = 1; % velocity
% Montecarlo analysis
I    = L*[rand(N,1),rand(N,1)] - L/2;

% Times for impact
T(:,1) = sqrt((I(:,1)-l).^2+(I(:,2)-l).^2);
T(:,2) = sqrt((I(:,1)-l).^2+(I(:,2)+l).^2);
T(:,3) = sqrt((I(:,1)+l).^2+(I(:,2)+l).^2);
T(:,4) = sqrt((I(:,1)+l).^2+(I(:,2)-l).^2);

DT      = (T - repmat(min(T,[],2),1,4))/V;

% Write source file
dlmwrite(['./MCout/MCout_',num2str(N),'.txt'],[DT,I],';')
