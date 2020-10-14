classdef RobotStateMachine
    %HOME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        state
        timer
        robot
        pathPlanner
        isRobotDone
        kine
    end
    
    methods
        function obj = RobotStateMachine()
            %% Setup
            vid = hex2dec('16c0');
            pid = hex2dec('0486');
            
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
            
            obj.kine = Kinematics(95,100,100,[-90,90;-46,90;-86,63]);
            obj.robot = Robot(myHIDSimplePacketComs);
            obj.pathPlanner = Path_Planner();
            obj.state = robotState.INIT;
            obj.timer = EventTimer();
        end
        
        function obj = update(obj)
            switch(obj.state)
                case robotState.INIT
%                     disp("RobotSM = INIT SENT MOVE COMMAND")
                    obj.robot.setSetpointsSlow([-70 0 0]);
                    obj.timer = obj.timer.setTimer(0.003);
                    obj.state = robotState.IDLE;
                case robotState.COMMS_WAIT
%                     disp("RobotSM = COMMS WAIT")
                    if obj.timer.isTimerDone == 1
                        obj.state = robotState.UPDATE;
                    end
                case robotState.UPDATE
%                     disp("RobotSM = UPDATE")
                    [obj.pathPlanner, obj.isRobotDone, setPoint] = obj.pathPlanner.update();
                    obj.robot.setSetpoints(obj.kine.ik3001(setPoint));
                    obj.state = robotState.COMMS_WAIT;
                case robotState.IDLE
%                     disp("RobotSM = IDLE")
                    %do nothing
                    
            end
            
        end
        
        function obj = pathPlanTo(obj,goal)
                              %   Self
                              % Target point [3x1]
                              % Time total duration in ms
                              % number of linspace points
                              % 3 = cubic, 5 = linear, Hard Coded to 5
            obj.isRobotDone = 0;
            scaledVals = obj.trajScaler(goal);                   
            time = scaledVals(1);
            numPoints = scaledVals(2);
            a = obj.kine.FKtoTip(obj.robot.getPositions())';
            obj.pathPlanner.queueOfPaths.enqueue([a goal 3 2 5])
            obj.pathPlanner = obj.pathPlanner.startNextPath();
%             obj.pathPlanner = obj.pathPlanner.startPath(obj.robot.getPositions(),goal,time,numPoints,5);
        end
        
        function scaledVals = trajScaler(obj,finalPos)
            currXYZ = obj.robot.getPositions();
            targetXYZ = finalPos;
            distance = sqrt(sum((targetXYZ - currXYZ) .^ 2));
            scaledVals = [round((((distance/250) * 3) + 3)) (((distance/250) * 1) + 1)];
           
        end
    end
    
end



