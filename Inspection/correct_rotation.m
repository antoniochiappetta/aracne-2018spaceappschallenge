function  I_end = correct_rotation(I0,I1)
% Addapted from Mathworks example
% Copyright 1993-2014 The MathWorks, Inc. 
%
% I0 = original image
% I1 = rotated image

% Debug pictures
debug = 0;

%% Find Matching Features Between Images
% Detect features in both images.
ptsI0  = detectSURFFeatures(I0);
ptsI1 = detectSURFFeatures(I1);

%%
% Extract feature descriptors.
[featuresI0, validPtsI0]  = extractFeatures(I0,  ptsI0);
[featuresI1, validPtsI1]    = extractFeatures(I1, ptsI1);

%%
% Match features by using their descriptors.
indexPairs = matchFeatures(featuresI0, featuresI1);

%%
% Retrieve locations of corresponding points for each image.
matchedI0  = validPtsI0(indexPairs(:,1));
matchedI1  = validPtsI1(indexPairs(:,2));

%%
% Show point matches. Notice the presence of outliers.
if debug
    figure;
    showMatchedFeatures(I0,I1,matchedI0,matchedI1);
    title('Putatively matched points (including outliers)');
end

%% Estimate Transformation
[tform, inlierI1, inlierI0] = estimateGeometricTransform(...
    matchedI1, matchedI0, 'similarity');

%%
% Display matching point pairs used in the computation of the
% transformation matrix.
if debug
    figure;
    showMatchedFeatures(I0,I1, inlierI0, inlierI1);
    title('Matching points (inliers only)');
    legend('ptsI0','ptsI1');
end

%% Solve for Scale and Angle
% Use the geometric transform, TFORM, to recover 
% the scale and angle. Since we computed the transformation from the
% I1 to the I0 image, we need to compute its inverse to 
% recover the distortion.
%
%  Let sc = scale*cos(theta)
%  Let ss = scale*sin(theta)
%
%  Then, Tinv = [sc -ss  0;
%                ss  sc  0;
%                tx  ty  1]
%
%  where tx and ty are x and y translations, respectively.
%

%%
% Compute the inverse transformation matrix.
Tinv  = tform.invert.T;

ss = Tinv(2,1);
sc = Tinv(1,1);
scale_recovered = sqrt(ss*ss + sc*sc);
theta_recovered = atan2(ss,sc)*180/pi;

%%
% The recovered values should match your scale and angle values selected in
% *Step 2: Resize and Rotate the Image*.

%%  Recover the I0 Image
% Recover the I0 image by transforming the I1 image.
outputView = imref2d(size(I0));
I_end      = imwarp(I1,tform,'OutputView',outputView);

%%
% Compare |recovered| to |I0| by looking at them side-by-side in a montage.
if debug
    figure, imshowpair(I0,recovered,'montage')
end