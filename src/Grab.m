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
        
        
        function startGrab(~)
            %moveDown is the xyz coordinate where the arm should move down
            robot = Robot(myHIDSimplePacketComs);
            state = subStates.INIT;
            open = 0;
            close = 90;
            gripOpen = 0;
            switch(state)
                case subStates.INIT
                    robot.currentSetpoint = [obj.downPos(1) obj.downPos(2) obj.downPos(3)];
                    state = subStates.GRIPPER_WAIT;
                    gripOpen = 1;
                case subStates.ARM_WAIT
                    while robot.isAtTarget() == 0
                        robot.setSetpointsSlow(kinematics.fk3001([obj.downPos(1) obj.downPos(2) obj.downPos(3)]));
                        pause(0.3);
                    end
                    gripOpen = 0;
                    state = subStates.GRIPPER_WAIT;
                    
                case subStates.GRIPPER_WAIT
                    if gripOpen == 1
                        %need to wrtie atGRipperTarget(setPoint)
                        while robot.atGripperTarget(0) == 0
                            robot.setGripper(open);
                        end
                        state = subStates.ARM_WAIT;
                        
                    else
                        while robot.atGripperTarget(90) == 0
                            robot.setGripper(close);
                        end
                        state = subStates.DONE;
                    end
                case subStates.DONE
                    
            end
        end
        
    end
end
