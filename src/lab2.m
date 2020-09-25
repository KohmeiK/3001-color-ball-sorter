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
    viaPoints = 5;

    pp.setSetpoints(rad2deg(kine.ik3001(P1)));
    %Make sure the robot is at the first point
    pause(2);
    
    planner = Traj_Planner();
    
    %from P1 to P2
    pathObj = Path_Planner();
    path = pathObj.linear_traj(P1,P2,viaPoints);
   
    logger = Logger("log.txt");
    
    %Here's the new block of code
    for i = 1:viaPoints-1
        % 100ms  from p(i) => p(i+1) no velocity
        I = Interpolator("Cubic",2); %do we need a new instace of this for
        %every line segement?
        %I'm not sure, I think we can do it that way
        
        tic
        while %Still not sure what goes here, what I had was wrong
            delta_t = toc;
            
            pos_x = I.get(delta_t);
            x = (P3(1) - P1(1)) * pos_x + P1(1);
            pos_y = I.get(delta_t);
            y = (P3(2) - P1(2)) * pos_y + P1(2);
            pos_z = I.get(delta_t);
            x = (P3(3) - P1(3)) * pos_z + P1(3);
            
            %I'm not sure how exactly to use the lines below, I need to
            %calc the ik with pos_x,y,z and set the setpoints to that but
            %I'm not sure which methods do that exactly
            %calcIK -> [t1 t2 t3] = Kinematics.ik3001([x y z])
            %settingsetpoints -> [no return] pp.setSetpoint[t1 t2 t3]
            calcIK = kine.ik3001([pos_x pos_y pos_z]);
            pp.setSetpoints(calcIK);
            logger.logPositions(pp.getPositions());
            pause(0.03);
            disp(i)
        end
    end 
    logger.close()
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
