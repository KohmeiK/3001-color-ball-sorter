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
    pause(3);
    
    p1 = rad2deg(kine.ik3001([100 -70 height]));
    p2 = rad2deg(kine.ik3001([160 10 height]));
    
    disp(p1);
    disp(p2);
    
    n = 11;
    
    t = linspace(0,1,n)';
    P = (1-t)*p1 + t*p2;
    
    planner = Traj_Planner();
    startTime = datetime;
    lasttime = datetime;
    
    for i = 1:10
        t0 = milliseconds(lasttime-startTime);
        t1 = milliseconds(datetime-startTime);
        
        planner = planner.cubic_traj([0 100],[P(i,1) P(i+1,1)],[0 0],1);
        planner = planner.cubic_traj([0 100],[P(i,2) P(i+1,2)],[0 0],2);
        planner = planner.cubic_traj([0 100],[P(i,3) P(i+1,3)],[0 0],3);
        
        lasttime = datetime;
        k = 0;
        while milliseconds(datetime - lasttime) < 100
            k = k + 1;
            disp(k);
            tnow = milliseconds(datetime - lasttime);
            t1 = planner.solveEQ(tnow,1);
            t2 = planner.solveEQ(tnow,2);
            t3 = planner.solveEQ(tnow,3);
            disp([t1 t2 t3]);
            pp.setSetpoints([t1 t2 t3]);
        end
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
