%% MANUAL VIDEO ANALYSIS SCRIPT

% Read video
v=VideoReader('G -20181018_183602.mp4');

% Rewind up to frame 400 (Start)
for i = 1:400
    readFrame(v);
end
t0  = v.CurrentTime;

% Select 4 sensors
color = {'b','r','y','g'};
figure
imshow(readFrame(v))
for i = 1:4
    rect(i,:) = getrect;
    rectangle('Position',rect(i,:),'EdgeColor',color{i},'LineWidth',3)
end

% Plot the evolution of these 4 sensors pixels
vidFrame = readFrame(v);
V0       = rgb2gray(vidFrame);
for j = 1:4
    M0(j)= {V0(rect(j,2):(rect(j,2)+rect(j,4)),rect(j,1):(rect(j,1)+rect(j,3)))};
end

for i = 1:150
    vidFrame = readFrame(v);
    V0       = rgb2gray(vidFrame);
    
    for j = 1:4
        D(i,j) = mean(mean(abs(V0(rect(j,2):(rect(j,2)+rect(j,4)),rect(j,1):(rect(j,1)+rect(j,3))) - M0{j})));
    end
end
figure 
plot(D(:,1))
hold on
plot(D(:,2))
plot(D(:,3))
plot(D(:,4))

%% Analyze frames
v.CurrentTime = t0;
figure
k = 1;
while hasFrame(v) && k <= 150
    % Read frame and show image
    vidFrame = readFrame(v);
    imshow(vidFrame,'Parent', gca);
    title(['Frame ',num2str(k)])
    
    % Show rectangles
    for i = 1:4
        rectangle('Position',rect(i,:),'EdgeColor',color{i},'LineWidth',3)
    end
    
    % Fancy things
    currAxes.Visible = 'off';
    
    % Pause and update index
%     pause(1/v.FrameRate);
pause
    k = k+1;
end