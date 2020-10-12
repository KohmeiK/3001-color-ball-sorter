classdef Travel
    %TRAVEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dest;
        robot;
        state;
        nextState;
        HomePos = [0 0 0]; 
        
    end
    
    methods
        function obj = Travel(robot)
            obj.dest = OrbList.activeOrb.finalPos;
            obj.robot = robot;
        end
        
        function update(obj)
            
            switch(obj.state)
                case subStates.INIT
                    obj.robot.pathPlanTo(obj.HomePos); 
                    obj.state = ARM_WAIT_HOME; 
                    
                case ARM_WAIT_HOME
                    if obj.robot.isAtTarget() == 1
                        obj.robot.pathPlanTo(obj.dest);
                        obj.state = subState.ARM_WAIT;
                    end
                %TODO: Add A State to wait 0.5s and then path plan after getting to home    
                case subStates.ARM_WAIT
                    if obj.robot.isAtTarget() == 1
                        obj.state = subState.DONE;
                    end
                            
                case subStates.DONE
                    
                otherwise
                    disp("ERROR in Travel State, Incorrect State Given");
            end
        end
    end
end

