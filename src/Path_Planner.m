classdef Path_Planner
    %PATH_PLANNER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Path_Planner()
        end
        
        function lin = linear_traj(obj, startP, endP, viaP)
            t = linspace(0,1,viaP)';
            lin = (1-t)*startP + t*endP;
        end
    end
end

