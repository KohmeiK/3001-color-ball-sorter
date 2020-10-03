classdef Path_Planner
    %Path planner handles most of the trajectory planning and robot motion
    properties
        queueOfPaths %queue of which points to travel to
        isPathDone %is current path finished? If so move to next state
        pathPoints %The task space interpolated points
        I %Interpolator class
        numberOfPoints%number of points to interploate by
        totalDuration %Total path duration for current path
        segmentStartTime %Tic for when this segment stated
        onSegment %the segment number we are on
        segmentDuration %total time / number of segments
    end
    
    methods
        function obj = Path_Planner()
            obj.queueOfPaths = queue;
        end
        
        function lin = linear_traj(~, startP, endP, viaP)
            t = linspace(0,1,viaP)';
            lin = (1-t)*startP + t*endP;
        end
        
        %start the next path that that takes you from current to next point
        function obj = startNextPath(obj)
            if obj.queueOfPaths.Depth <= 0
                error("No more paths left. Please enqueue more");
            end
            pathData = obj.queueOfPaths.dequeue();
            type = pathData(9);
            typeString = ":Linear";
            if type == 3
                typeString = "Cubic";
            elseif type == 5
                typeString = "Quintic";
            end
            obj = obj.startPath(pathData(1:3),pathData(4:6),pathData(7),pathData(8),typeString);
        end
        
        %Helper for startNextPath that updates the class proprties
        function obj = startPath(obj,P1,P2,totalDuration,numberOfPoints,trajectoryType)
            obj.pathPoints = obj.linear_traj(P1,P2,numberOfPoints);
            obj.I = Interpolator(trajectoryType,totalDuration/ (numberOfPoints-1));
            obj.numberOfPoints = numberOfPoints;
            obj.totalDuration = totalDuration;
            obj.onSegment = 1;
            obj.segmentStartTime = tic;
            obj.segmentDuration = obj.totalDuration / (obj.numberOfPoints - 1);
        end
        
        %Move on to next segment NOT path
        function obj = startNextSegment(obj)
            obj.segmentStartTime = tic;
            obj.onSegment = obj.onSegment + 1;
%             disp("Moving to next segment: ");
%             disp(obj.onSegment);
        end
        
        %Call this as much as possible, send the newest location to the arm
        function [obj, isPathDone, setPoint] = update(obj)
%             disp("Running Update");
            if obj.onSegment >= obj.numberOfPoints
                isPathDone = 1;
                setPoint = [100 0 195];
            else
                isPathDone = 0;
%                 disp("Segment Duration:") 
%                 disp(obj.segmentDuration)
%                 disp("Start time") 
%                 disp(toc(obj.segmentStartTime))
                timeSinceStart = toc(obj.segmentStartTime);
                
                if timeSinceStart > obj.segmentDuration
                    timeSinceStart = obj.segmentDuration;
                end
                
                scalar = obj.I.get(timeSinceStart);
%                 disp("Scalar: ");
%                 disp(scalar);
                setPoint = ((obj.pathPoints(obj.onSegment+1,:)-...
                    obj.pathPoints(obj.onSegment,:)).* scalar + obj.pathPoints(obj.onSegment,:));
                
                if(toc(obj.segmentStartTime) > obj.segmentDuration)
                    obj = obj.startNextSegment();
                end
%                 disp("Current Segment segment: ");
%                 disp(obj.onSegment);
            end
        end
    end
end

