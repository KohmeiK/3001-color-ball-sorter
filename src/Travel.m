classdef Travel
    %TRAVELSTATE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dest;
        robot;
        state;
        nextState;
        HomePos = [0 0 0]; %This could be put in Robot and called from there, would be cleaner but doesn't matter
        
    end
    
    methods
        function obj = Travel(destination, robot)
            obj.dest = destination;
            obj.robot = robot;
        end
        
        function update(obj)
            
            switch(obj.state)
                case subStates.INIT
                    obj.robot.pathPlanTo(obj.HomePos);
                    obj.state = ARM_WAIT_HOME; %Should this be added to Substates? I have it essentially as a priv state rn
                    
                case ARM_WAIT_HOME
                    if obj.robot.isAtTarget() == 1
                        obj.robot.pathPlanTo(obj.dest);
                        obj.state = subState.ARM_WAIT;
                    end
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

