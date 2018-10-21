%% Analyze BigML output data

% Parameters
NV = [100,500,1000];

% Import BigML data and show correlation parameters
figure
hold on
grid on
plot([-5,5],[-5,5])
leg = [];
for N = NV
    [X_obj,X_est] = importBigML(['./BigMLout/BigML_',num2str(N),'.csv']);
    plot(X_obj,X_est,'+')
    [~,gof] = fit(X_obj,X_est,'poly1');
    xlabel('X_{real} (m)')
    ylabel('X_{estimated} (m)')
    leg = [leg,{['N = ',num2str(N),' ','(R^2=',num2str(gof.rsquare),')']}];
end
legend(leg)