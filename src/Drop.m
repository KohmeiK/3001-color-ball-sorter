classdef Drop
    % Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        open = 0;
        close = 90;
        SERVO_WAIT = 250;
        state;
        timer;
    end
    
    methods
        function obj = Drop()
            obj.timer = EventTimer();
        end
        
        
        function [obj,robot] = update(obj,robot)
            
            switch(obj.state)
                case subState.INIT
                    robot.setGripper(obj.open); %Set Gripper To Open
                    obj.timer.setTimer(obj.SERVO_WAIT);%Set Timer
                    obj.state = subState.GRIPPER_WAIT; %Go to GRIPPER WAIT to wait for timer to finish
                    
                case subState.GRIPPER_WAIT
                    if obj.timer.isTimerDone == 1
                        obj.state = subState.Done;
                    end
                    
                case subState.DONE
                    
                otherwise
                    disp("ERROR in Drop State, Incorrect State Given");
                    
            end
        end
        
    end
end
