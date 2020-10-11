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
    
    newImg = snapshot(cam.cam);
    imshow(newImg);
    randompoint2 = pointsToWorld(cam.params.Intrinsics, cam.cam_pose(1:3,1:3), cam.cam_pose(1:3,4), [115 202]);
    randompoint3 = pointsToWorld(cam.params.Intrinsics, cam.cam_pose(1:3,1:3), cam.cam_pose(1:3,4), [67 373]);
    randompoint4 = pointsToWorld(cam.params.Intrinsics, cam.cam_pose(1:3,1:3), cam.cam_pose(1:3,4), [555 378]);
    randompoint5 = pointsToWorld(cam.params.Intrinsics, cam.cam_pose(1:3,1:3), cam.cam_pose(1:3,4), [516 252]);
    
    
    
    
    testPoint2 = ([randompoint2(1) randompoint2(2) 0]  + (cam.check2base(1:3, 4))') * cam.check2base(1:3,1:3);
    testPoint3 = ([randompoint3(1) randompoint3(2) 0]  + (cam.check2base(1:3, 4))') * cam.check2base(1:3,1:3);
    testPoint4 = ([randompoint4(1) randompoint4(2) 0]  + (cam.check2base(1:3, 4))') * cam.check2base(1:3,1:3);
    testPoint5 = ([randompoint5(1) randompoint5(2) 0]  + (cam.check2base(1:3, 4))') * cam.check2base(1:3,1:3);
    
    disp(testPoint2);
    disp(testPoint3);
    disp(testPoint4);
    disp(testPoint5);
    
    
    
    
catch exception
    fprintf('\n ERROR!!! \n \n');
    disp(getReport(exception));
    disp('Exited on error, clean shutdown');
end

%% Shutdown Procedure
robot.shutdown()
cam.shutdown()
