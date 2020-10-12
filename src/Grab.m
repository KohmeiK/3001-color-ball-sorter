classdef Grab
    %G Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        downPos;
        robot;
        nextState;
        open = 0;
        close = 90;
        SERVO_WAIT = 250;
        state;
        timer;
    end
    
    methods
        function obj = Grab(moveDown, robot)
            obj.downPos = moveDown; 
            obj.robot = robot;
            timer = EventTimer();
        end
        
        
        function update(obj)
            %moveDown is the xyz coordinate where the arm should move down
            switch(obj.state)
                case subStates.INIT
                    obj.nextState = subStates.ARM_WAIT; %Set the next state after waiting for the gripper
                    obj.robot.pathPlanTo(obj.downPos); %Path Plan to Down Pos
                    obj.robot.setGripper(obj.open); %Set Gripper To Open
                    timer.setTimer(SERVO_WAIT);
                    obj.state = subStates.GRIPPER_WAIT; %Go to GRIPPER WAIT to wait for timer to finish
                    
                case subStates.ARM_WAIT
                    if obj.robot.isRobotDone() == 1
                        obj.nextState = subStates.Done;
                        tic
                        obj.state = subStates.GRIPPER_WAIT;
                    end
                    
                case subStates.GRIPPER_WAIT_OPEN
                    if timer.isTimerDone == 1
                        obj.state = obj.nextState;
                        obj.nextState = subStates.DONE;
                    end
                    
                case subStates.GRIPPER_WAIT_CLOSE
                    if timer.isTimerDone == 1
                        obj.state = obj.nextState;
                        obj.nextState = subStates.DONE;
                    end    
                case subStates.DONE
                    
                otherwise
                    disp("ERROR in Grab State, Incorrect State Given");
                    
            end
        end
        
    end
end
