% Algorithm to compare 2 different images and detect a hole position and
% diameter

% Parameters
spr = 0.1/100;

%% Load sample image and perturbate comparison images to get real images
J0 = rgb2gray(im2double(imread('Image0.jpg')));
I0 = J0(150:(end-150),300:(end-300),:); %% BASE COMPARISON IMAGE

% Rotate and move image
I1 = imrotate(J0,10);
I1 = imtranslate(I1,[15,20]);

% Put a dot (hole from space debris)
P  = [410,660];
I1(P(1):(P(1)+2),P(2):(P(2)+2)) = 0.1*I1(P(1):(P(1)+2),P(2):(P(2)+2));

% Slightly rotate each image of the comparison (ADCS perturbations)
I1 = imrotate(I1,0.1);
I2 = imrotate(I1,0.1);
I3 = imrotate(I2,0.1);
I4 = imrotate(I3,0.1);

% Crop images
dx = round((size(I1,1)-size(I0,1))/2);
dy = round((size(I1,2)-size(I0,2))/2);
lim= [dx,size(I1,1)-dx,dy,size(I1,2)-dy];
I1 = I1(lim(1):lim(2),lim(3):lim(4));

dx = round((size(I2,1)-size(I0,1))/2);
dy = round((size(I2,2)-size(I0,2))/2);
lim= [dx,size(I2,1)-dx,dy,size(I2,2)-dy];
I2 = I2(lim(1):lim(2),lim(3):lim(4));

dx = round((size(I3,1)-size(I0,1))/2);
dy = round((size(I3,2)-size(I0,2))/2);
lim= [dx,size(I3,1)-dx,dy,size(I3,2)-dy];
I3 = I3(lim(1):lim(2),lim(3):lim(4));

dx = round((size(I4,1)-size(I0,1))/2);
dy = round((size(I4,2)-size(I0,2))/2);
lim= [dx,size(I4,1)-dx,dy,size(I4,2)-dy];
I4 = I4(lim(1):lim(2),lim(3):lim(4));

% Add Gaussian Noise
I1 = imnoise(I1,'gaussian');
I2 = imnoise(I2,'gaussian');
I3 = imnoise(I3,'gaussian');
I4 = imnoise(I4,'gaussian');

% Add Salt & Pepper noise (space radiation)
I1 = imnoise(I1,'salt & pepper',spr);
I2 = imnoise(I2,'salt & pepper',spr);
I3 = imnoise(I3,'salt & pepper',spr);
I4 = imnoise(I4,'salt & pepper',spr);


%% Rotate, crop and filter space pictures taking the first as a reference (4)
I2c = correct_rotation(I1,I2);
I3c = correct_rotation(I1,I3);
I4c = correct_rotation(I1,I4);

% Remove the rotation corners.
I1c = I1(3:(end-3),3:end-3);
I2c = I2c(3:(end-3),3:end-3);
I3c = I3c(3:(end-3),3:end-3);
I4c = I4c(3:(end-3),3:end-3);

% Calculate the mean image (Reduced noise)
IC = (I1c+I2c+I3c+I4c)/4;

%% Rotate camera image (IC) to match original on-ground image (I0)
ICc= correct_rotation(I0,IC);

%% Detect hole
DIF = abs(ICc-I0);
DIF(ICc==0) = 0;

%% PLOTS
figure
subplot(1,2,1)
imshow(I0)
xlabel('Original Image')
subplot(1,2,2)
imshow(IC)
xlabel('Camera Image')

figure
subplot(2,2,1)
imshow(I1)
xlabel('Camera image 1')
subplot(2,2,2)
imshow(I2)
xlabel('Camera image 2')
subplot(2,2,3)
imshow(I3)
xlabel('Camera image 3')
subplot(2,2,4)
imshow(I4)
xlabel('Camera image 4')

figure
imagesc(DIF)
title('Difference between both images')

%% Save results
imwrite(I0,'./results/original_image.jpg')
imwrite(I1,'./results/camera_image_1.jpg')
imwrite(I2,'./results/camera_image_2.jpg')
imwrite(I3,'./results/camera_image_3.jpg')
imwrite(I4,'./results/camera_image_4.jpg')
imwrite(IC,'./results/camera_image_ensemble.jpg')
imwrite(ICc,'./results/camera_image_rotated.jpg')
imwrite(im2uint8(DIF),'./results/difference.jpg')