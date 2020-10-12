classdef Drop
    % Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        robot;
        nextState;
        open = 0;
        close = 90;
        SERVO_WAIT = 250;
        state;
    end
    
    methods
        function obj = Grab(robot)
            obj.robot = robot;
        end
        
        
        function update(obj)
            
            %FIX TIC TOC
            switch(obj.state)
                case subStates.INIT
                    obj.robot.setGripper(obj.open); %Set Gripper To Open
                    tic %Start Timer
                    obj.state = subStates.GRIPPER_WAIT; %Go to GRIPPER WAIT to wait for timer to finish
                    
                case subStates.GRIPPER_WAIT
                    if(toc > obj.SERVO_WAIT)
                        obj.state = subStates.Done;
                    end
                    
                case subStates.DONE
                    
                otherwise
                    disp("ERROR in Drop State, Incorrect State Given");
                    
            end
        end
        
    end
end
