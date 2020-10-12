classdef Approach

     properties
        robot;
        state;
        dest;
        orbList;
        Z_Offset = 50; %In mm
     end

    methods
        function obj = Approach(robot, orblist)
            obj.robot = robot;
            obj.orbList = orblist;
            obj.state = subState.INIT;
        end

        function obj = update(obj)

            switch(obj.state)
                case subState.INIT
                    if OrbList.length > 0
                        obj.dest = obj.orbList.getActiveOrb().finalPos;
                        obj.dest(3) = obj.dest(3) + obj.Z_Offset;
                        obj.robot.pathPlanTo();
                        obj.state = subState.ARM_WAIT;
                    end

                case subState.ARM_WAIT
                    if OrbList.activeOrb.hasMoved == 1 || OrbList.length == 0
                        obj.state = subStates.INIT;
                    else
                        if obj.robot.isAtTarget() == 1
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
