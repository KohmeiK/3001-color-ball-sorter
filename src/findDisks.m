
function [imDetectedDisk, robotFramePose, diskDia] = findDisks(im, T_checker_to_robot, T_cam_to_checker, cameraParams)
% FINDDISKS does the computer vision work. This is a skeleton you can use
% to help you with the final project. Feel free to edit this as needed or
% make your own function.
%
% returned variables:
% imDetectedDisk - the labeled image of disks
% robotFramePose - the coordinates of the located disks in the robots
% reference frame
% diskDia - the diameters of the located disks
%
% input variables:
% im - the raw image of the workspace
% T_checker_to_robot - the transformation matrix to relate the checkerboard
% and robot reference frames
% T_cam_to_checker - the transformation matrix to relate the camera
% and checkerboard reference frames (output after home_frame_setup)
% cameraParams - the estimated camera parameters


%% first, undistort the image
[im, ~] = undistortImage(imOrig, cameraParams, 'OutputView', 'full');

%% Then, segment the image







%% Find the circles (centers and radii)
 





%% calculate the image coordinates of the circles you've found (in terms of pixels)
    
    






%% Convert the pixel values to the checkerboard reference frame  

R = T_cam_to_checker(1:3,1:3);
t = T_cam_to_checker(1:3,4);

%worldPoints = pointsToWorld(cameraParams, R, t, YOUR_PIXEL_VALUES);
% (check https://www.mathworks.com/help/vision/ref/cameraparameters.pointstoworld.html
%  for details on dimensions expected for YOUR_PIXEL_VALUES)

%% Compute the diameter of the coin in millimeters.






%diskDia = ???;

%% find the center of the circles with respect to the robot's reference frame






%robotFramePose = ???;

%% Label the orignal image for the disks.






%imDetectedDisk = ???;

end

