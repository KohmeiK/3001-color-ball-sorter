classdef Grab
    %G Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        finalPos;
        orbList;
        open = 180;
        close = 0;
        SERVO_WAIT = 0.5;
        state;
        timer;
    end
    
    methods
        function obj = Grab()
            obj.timer = EventTimer();
        end
        
        
        function [obj, robot, cv] = update(obj, robot, cv)
            
            switch(obj.state)
                case subState.INIT
                    obj.finalPos = cv.orbList.getActiveOrb().currentPos;
                    obj.finalPos(3) = obj.finalPos(3) + 17;
                    %                     robot.robot.setGripper(obj.open); %Set Gripper To Open
                    obj.timer.setTimer(obj.SERVO_WAIT); %Start event timer
                    obj.state = subState.GRIPPER_WAIT_OPEN; %Go to GRIPPER WAIT to wait for timer to finish
                    
                case subState.GRIPPER_WAIT_OPEN
                    if obj.timer.isTimerDone == 1
                        robot = robot.pathPlanTo(obj.finalPos); %Path Plan to Down Pos
                        obj.state = subState.ARM_WAIT;
                    end
                    
                    
                case subState.ARM_WAIT
                    if robot.isRobotDone() == 1
                        robot.robot.setGripper(obj.close); %Set Gripper To Open
                        obj.timer.setTimer(obj.SERVO_WAIT); %Start event timer
                        obj.state = subState.GRIPPER_WAIT_CLOSE;
                    end
                case subState.GRIPPER_WAIT_CLOSE
                    if obj.timer.isTimerDone == 1
                        obj.state = subState.DONE;
                    end
                case subState.DONE
                    
                otherwise
                    disp("ERROR in Grab State, Incorrect State Given");
                    
            end
        end
        
    end
end
