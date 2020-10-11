classdef Home
    %HOME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        state
    end
    
    methods
        function obj = Home()
            %HOME Construct an instance of this class
            obj.state = subStates.INIT;
        end
        
        function obj = update(obj)
            switch(obj.state)
                case subStates.INIT
                   
                    state = subStates.ARM_WAIT;
                case subStates.ARM_WAIT
                    while Robot.isAtTarget() == 0
                        
                    end
                    state = subStates.DONE;
                case subStates.DONE
                    %Clear activeColor
            end
            
        end
        
    end
    
end



