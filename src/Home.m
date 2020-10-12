classdef Home
    %HOME Summary of this class goes here
    %   Detailed explanation goes here
    
   properties
        robot;
        state; 
        orbList;
        HomePos = [100 0 195]; 
    end
    
    methods
        function obj = Home(robot,orblist)
            obj.robot = robot;
            obj.orbList = orblist;
        end
        
        function obj = update(obj)
            disp("HOME UPDATING")
            switch(obj.state)
                case subState.INIT
                    obj.robot.pathPlanTo(obj.HomePos);
                    obj.state = subState.ARM_WAIT;
                    
                case subState.ARM_WAIT
                    if obj.robot.isAtTarget() == 1
                        obj.state = subState.DONE;
                    end
                            
                case subState.DONE
                    obj.orbList.activeColor = Color.ALL;
                    y
                otherwise
                    disp("ERROR in Home State, Incorrect State Given");
            end
        end
    end
end

