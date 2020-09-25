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
    
    %                D1  D2  D3 T1MinMax T2MinMax T3MinMax
    kine = Kinematics(95,100,100,[-90,90;-46,90;-86,63]);
    
    height = 35;
    
    P1 = [100 -70 height];
    P2 = [160 10 height];
    P3 = [50 90 height];
    numberOfPoints = 5;

    
    pp.setSetpoints(rad2deg(kine.ik3001(P1)));
    %Make sure the robot is at the first point
    pause(2);
    
    pathObj = Path_Planner();
    pathPoints = pathObj.linear_traj(P1,P2,numberOfPoints);
    
    totalDuration = 2.0;
    I = Interpolator("Quintic",totalDuration/ (numberOfPoints-1));
    
    logger = Logger("log.txt");
    %logger's time 0 starts after robot is at P1
    
    for i = 1:numberOfPoints-1
        tic
        while toc < totalDuration / (numberOfPoints-1) %This gives segment duration
            scalar = I.get(toc);
            nextSetpoint = ((pathPoints(i+1,:)-pathPoints(i,:)).* scalar + pathPoints(i,:))
            pp.setSetpoints(rad2deg(kine.ik3001(nextSetpoint)));
            logger.logPositions(pp.getPositions());
            pause(0.03); %avoid the communication rate limit
        end
    end 
    
    pathPoints = pathObj.linear_traj(P2,P3,numberOfPoints);
    tic
    while toc < 2
        logger.logPositions(pp.getPositions());
    end
    
    for i = 1:numberOfPoints-1
        tic
        while toc < totalDuration / (numberOfPoints-1) %This gives segment duration
            scalar = I.get(toc);
            nextSetpoint = ((pathPoints(i+1,:)-pathPoints(i,:)).* scalar + pathPoints(i,:))
            pp.setSetpoints(rad2deg(kine.ik3001(nextSetpoint)));
            logger.logPositions(pp.getPositions());
            pause(0.03); %avoid the communication rate limit
        end
    end 
    
    pathPoints = pathObj.linear_traj(P3,P1,numberOfPoints);
    
    tic
    while toc < 2
        logger.logPositions(pp.getPositions());
    end
    
    for i = 1:numberOfPoints-1
        tic
        while toc < totalDuration / (numberOfPoints-1) %This gives segment duration
            scalar = I.get(toc);
            nextSetpoint = ((pathPoints(i+1,:)-pathPoints(i,:)).* scalar + pathPoints(i,:))
            pp.setSetpoints(rad2deg(kine.ik3001(nextSetpoint)));
            logger.logPositions(pp.getPositions());
            pause(0.03); %avoid the communication rate limit
        end
    end 
    
    logger.close()
    
    
catch exception
    getReport(exception)
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
pp.shutdown()
