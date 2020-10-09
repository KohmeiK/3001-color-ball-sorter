classdef Home
    %HOME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Home()
            %HOME Construct an instance of this class
            
        end
        
        function update(~)
            state = HomeState.INIT;
            switch(state)
                case HomeState.INIT
                    Robot.currentSetpoint = [0 0 0];
                    state = HomeState.ARM_WAIT;
                case homeState.WAIT_ARM
                    while(Robot.isAtTarget == 1)
                        robot.setSetpointsSlow(kinematics.fk3001([0 0 0]));
                        pause(1);
                    end
                case homeState.DONE
                    %Clear activeColor
            end
            
        end
        
        
    end
    
end



