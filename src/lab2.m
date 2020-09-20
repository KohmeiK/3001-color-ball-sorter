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
    
    
%     pp = pp.enqueueSetpoint(rad2deg(kine.ik3001([100 -70 height])));
%     pp = pp.enqueueSetpoint(rad2deg(kine.ik3001([160 10 height])));
%     pp = pp.enqueueSetpoint(rad2deg(kine.ik3001([50 90 height])));
    pp = pp.enqueueSetpoint(rad2deg(kine.ik3001([100 -70 height])));
   
    pp = pp.updateRobot();
    pp = pp.updateRobot();
    pp = pp.updateRobot();
    pp = pp.updateRobot();
    %Make sure the robot is at the first point
    pause(3);
    
    p1 = rad2deg(kine.ik3001([100 -70 height]));
    p2 = rad2deg(kine.ik3001([160 10 height]));
    
    disp(p1); %startin point
    disp(p2); %end point
    
    n = 11;
    %Imagine a line between point 1 nad p2
    
    %Now put 11 evenly spaced points along the line
    %Each point is stored in P, (11x3 matrix)
    t = linspace(0,1,n)';
    P = (1-t)*p1 + t*p2;
    
    %Now there are 10 line segments between p1 and p2
    
    planner = Traj_Planner();
    startTime = datetime; %start time if when the whole loop starts
    lasttime = datetime; %last time is when the last line segment is done
    
    for i = 1:10
        t0 = milliseconds(lasttime-startTime); %duration in ms since this line set started
        t1 = milliseconds(datetime-startTime); %duration in ms since the whole movement started
        
        %                            100ms  from p(i) => p(i+1) no velocity
        planner = planner.cubic_traj([0 100],[P(i,1) P(i+1,1)],[0 0],1);
        planner = planner.cubic_traj([0 100],[P(i,2) P(i+1,2)],[0 0],2);
        planner = planner.cubic_traj([0 100],[P(i,3) P(i+1,3)],[0 0],3);
        
        %update start time for this segment since we are starting a new
        %segment
        lasttime = datetime;
        k = 0;
        
        %     make sure this segment runs for 100ms only
        while milliseconds(datetime - lasttime) < 100
            k = k + 1; %just for debuging
            disp(k);%just for debuging
            
            %tnow = how long has this segment been running?
            tnow = milliseconds(datetime - lasttime);
            
            %solve the cubic seperatley for each theta
            t1 = planner.solveEQ(tnow,1); %Theta 1
            t2 = planner.solveEQ(tnow,2); %Theta 2
            t3 = planner.solveEQ(tnow,3); %Theta 3
            disp([t1 t2 t3]); %debug
            pp.setSetpoints([t1 t2 t3]); %tell the robot to go to where the cubic says
        end %we are done with this segment, now do the next segment
        %Remember - each line that connects two setpoitns has 10 segments
        disp(i);
    end
    
    %close the log file
%     logger = logger.close();
    
    
catch exception
    getReport(exception)
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
pp.shutdown()
