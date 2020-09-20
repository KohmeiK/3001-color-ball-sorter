%%
% RBE3001 - Main Controller File
% Boilerplate until line 32

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
    
    kine = Kinematics(95,100,100,[-90,90;-46,90;-86,63]);
    %disp(kine.FKtoTip([0 24.1679 13.5916]))
    disp(rad2deg(kine.ik3001([120 0 125])));
    
    %Create a ball and stick model
    %     virutalArm = Model();
    %Create a new log file
        logger = Logger('log.txt');
    
    %queue a 4 points to form a triangle
    disp(rad2deg(kine.ik3001([80 -70 0])));
    
    height = 25;
    
    
    pp = pp.enqueueSetpoint(rad2deg(kine.ik3001([100 -70 height])));
    pp = pp.enqueueSetpoint(rad2deg(kine.ik3001([160 10 height])));
    pp = pp.enqueueSetpoint(rad2deg(kine.ik3001([50 90 height])));
    pp = pp.enqueueSetpoint(rad2deg(kine.ik3001([100 -70 height])));
   

    %give the simulation time to load
    %the plot starts loading when some values are added
    %     virutalArm.plotArm([0 0 0]);
    %     pause(3);
    
    currPos = [0 0 0]; %give this a inital value
    while pp.isActive
        %run the arm upadte loop
        pp = pp.updateRobot();
        
        
        
        %get the most recent arm pos
        currPos = pp.getPositions();
%         disp(pp.currentSetpoint);
        
        %log that arm pos
        logger.logPositions(round(currPos,2));
        
        %display the arm pos in the model
        %         virutalArm.plotArm(currPos);
        
        
    end
    %close the log file
%     logger = logger.close();
    
    
catch exception
    getReport(exception)
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
pp.shutdown()
