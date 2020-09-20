classdef Traj_Planner
    %TRAJ_PLANNER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function obj = Traj_Planner()
            %TRAJ_PLANNER Construct an instance of this class
            %   Detailed explanation goes here
        end
        
        function coeffs = cubic_traj(obj,time,pos,vel)
            M = [1 time(1) time(1)^2 time(1)^3;
                0    1     2*time(1) 3*time(1)^2;
                1 time(2) time(2)^2 time(2)^3;
                0    1     2*time(2) 3*time(2)^2;];
            Answer = [pos(1) vel(1) pos(2) vel(2)]';
            coeffs = linsolve(M,Answer);
        end
    end
end

