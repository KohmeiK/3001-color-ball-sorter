classdef Travel
    %TRAVELSTATE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dest;
    end
    
    methods
        function obj = Travel(destination)
            obj.dest = destination;
        end
        
        function startTravel(~)
            robot = Robot(myHIDSimplePacketComs);
            state = subStates.INIT;
            toTarget = 0;
            switch(state)
                case subStates.INIT
                    robot.currentSetpoint = [0 0 0];
                    state = subStates.ARM_WAIT;
                    toTarget = 1;
                case subStates.ARM_WAIT
                    if  toTarget == 0
                        while(robot.isAtTarget() == 0)
                            %back to home position
                            robot.setSetpointsSlow(kinematics.fk3001([0 0 0]));
                            pause(0.3);
                        end
                        robot.currentSetpoint = [obj.dest(1) obj.dest(2) obj.dest(3)];
                        state = ARM_WAIT;
                    else
                        while robot.isAtTarget() == 0
                            robot.setSetpointsSlow(kinematics.fk3001([obj.dest(1) obj.dest(2) obj.dest(3)]));
                            pause(0.3);
                        end
                        state = subStates.DONE;
                    end
                case subStates.DONE
                    %Clear activeColor
            end
        end
    end
end

