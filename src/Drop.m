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
        timer;
    end
    
    methods
        function obj = Drop(robot)
            obj.robot = robot;
            obj.timer = EventTimer();
        end
        
        
        function obj = update(obj)
            
            switch(obj.state)
                case subState.INIT
                    obj.robot.setGripper(obj.open); %Set Gripper To Open
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
