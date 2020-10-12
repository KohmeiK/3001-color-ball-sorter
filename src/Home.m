classdef Home
    %HOME Summary of this class goes here
    %   Detailed explanation goes here
    
   properties
        robot;
        state; 
        HomePos = [100 0 195]; 
    end
    
    methods
        function obj = Home(robot)
            obj.robot = robot;
        end
        
        function update(obj)
            
            switch(obj.state)
                case subStates.INIT
                    obj.robot.pathPlanTo(obj.HomePos);
                    obj.state = subState.ARM_WAIT;
                    
                case subStates.ARM_WAIT
                    if obj.robot.isAtTarget() == 1
                        obj.state = subState.DONE;
                    end
                            
                case subStates.DONE
                    %Clear activeColor
                    
                otherwise
                    disp("ERROR in Home State, Incorrect State Given");
            end
        end
    end
end

