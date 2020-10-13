classdef Approach

     properties
        state;
        dest;
        Z_Offset = 100; %In mm
     end

    methods
        function obj = Approach()
            obj.state = subState.INIT;
        end

        function [obj,robot, cv] = update(obj, robot, cv)

            switch(obj.state)
                case subState.INIT
                    cv = cv.forceRefreshEveryColor();
                    disp(cv.orbList.getlistLength());
                    if cv.orbList.getlistLength() > 0
                        obj.dest = cv.orbList.getActiveOrb().currentPos;
                        obj.dest(3) = obj.dest(3) + obj.Z_Offset;
                        disp("Send to place above ball");
                        robot = robot.pathPlanTo(obj.dest);
                        obj.state = subState.ARM_WAIT;
                    end

                case subState.ARM_WAIT
                    if cv.orbList.getActiveOrb.moved == 1 || cv.orbList.getlistLength == 0
%                         obj.state = subStates.INIT;
                    else
                        if robot.isRobotDone == 1
                            obj.state = subState.DONE;
                        end
                    end

                case subState.DONE

                otherwise
                    disp("ERROR in Home State, Incorrect State Given");
            end
        end
    end
end
