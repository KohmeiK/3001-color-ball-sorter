classdef Home
    %HOME Summary of this class goes here
    %   Detailed explanation goes here
    
   properties
        state; 
        orbList;
        HomePos = [100 0 195]; 
    end
    
    methods
        function obj = Home(orblist)
            obj.orbList = orblist;
        end
        
        function [obj, robot] = update(obj,robot)
            switch(obj.state)
                case subState.INIT
                    robot = robot.pathPlanTo(obj.HomePos);
                    obj.state = subState.ARM_WAIT;
                    disp("home-> Arm_WAIT");
                case subState.ARM_WAIT
                    if robot.isRobotDone == 1
                        obj.state = subState.DONE;
                        disp("home-> DONE");
                    end
                            
                case subState.DONE
                    obj.orbList.activeColor = Color.ALL;
                otherwise
                    disp("ERROR in Home State, Incorrect State Given");
            end
        end
    end
end

