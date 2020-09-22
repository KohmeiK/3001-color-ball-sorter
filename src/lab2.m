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

% disp (vid);
% disp (pid);

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
                     %D1  D2  D3 T1MinMax T2MinMax T3MinMax
    kine = Kinematics(95,100,100,[-90,90;-46,90;-86,63]);
    
    height = 35;
    P1 = [100 -70 height];
    P2 = [160 10 height];
    P3 = [50 90 height];
    
    pp = pp.enqueueSetpoint(rad2deg(kine.ik3001(P1))); 
   
    pp = pp.updateRobot();
    pp = pp.updateRobot();
    pause(3);
    
    p1 = rad2deg(kine.ik3001(P1));
    p2 = rad2deg(kine.ik3001(P2));
    p3 = rad2deg(kine.ik3001(P3));
    
    numOfPoints = 10.0;
    t0 = 0;    
    
    t1 = 970;
    planner = Traj_Planner();
    planner = planner.pointTo(p1,p2,t0,t1);
    starttime = datetime;
    for i = 1:numOfPoints
        pp.setSetpoints(planner.trajExecute(starttime));
        pause(t1/(1000.0*(numOfPoints)));
    end
    pause(2);
    
    t1 = 1141;
    planner = Traj_Planner();
    planner = planner.pointTo(p2,p3,t0,t1);
    starttime = datetime;
    for i = 1:numOfPoints
        pp.setSetpoints(planner.trajExecute(starttime));
        pause(t1/(1000.0*(numOfPoints)));
    end
    pause(2);
    
    t1 = 1010;
    planner = Traj_Planner();
    planner = planner.pointTo(p3,p1,t0,t1);
    starttime = datetime;
    for i = 1:numOfPoints
        pp.setSetpoints(planner.trajExecute(starttime));
        pause(t1/(1000.0*(numOfPoints)));
    end
    
catch exception
    getReport(exception)
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
pp.shutdown()
