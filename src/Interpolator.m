classdef Interpolator
    %INTERPOLATOR Summary of this class goes here
    %   Detailed explanation goes here

    properties
        coeffs3 = zeros(4,3);
        coeffs5 = zeros(6,3);
        type;
        T;
    end

    methods
        function obj = Interpolator(InterpolationType,Time)
            %INTERPOLATOR Construct an instance of this class
            %   Detailed explanation goes here
            obj.type = InterpolationType;
            obj.T = Time;
        end
        
        function Scalar = get(deltaT)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
        t0 = 0;
        tf = Interpolator.T;
        v0 = 0;
        vf = 0;
        q0 = 0;
        qf = 1;
        
            if Interpolator.type == "Linear"
               Scalar = (deltaT/Interpolator.T);
           
            elseif Interpolator.type == "Cubic"
                M = [a(0) a(1)*t0 a(2)*t0^2 a(3)*t0^3
                    a(0) a(1)*tf a(2)*tf^2 a(3)*tf^3
                    a(1) 2*a(2)*t0 3*a(3)*t0^2
                    a(1) 2*a(2)*tf 3*a(3)*tf^2];
                    
                Ans = [q0 
                      qf 
                      v0 
                      vf];
                
                temp = linsolve(M,Ans);
                Interpolator.coeffs3(:,index) = temp;
                Scalar = Inerpolator.coeffs3;
                
            elseif Interpolator.type == "Quintic"
                Scalar = 0;
            end
        end
    end
end
