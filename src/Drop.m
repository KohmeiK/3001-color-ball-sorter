classdef Drop
    %DROP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end

    methods
        function obj = Drop()
        end
        function startHome(~)
            robot = Robot(myHIDSimplePacketComs);
            state = subStates.INIT;
            open = 0;
            close = 90;
            gripOpen = 0;
            switch(state)
                case subStates.INIT
                    state = subStates.GRIPPER_WAIT;
                    gripOpen = 1;
                case subStates.GRIPPER_WAIT
                    if gripOpen == 1
                        %need to wrtie atGRipperTarget(setPoint)
                        while robot.atGripperTarget(open) == 0
                            robot.setGripper(open);
                            pause(0.5);
                        end
                        gripOpen = 0;
                        state = subStates.GRIPPER_WAIT;
                    else
                        while robot.atGripperTarget(close) == 0
                            robot.setGripper(close);
                            pause(0.5);
                        end
                        state = subStates.DONE;
                    end
                case subStates.DONE
                    %Clear activeColor
            end
        end
    end
end

