classdef Logger
    %PLOTTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        file
        firstLogTime
    end
    
    methods
        function obj = Logger(filename)
            fid = fopen(filename,'wt');
            if fid == -1
                error('Cannot open log file.');
            end
            obj.file = fid;
            obj.firstLogTime = datetime;
        end
        
        function obj = logPositions(obj,positions)
            fprintf(obj.file, '%s,%s,%s,%s\n', milliseconds(datetime - obj.firstLogTime), positions(1),positions(2),positions(3));
        end
        function obj = close(obj)
            fclose(obj.file);
            obj.file = -1;
        end
    end
end

