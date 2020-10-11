classdef Grab
    %G Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        downPos;
        robot;
    end
    
    methods
        function obj = Grab(moveDown, robot)
            obj.downPos = moveDown;
            obj.robot = robot;
        end
        
        
        function update(~)
            %moveDown is the xyz coordinate where the arm should move down
            state = subStates.INIT;
            nextState;
            open = 0;
            close = 90;    
            SERVO_WAIT = 250;
            
            switch(state)
                case subStates.INIT
                    nextState = subStates.ARM_WAIT; %Set the next state after waiting for the gripper
                    obj.robot.pathPlanTo(obj.downPos); %Path Plan to Down Pos
                    obj.robot.setGripper(open); %Set Gripper To Open
                    tic %Start Timer
                    state = subStates.GRIPPER_WAIT; %Go to GRIPPER WAIT to wait for timer to finish
                    
                case subStates.ARM_WAIT
                    if obj.robot.isRobotDone() == 1
                        nextState = subStates.Done;
                        tic
                        state = subStates.GRIPPER_WAIT;
                    end
                    
                case subStates.GRIPPER_WAIT
                    if(toc > SERVO_WAIT)
                        state = nextState;
                    end
                    
                case subStates.DONE
                    
            end
        end
        
    end
end
