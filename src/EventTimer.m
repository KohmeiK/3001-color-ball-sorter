classdef EventTimer
    %TIMER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        duration = 0;
        startTime;
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

