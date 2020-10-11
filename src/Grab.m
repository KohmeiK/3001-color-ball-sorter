classdef Grab
    %G Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        downPos;
    end
    
    methods
        function obj = Grab(moveDown)
            obj.downPos = moveDown;
        end
        
        
        function update(~)
            %moveDown is the xyz coordinate where the arm should move down
            robot = Robot(myHIDSimplePacketComs);
            state = subStates.INIT;
            nextState;
            open = 0;
            close = 90;    
            SERVO_WAIT = 250;
            
            switch(state)
                case subStates.INIT
                    robot.currentSetpoint = [obj.downPos(1) obj.downPos(2) obj.downPos(3)];
                    nextState = subStates.ARM_WAIT; %Set the next state after waiting for the gripper
                    robot.setGripper(open); %Set Gripper To Open
                    tic %Start Timer
                    state = subStates.GRIPPER_WAIT; %Go to GRIPPER WAIT to wait for timer to finish
                    
                case subStates.ARM_WAIT
                    if robot.isAtTarget() == 0
                        robot.setSetpointsSlow(kinematics.fk3001([obj.downPos(1) obj.downPos(2) obj.downPos(3)]));
                        pause(0.3);
                    else
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
