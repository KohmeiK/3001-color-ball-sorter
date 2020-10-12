classdef RobotStateMachine
    %HOME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        state
        timer
        robot
        pathPlanner
        isRobotDone
    end
    
    methods
        function obj = RobotStateMachine()
            
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
            
            obj.robot = Robot(myHIDSimplePacketComs);
            obj.pathPlanner = Path_Planner();
            obj.state = robotState.INIT;
            obj.timer = EventTimer();
        end
        
        function obj = update(obj)
            switch(obj.state)
                case robotState.INIT
                    obj.robot.setSetpointsSlow = ([0 0 0]);
                    obj.timer = obj.timer.setTimer(3);
                    obj.state = robotState.COMMS_WAIT;
                case robotState.COMMS_WAIT
                    if obj.timer.isTimerDone == 1
                        obj.state = robotState.UPDATE;
                    end
                case robotState.UPDATE
                    [obj.robot, obj.isRobotDone, setPoint] = obj.robot.update(obj);
                    obj.robot.setSetpoints(setPoint);
                case robotState.IDLE
                    %do nothing
                    
            end
            
        end
        
        function obj = pathPlanTo(obj,goal)
                              %   Self
                              % Target point [3x1]
                              % Time total duration in ms
                              % number of linspace points
                              % 3 = cubic, 5 = linear, Hard Coded to 5
            
            scaledVals = obj.trajScaler(goal);                   
            time = scaledVals(1);
            numPoints = scaledVals(2);
            obj.pathPlanner = obj.pathPlanner.startPath(obj.robot.getPositions(),goal,time,numPoints,5);
        end
        
        function scaledVals = trajScaler(obj,finalPos)
            currXYZ = obj.robot.getPositions();
            targetXYZ = finalPos;
            distance = sqrt(sum((targetXYZ - currXYZ) .^ 2));
            scaledVals = [(((distance/250) * 8) + 2) (((distance/250) * 15) + 5)];
           
        end
    end
    
end



