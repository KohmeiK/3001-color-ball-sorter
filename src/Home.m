classdef Home
    %HOME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Home()
            %HOME Construct an instance of this class
            
        end
        
        function startHome(~)
            state = subStates.INIT;
            robot = Robot(myHIDSimplePacketComs);
            switch(state)
                case subStates.INIT
                    robot.currentSetpoint = [0 0 0];
                    state = subStates.ARM_WAIT;
                case subStates.ARM_WAIT
                    while Robot.isAtTarget() == 0
                        Robot.setSetpointsSlow(kinematics.fk3001([0 0 0]));
                        pause(0.3);
                    end
                    state = subStates.DONE;
                case subStates.DONE
                    %Clear activeColor
            end
            
        end
        
    end
    
end



