classdef Traj_Planner
    %TRAJ_PLANNER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        coeffs = zeros(6,3)
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
        
        function obj = quntic_traj(obj,time,pos,vel,acel,index)
            M = [1 time(1) time(1)^2 time(1)^3 time(1)^4;
                0    1     2*time(1) 3*time(1)^2 4*time(1)^3;
                0    0     2 6*time(1) 12*time(1)^2;
                1 time(2) time(2)^2 time(2)^3 time(2)^4;
                0    1     2*time(2) 3*time(2)^2 4*time(2)^3;
                0    0     2 6*time(2) 12*time(2)^2;];
            
            Answer = [pos(1) vel(1) acel(1) pos(2) vel(2) acel(1)]';
            temp = linsolve(M,Answer);
            obj.coeffs(:,index) = temp;
            
        end
        
        function res = solveEQ(obj,t, index)
            res = obj.coeffs(1,index) + obj.coeffs(2,index)*t +...
                obj.coeffs(3,index)*(t^2) + obj.coeffs(4,index)*(t^3) +...
                obj.coeffs(4,index)*(t^4) + obj.coeffs(5,index)*(t^5);
        end
        
        
        %this function takes a starting and ending point, initial and fina time 
        %--> plugs them into the cubic_traj function
        function obj = pointTo3(obj, p1, p2, t0, t1)
            obj = obj.cubic_traj([t0 t1],[p1(1) p2(1)],[0 0],1);
            obj = obj.cubic_traj([t0 t1],[p1(2) p2(2)],[0 0],2);
            obj = obj.cubic_traj([t0 t1],[p1(3) p2(3)],[0 0],3);        
        end
        
        function obj = pointTo5(obj, p1, p2, t0, t1)
            obj = obj.cubic_traj([t0 t1],[p1(1) p2(1)],[0 0],[0 0],1);
            obj = obj.cubic_traj([t0 t1],[p1(2) p2(2)],[0 0],[0 0],2);
            obj = obj.cubic_traj([t0 t1],[p1(3) p2(3)],[0 0],[0 0],3);        
        end
        
        
        function robot = trajExecute(obj, sTime)
                t = milliseconds(datetime - sTime);
                t1 = obj.solveEQ(t,1);
                t2 = obj.solveEQ(t,2);
                t3 = obj.solveEQ(t,3);
                disp(t)
                disp(t1)
                disp(t2)
                disp(t3)
                robot = [t1 t2 t3];
                %disp(i);
        end
        
    end
end

