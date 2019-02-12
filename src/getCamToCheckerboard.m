function T_cam_to_checker = getCamToCheckerboard(imOrig, cameraParams, worldPoints)
% GETCAMTOCHECKERBOARD calculates the matrix to convert from camera coordinates to the checkerboard coordinates
%
%   imOrig - the undistorted image of the workspace, containing a
%   checkerboard
%
%   cameraParams - the estimated camera parameters
%   
%   worldPoints - the world points that are populated after calling
%   params.m

    [im, newOrigin] = undistortImage(imOrig, cameraParams, 'OutputView', 'full');


    %% Convert to reference frame of the board
    % Detect the checkerboard.
    [imagePoints, boardSize] = detectCheckerboardPoints(im);

    % Adjust the imagePoints so that they are expressed in the coordinate system
    % used in the original image, before it was undistorted.  This adjustment
    % makes it compatible with the cameraParameters object computed for the original image.
    imagePoints = imagePoints + newOrigin; % adds newOrigin to every row of imagePoints

    % Compute rotation and translation of the camera.
    [R, t] = extrinsics(imagePoints, worldPoints, cameraParams);
    
    T_cam_to_checker = [R t'; 0 0 0 1];
    
    %% draw and label axes
    axesPoints = worldToImage(cameraParams, R, t, [0 0 0; 0 50 0; 50 0 0]);
    
    x1 = [axesPoints(1,1) axesPoints(2,1)]';
    y1 = [axesPoints(1,2) axesPoints(2,2)]';

    im = insertText(im, [x1(2) y1(2)], 'Y Axis', 'TextColor', 'red', 'FontSize', 18);
    
    x2 = [axesPoints(1,1) axesPoints(3,1)]';
    y2 = [axesPoints(1,2) axesPoints(3,2)]';
    
    im = insertText(im, axesPoints(3,1:2), 'X Axis', 'TextColor', 'red', 'FontSize', 18);
    
    imshow(im)
    title('Undistorted Image with checkerboard axes');
    line(x1, y1,'lineWidth', 5, 'Color', 'red');
    line(x2, y2,'lineWidth', 5, 'Color', 'red');

end