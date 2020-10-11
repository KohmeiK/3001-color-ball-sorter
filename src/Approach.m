classdef Approach
    
    properties
    end
    
    methods
        
        function obj = Approach()
            
        end
        
        function update(~)
            state = ApproachState.INIT;
            
            switch(state)
                case ApproachState.INIT
                    
                case ApproachState.ARM_WAIT
                    while(Robot.isAtTarget == 0)
                        robot.setSetpointsSlow(kinematics.fk3001([0 0 0]));
                        pause(1);
                    end
                case ApproachState.DONE
                    
            end
            
        end
    end
end