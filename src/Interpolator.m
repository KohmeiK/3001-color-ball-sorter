classdef Interpolator
    %INTERPOLATOR Summary of this class goes here
    %   Detailed explanation goes here

    properties
        coeffs;
        type;
        T = 0;
    end

    methods
        function obj = Interpolator(InterpolationType,Time)
            %INTERPOLATOR Construct an instance of this class
            %   Detailed explanation goes here
            obj.type = InterpolationType;
            obj.T = Time;

            %Set Known Parameters
            t0 = 0;
            tf = obj.T;
            v0 = 0;
            vf = 0;
            q0 = 0;
            qf = 1;
            alpha0 = 0;
            alphaf = 0;

            %Calculate Coefficients for Cubic Trajectory and store in obj.coeffs
            if InterpolationType == "Cubic"
                MCubic = [1 t0  t0^2    t0^3;
                          0 1   2*t0    3*t0^2;
                          1 tf  tf^2    tf^3;
                          0 1   2*tf    3*tf^2];

                AnsCubic = [q0;
                            v0;
                            qf;
                            vf];

                tempCubic = linsolve(MCubic,AnsCubic);
                obj.coeffs = tempCubic;

            %Calculate Coefficients for Quintic Trajectory and store in obj.coeffs
            elseif InterpolationType == "Quintic"
                MQuintic = [1   t0  t0^2    t0^3    t0^4        t0^5;
                            0   1   2*t0    3*t0^2  4*t0^3      5*t0^4;
                            0   0   2       6*t0    12*t0^2     20*t0^3;
                            1   tf  tf^2    tf^3    tf^4        tf^5;
                            0   1   2*tf    3*tf^2  4*tf^3      5*tf^4;
                            0   0   2       6*tf    12*tf^2     20*tf^3];


                AnsQuintic = [q0;
                              v0;
                              alpha0;
                              qf;
                              vf;
                              alphaf];

                tempQuintic = linsolve(MQuintic,AnsQuintic);
                obj.coeffs = tempQuintic;
            end

        end

        function pos = get(obj, deltaT)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            A = obj.coeffs;

            if obj.type == "Linear"
               pos = (deltaT/obj.T);

            elseif obj.type == "Cubic"

                pos = A(1) + A(2)*deltaT + A(3)*deltaT^2 + A(4)*deltaT^3;

            elseif obj.type == "Quintic"

                pos = A(1) + A(2)*deltaT + A(3)*deltaT^2 + A(4)*deltaT^3 + ...
                    A(5)*deltaT^4 + A(6)*deltaT^5;
            end
        end

    end
end
