%%
% RBE 3001 Lab 5 example code!
% Developed by Alex Tacescu (https://alextac.com)
%%
clc;
clear;
clear java;
format short

%% Flags
DEBUG = true;
STICKMODEL = false;
DEBUG_CAM = false;

%% Setup
vid = hex2dec('16c0');
pid = hex2dec('0486');

if DEBUG
    disp(vid);
    disp(pid);
end

javaaddpath ../lib/SimplePacketComsJavaFat-0.6.4.jar;
import edu.wpi.SimplePacketComs.*;
import edu.wpi.SimplePacketComs.device.*;
import edu.wpi.SimplePacketComs.phy.*;
import java.util.*;
import org.hid4java.*;
version -java;
myHIDSimplePacketComs=HIDfactory.get();
myHIDSimplePacketComs.setPid(pid);
myHIDSimplePacketComs.setVid(vid);
myHIDSimplePacketComs.connect();

robot = Robot(myHIDSimplePacketComs);
kine = Kinematics(95,100,100,[-90,90;-46,90;-86,63]);

cam = Camera();
cam.DEBUG = DEBUG_CAM;

%% Place Poses per color
purple_place = [150, -50, 11];
green_place = [150, 50, 11];
pink_place = [75, -125, 11];
yellow_place = [75, 125, 11];


%% Main Loop
try
    
    % Set up camera
    if cam.params == 0
        error("No camera parameters found!");
    end
    
    
    %outputs a transformation Matrix
    cam.cam_pose = cam.getCameraPose();
    randompoint = pointsToWorld(cam.params.Intrinsics, cam.cam_pose(1:3,1:3), cam.cam_pose(1:3,4), [100 100]);
    basePose = cam.cam_pose * cam.check2base;
    
    disp("Cal Done");
    pause;
    
    while true
        %Image Aquisition
%         figure;
        newImg = snapshot(cam.cam);
    %     imshow(newImg);

        %Image Undistortion
%         figure;
        [undistortedIM, newOrigin] = undistortImage(newImg, cam.params.Intrinsics, 'OutputView', 'full');
%         imshow(undistortedIM);

        % Convert the image to the HSV color space.
        [BW,Mask] = yellowMask(undistortedIM);

    %     imshow(Mask);
    %     imshow(BW);

        %Dialate the black and white image
        dilated = imdilate(BW,strel('square',10));
    %     imshow(dilated);

        %Erode the dialated image from previous step
        eroded = imerode(dilated, strel('square', 15));
    %     imshow(eroded);
        L = bwlabel(eroded);
        stats = regionprops('struct', L, 'Centroid');
        
        if ~isempty(stats)
            CurrentOrbPos = pointsToWorld(cam.params.Intrinsics, cam.cam_pose(1:3,1:3), cam.cam_pose(1:3,4), [stats.Centroid(1) stats.Centroid(2)]);
            testPoint2 = ([CurrentOrbPos(1) CurrentOrbPos(2) 10]  + (cam.check2base(1:3, 4))') * cam.check2base(1:3,1:3);
            disp(testPoint2);
            
            testPoint2(3) = 30;
            
            robot.setSetpointsSlow(kine.ik3001(testPoint2));
        end
        
        pause(1);
    end
    
catch exception
    fprintf('\n ERROR!!! \n \n');
    disp(getReport(exception));
    disp('Exited on error, clean shutdown');
end

%% Shutdown Procedure
robot.shutdown()
cam.shutdown()
