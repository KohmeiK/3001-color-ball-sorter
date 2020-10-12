classdef Travel
    %TRAVEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dest;
        state;
        nextState;
        orbList;
        HomePos = [0 0 0]; 
        
    end
    
    methods
        function obj = Travel(orblist)
            obj.orbList = orblist;
        end
        
        function [obj,robot] = update(obj, robot)
            
            switch(obj.state)
                case subStates.INIT
                    robot.pathPlanTo(obj.HomePos); 
                    obj.state = ARM_WAIT_HOME; 
                    
                case ARM_WAIT_HOME
                    if robot.isAtTarget() == 1
                        obj.dest = obj.orbList.getActiveOrb().finalPos;
                        robot.pathPlanTo(obj.dest);
                        obj.state = subState.ARM_WAIT;
                    end
                %TODO: Add A State to wait 0.5s and then path plan after getting to home    
                case subStates.ARM_WAIT
                    if robot.isAtTarget() == 1
                        obj.state = subState.DONE;
                    end
                            
                case subStates.DONE
                    
                otherwise
                    disp("ERROR in Travel State, Incorrect State Given");
            end
        end
    end
end

