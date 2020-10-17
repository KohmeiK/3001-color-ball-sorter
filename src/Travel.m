classdef Travel
    %TRAVEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dest;
        state;
        nextState;
        HomePos = [100 0 195]; 
        
    end
    
    methods
        function obj = Travel()
        end
        
        function [obj,robot, cv] = update(obj, robot, cv)
            
            switch(obj.state)
                case subState.INIT
                    robot = robot.pathPlanTo(obj.HomePos); 
                    obj.state = subState.ARM_WAIT_HOME; 
                    
                case subState.ARM_WAIT_HOME
                    if robot.isRobotDone() == 1
                        obj.dest = cv.orbList.getActiveOrb().finalPos;
                        robot = robot.pathPlanTo(obj.dest);
                        obj.state = subState.ARM_WAIT;
                    end
                %TODO: Add A State to wait 0.5s and then path plan after getting to home    
                case subState.ARM_WAIT
                    if robot.isRobotDone() == 1
                        obj.state = subState.DONE;
                    end
                            
                case subState.DONE
                    
                otherwise
                    disp("ERROR in Travel State, Incorrect State Given");
            end
        end
    end
end

