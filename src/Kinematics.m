classdef Kinematics
    %KINEMATICS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Kinematics()
            %KINEMATICS Construct an instance of this class
            %   Detailed explanation goes here
        end
       
        function Tmatrix = DHtoMatrix(~,Theta,D,A,Alpha)
            Tmatrix = zeros(4,'double');

            %Row 1
            Tmatrix(1,1) = cos(Theta);
            Tmatrix(1,2) = -sin(Theta)*cos(Alpha);
            Tmatrix(1,3) = sin(Theta)*sin(Alpha);
            Tmatrix(1,4) = A*cos(Theta);

            %Row 2
            Tmatrix(2,1) = sin(Theta);
            Tmatrix(2,2) = cos(Theta)*cos(Alpha);
            Tmatrix(2,3) = -cos(Theta)*sin(Alpha);
            Tmatrix(2,4) = A*sin(Theta);

            %Row 3
            Tmatrix(3,2) = sin(Alpha);
            Tmatrix(3,3) = cos(Alpha);
            Tmatrix(3,4) = D;

            Tmatrix(4,4) = 1;
        end
    end
end

