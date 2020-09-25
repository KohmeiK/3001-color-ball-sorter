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
    viaPoints = 30;

    pp.setSetpoints(rad2deg(kine.ik3001(P1)));
    %Make sure the robot is at the first point
    pause(2);
    
    planner = Traj_Planner();
    startTime = datetime; %start time if when the whole loop starts
    lasttime = datetime; %last time is when the last line segment is done
    
    
    %from P1 to P2
    pathObj = Path_Planner();
    path = pathObj.linear_traj(P1,P2,viaPoints);
    
    logger = Logger("log.txt");
    
    %Here's the new block of code
    for i = 1:viaPoints-1
        t0 = milliseconds(lasttime-startTime); %duration in ms since this line set started
        t1 = milliseconds(datetime-startTime); %duration in ms since the whole movement started
        % 100ms  from p(i) => p(i+1) no velocity
       
        I = Interpolator("Cubic",5);
        
        %Arjun used an inner loop but I'm not sure what its parameter
        %should be
        while ????
            delta_t = t0;
            pos_x = I.get(delta_t);
            x = (P3(1) - P1(1)) * pos_x + P1(1);
            pos_y = I.get(delta_t);
            y = (P3(2) - P1(2)) * pos_y + P1(2);
            pos_z = I.get(delta_t);
            x = (P3(3) - P1(3)) * pos_z + P1(3);
            
            %I'm not sure how exactly to use the lines below, I need to
            %calc the ik with pos_x,y,z and set the setpoints to that but
            %I'm not sure which methods do that exactly
            pp.setSetpoints(rad2deg(kine.ik3001(planner.trajExecute3(lasttime))));
            logger.logPositions(pp.getPositions());
            pause(0.03);
            disp(i)
        end
    end

    %from P2 to P3
    timerStart = datetime;
    while seconds(datetime - timerStart) < 2
        logger.logPositions(pp.getPositions());
    end
    
    startTime = datetime; %start time if when the whole loop starts
    lasttime = datetime; %last time is when the last line segment is done
    path = pathObj.linear_traj(P2,P3,viaPoints);
    for i = 1:viaPoints-1
        t0 = milliseconds(lasttime-startTime); %duration in ms since this line set started
        t1 = milliseconds(datetime-startTime); %duration in ms since the whole movement started
        % 100ms  from p(i) => p(i+1) no velocity
        planner = planner.trajTask(path, i, 300);
        lasttime = datetime;
        while milliseconds(datetime - lasttime) < 300
            pp.setSetpoints(rad2deg(kine.ik3001(planner.trajExecute3(lasttime))));
            logger.logPositions(pp.getPositions());
            pause(0.03);
        end %we are done with this segment, now do the next segment
    end
    timerStart = datetime;
    while seconds(datetime - timerStart) < 2
        logger.logPositions(pp.getPositions());
    end
    
    %from P3 to P1
    startTime = datetime; %start time if when the whole loop starts
    lasttime = datetime; %last time is when the last line segment is done
    path = pathObj.linear_traj(P3,P1,viaPoints);
    for i = 1:viaPoints-1
        t0 = milliseconds(lasttime-startTime); %duration in ms since this line set started
        t1 = milliseconds(datetime-startTime); %duration in ms since the whole movement started
        % 100ms  from p(i) => p(i+1) no velocity
        planner = planner.trajTask(path, i, 300);
        lasttime = datetime;
        while milliseconds(datetime - lasttime) < 300
            pp.setSetpoints(rad2deg(kine.ik3001(planner.trajExecute3(lasttime))));
            logger.logPositions(pp.getPositions());
            pause(0.03);
        end %we are done with this segment, now do the next segment
    end
    timerStart = datetime;
    while seconds(datetime - timerStart) < 2
        logger.logPositions(pp.getPositions());
    end
    
    logger.close();
    
    %     LAB3 SECTION 4.2
    %     pp = pp.updateRobot();
    %     pause(3);
    %
    %     p1 = rad2deg(kine.ik3001(P1));
    %     p2 = rad2deg(kine.ik3001(P2));
    %     p3 = rad2deg(kine.ik3001(P3));
    %
    %     numOfPoints = 10.0;
    %     t0 = 0;
    %
    %     t1 = 970;
    %     planner = Traj_Planner();
    %     planner = planner.pointTo(p1,p2,t0,t1);
    %     starttime = datetime;
    %     for i = 1:numOfPoints
    %         pp.setSetpoints(planner.trajExecute(starttime));
    %         pause(t1/(1000.0*(numOfPoints)));
    %
    %     end
    %     pause(2);
    %
    %     t1 = 1141;
    %     planner = Traj_Planner();
    %     planner = planner.pointTo(p2,p3,t0,t1);
    %     starttime = datetime;
    %     for i = 1:numOfPoints
    %         pp.setSetpoints(planner.trajExecute(starttime));
    %         pause(t1/(1000.0*(numOfPoints)));
    %     end
    %     pause(2);
    %
    %     t1 = 1010;
    %     planner = Traj_Planner();
    %     planner = planner.pointTo(p3,p1,t0,t1);
    %     starttime = datetime;
    %     for i = 1:numOfPoints
    %         pp.setSetpoints(planner.trajExecute(starttime));
    %         pause(t1/(1000.0*(numOfPoints)));
    %     end
    
    
catch exception
    getReport(exception)
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
pp.shutdown()
