classdef EventTimer
    %TIMER Event timer for state machine waits
    
    properties
        duration = 0; %The target time for the stopwatch
        startTime; %When the start was pressed on the stopwatch
    end
    
    methods
        function obj = EventTimer()
            obj.startTime = tic;
        end
        
        function obj = setTimer(obj,duration)
            obj.duration = duration;
            obj.startTime = tic;
        end
        
        function obj = isTimerDone(obj)
            if toc(obj.startTime) >= obj.duration
                obj = 1;
            else
                obj = 0;
            end
        end
    end
end

