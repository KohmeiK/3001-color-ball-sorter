classdef Logger
    %LOGGER is respoible for logging all the joint positions and time
    %data that is collected during arm motions
    
    properties
        file %file ID for the log file
        firstLogTime %datetime for the first log
        %this allows us to get duration not date and time
    end
    
    methods
        function obj = Logger(filename)
            fid = fopen(filename,'wt');
            if fid == -1
                error('Cannot open log file.');
            end
            %init properties with file and datetime
            obj.file = fid;
            obj.firstLogTime = datetime;
        end
        
        %log data to file with duration in ms, t1, t2, t3
        function obj = logPositions(obj,positions)
            fprintf(obj.file, '%s,%s,%s,%s\n', milliseconds(datetime - obj.firstLogTime), positions(1),positions(2),positions(3));
        end
        function obj = close(obj)
            %close the logfile
            fclose(obj.file);
            obj.file = -1;
        end
        
        function obj = pauseAndLog(obj,secconds,robot)
            tic
            while toc < secconds
                obj.logPositions(robot.getPositions());
            end
        end
    end
end

