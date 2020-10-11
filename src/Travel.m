classdef Travel
    %TRAVELSTATE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dest;
        robot;
        nextState;
        HomePos = [0 0 0];
        
    end
    
    methods
        function obj = Travel(destination, robot)
            obj.dest = destination;
            obj.robot = robot;
        end
        
        function update(~)
                       
            switch(state)
                case subStates.INIT
                    obj.robot.pathPlanTo(HomePos);
                    state = subStates.ARM_WAIT;
                    
                case subStates.ARM_WAIT
                    if robot.isAtTarget() == 1
                       state = subStates.DONE;
            end
                    
            
                case subStates.DONE
                    %Clear activeColor
            end
        end
    end
end

