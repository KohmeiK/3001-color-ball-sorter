classdef Traj_Planner
    %TRAJ_PLANNER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        coeffs = zeros(4,3)
    end
    
    methods
        function obj = Traj_Planner()
            %TRAJ_PLANNER Construct an instance of this class
            %   Detailed explanation goes here
        end
        
        function obj = cubic_traj(obj,time,pos,vel,index)
            M = [1 time(1) time(1)^2 time(1)^3;
                0    1     2*time(1) 3*time(1)^2;
                1 time(2) time(2)^2 time(2)^3;
                0    1     2*time(2) 3*time(2)^2;];
            Answer = [pos(1) vel(1) pos(2) vel(2)]';
            temp = linsolve(M,Answer);
            obj.coeffs(:,index) = temp;
            
        end
        
        function res = solveEQ(obj,t, index)
            res = obj.coeffs(1,index) + obj.coeffs(2,index)*t + obj.coeffs(3,index)*(t^2) + obj.coeffs(4,index)*(t^3);
        end
    end
end

