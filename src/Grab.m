classdef Grab
    %G Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        finalPos;
        robot;
        open = 0;
        close = 90;
        SERVO_WAIT = 250;
        state;
        timer;
    end
    
    methods
        function obj = Grab(robot)
            obj.finalPos = OrbList.getActiveOrb().finalPos;
            obj.robot = robot;
            obj.timer = EventTimer();
        end
        
        
        function update(obj)
            
            switch(obj.state)
                case subStates.INIT
                    obj.robot.setGripper(obj.open); %Set Gripper To Open
                    obj.timer.setTimer(obj.SERVO_WAIT); %Start event timer
                    obj.state = subStates.GRIPPER_WAIT_OPEN; %Go to GRIPPER WAIT to wait for timer to finish
                    
                case subStates.ARM_WAIT
                    if obj.robot.isRobotDone() == 1
                        obj.timer.setTimer(obj.SERVO_WAIT); %Start event timer
                        obj.state = subStates.GRIPPER_WAIT_CLOSE;
                    end
                    
                case subStates.GRIPPER_WAIT_OPEN
                    if obj.timer.isTimerDone == 1
                        obj.robot.pathPlanTo(obj.finalPos); %Path Plan to Down Pos
                        obj.state = subStates.ARM_WAIT;
                    end
                    
                case subStates.GRIPPER_WAIT_CLOSE
                    if obj.timer.isTimerDone == 1
                        obj.state = subStates.DONE;
                    end    
                case subStates.DONE
                    
                otherwise
                    disp("ERROR in Grab State, Incorrect State Given");
                    
            end
        end
        
    end
end
