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
    %Make sure the robot is at the first point
    pause(2);
    
%     p1 = rad2deg(kine.ik3001([100 -70 height]));
%     p2 = rad2deg(kine.ik3001([160 10 height]));
    
    p1 = [100 -70 height];
    p2 = [160 10 height];
    
    disp(p1); %startin point
    disp(p2); %end point
    
%     n = 11;
%     %Imagine a line between point 1 nad p2
%     
%     %Now put 11 evenly spaced points along the line
%     %Each point is stored in P, (11x3 matrix)
%     t = linspace(0,1,n)';
%     P = (1-t)*p1 + t*p2;
%     
%     %Now there are 10 line segments between p1 and p2
%     
    planner = Traj_Planner();
    startTime = datetime; %start time if when the whole loop starts
    lasttime = datetime; %last time is when the last line segment is done
    
    path = Path_Planner();
    path = path.linear_traj(p1,p2);

    for i = 1:10
        t0 = milliseconds(lasttime-startTime); %duration in ms since this line set started
        t1 = milliseconds(datetime-startTime); %duration in ms since the whole movement started
        
        %                            100ms  from p(i) => p(i+1) no velocity
        planner = planner.cubic_traj([0 100],[path(i,1) path(i+1,1)],[0 0],1);
        planner = planner.cubic_traj([0 100],[path(i,2) path(i+1,2)],[0 0],2);
        planner = planner.cubic_traj([0 100],[path(i,3) path(i+1,3)],[0 0],3);
        
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
            
            %solve the cubic seperatley for each x, y, z
            t1 = planner.solveEQ(tnow,1); %x
            t2 = planner.solveEQ(tnow,2); %y
            t3 = planner.solveEQ(tnow,3); %z
            disp([t1 t2 t3]); %debug
            pp.setSetpoints(rad2deg(kine.ik3001([t1 t2 t3]))); %tell the robot to go to where the cubic says
        end %we are done with this segment, now do the next segment
        %Remember - each line that connects two setpoitns has 10 segments
        disp(i);
        
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
