%% TRIANGULATION SCRIPT

% Load data
load('impact_analysis.mat')
load('T0_image.mat')

% Calculate time matrix
DT  = repmat(T,1,4)-repmat(T',4,1);
CDT = vel*DT;

% Plot hyperbolas
figure
imshow(I)
hold on
for i = 1:3
    for j = (i+1):4
        cdt = CDT(i,j);
        V1  = P(i,:);
        V2  = P(j,:);
        fimplicit(@(x,y) hyperbola(x,y,V1,V2,cdt),'LineWidth',2)
    end
end
plot(PI(1),PI(2),'r+')