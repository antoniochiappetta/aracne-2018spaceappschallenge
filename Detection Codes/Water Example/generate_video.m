%% Generate GIF video with impact in low speed

% Parameters
legendpos = [520,60];
legendstp = 150;
color = {'b','r','y','g'};
dt        = 0; %s

% Read video and load parameters
v=VideoReader('G -20181018_183602.mp4');
load('impact_analysis.mat')

% Rewind up to frame 390 (Start)
for i = 1:390
    readFrame(v);
end

% Save pictures to video folder and write GIF
figure

for i = 1:2*max(T)
    I = readFrame(v);
    imshow(I)
    hold on
    text(50,50,['\bf t = ',num2str(i),'fr'],...
                'FontSize',16,'Color','w')
    if i > 15
    text(PI(1)+30,PI(2)+30,'\bf v_{wave}=15 px/fr',...
                'FontSize',16,'Color','w')
    end
    
    % Draw circles and times
    for j = 1:length(T)
        if i >= T(j)
            viscircles(P(j,:),15,'Color',color{j},'LineWidth',2)
            text(P(j,1)-50,P(j,2)-50,['\bf \Delta t_',num2str(j),'=',num2str(T(j)-T(1)),' fr'],...
                'FontSize',16,'Color',color{j})
        end
    end
    
    hold off
    
    % Save GIF
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    
    % Crop margins
    imind = imind(34:886,92:571);
    
    % Write to the GIF File
    if i == 1
        imwrite(imind,cm,['./video/watgif.gif'],'gif', 'Loopcount',inf,'DelayTime',dt);
    else
        imwrite(imind,cm,['./video/watgif.gif'],'gif','WriteMode','append');
    end
    
    % Store images
    imwrite(im(34:886,92:571,:),['./video/img',num2str(i),'.jpg'],'jpg')
end