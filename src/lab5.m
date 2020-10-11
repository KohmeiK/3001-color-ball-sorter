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
    
%     % Set up camera
%     if cam.params == 0
%         error("No camera parameters found!");
%     end
%     
%     
%     %outputs a transformation Matrix
%     cam.cam_pose = cam.getCameraPose();
%     randompoint = pointsToWorld(cam.params.Intrinsics, cam.cam_pose(1:3,1:3), cam.cam_pose(1:3,4), [100 100]);
%     basePose = cam.cam_pose * cam.check2base;
%     
%     disp("Cal Done");
%     pause;


%Initializing states
mainState = mainStates.HOME; 
nextState = mainStates.HOME;

%Creating objects
homeObj = Home();
approachObj = Approach();
grabObj = Grab();
travelObj = Travel();
dropObj = Drop();
debugObj = Debug();

%Creating Global Variables
% cordx = 
% cordy =
% cordz =
armDownPos = [cordx, cordy, cordz]; %xyz coordinates for moving the arm down in the grab state
destination = [0 0 0];

while true
    switch(mainState)
        case homeState.HOME
            homeObj.startHome();
            nextState = mainStates.APPROACH;
            mainState = mainStates.DEBUG;
        case homeState.APPROACH
            approachObj.startObj();
            nextState = mainStates.GRAB;
            mainState = mainStates.DEBUG;
        case homeState.GRAB
            grabObj.downPos = armDownPos;
            grabObj.startGrab();
            nextState = mainStates.TRAVEL;
            mainState = mainStates.DEBUG;
        case homeState.TRAVEL
%             destination = [] %set destination
            travelObj.dest = destination;
            travelObj.startTravel();
            nextState = mainStates.DROP;
            mainState = mainStates.DEBUG;
        case homeState.DROP
            dropObj.startDrop();
            nextState = mainStates.HOME;
            mainState = mainStates.DEBUG;
        case homeState.DEBUG
    end
end

    
catch exception
    fprintf('\n ERROR!!! \n \n');
    disp(getReport(exception));
    disp('Exited on error, clean shutdown');
end

%% Shutdown Procedure
robot.shutdown()
cam.shutdown()
