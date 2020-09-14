%%
% RBE3001 - Laboratory 1
%
% Instructions
% ------------
% Welcome again! This MATLAB script is your starting point for Lab
% 1 of RBE3001. The sample code below demonstrates how to establish
% communication between this script and the Nucleo firmware, send
% setpoint commands and receive sensor data.
%
% IMPORTANT - understanding the code below requires being familiar
% with the Nucleo firmware. Read that code first.

% Lines 15-37 perform necessary library initializations. You can skip reading
% to line 38.
clear
clear java
clear classes;
clear functions;
close all

vid = hex2dec('16c0');
pid = hex2dec('0486');

disp (vid);
disp (pid);

javaaddpath ../lib/SimplePacketComsJavaFat-0.6.4.jar;
import edu.wpi.SimplePacketComs.*;
import edu.wpi.SimplePacketComs.device.*;
import edu.wpi.SimplePacketComs.phy.*;
import java.util.*;
import org.hid4java.*;
version -java
myHIDSimplePacketComs=HIDfactory.get();
myHIDSimplePacketComs.setPid(pid);
myHIDSimplePacketComs.setVid(vid);
myHIDSimplePacketComs.connect();

% Create a PacketProcessor object to send data to the nucleo firmware
pp = Robot(myHIDSimplePacketComs);
try
    
    SERV_ID = 1848;            % we will be talking to server ID 1848 on
    % the Nucleo
    SERVER_ID_READ =1910;% ID of the read packet
    DEBUG   = true;          % enables/disables debug prints
%     virutalArm = Model();
    logger = Logger('log.txt');
    
    pp = pp.enqueueSetpoint([0,0,0]);
    pp = pp.enqueueSetpoint([-24,102,-72]);
    pp = pp.enqueueSetpoint([90,61,-13]);
    pp = pp.enqueueSetpoint([0,0,0]);
    
    %give the simulation time to load
%     virutalArm.plotArm([0 0 0]);
%     pause(3);
    
    currPos = [0 0 0];
    while pp.isActive
        pp = pp.updateRobot();
        currPos = pp.getPositions();
        
        logger.logPositions(round(currPos,2));
%         virutalArm.plotArm(currPos);
    end
    logger = logger.close();
    
    
    
    
catch exception
    getReport(exception)
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
pp.shutdown()
