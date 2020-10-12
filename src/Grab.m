classdef Grab
    %G Summary of this class goes here
    %   Detailed explanation goes here

    properties
        finalPos;
        robot;
        orbList;
        open = 0;
        close = 90;
        SERVO_WAIT = 250;
        state;
        timer;
    end

    methods
        function obj = Grab(robot, orblist)
            obj.robot = robot;
            obj.orbList = orblist;
            obj.timer = EventTimer();
        end


        function obj = update(obj)

            switch(obj.state)
                case subState.INIT
                    obj.finalPos = obj.orbList.getActiveOrb().finalPos;
                    obj.robot.setGripper(obj.open); %Set Gripper To Open
                    obj.timer.setTimer(obj.SERVO_WAIT); %Start event timer
                    obj.state = subState.GRIPPER_WAIT_OPEN; %Go to GRIPPER WAIT to wait for timer to finish

                case subState.ARM_WAIT
                    if obj.robot.isRobotDone() == 1
                        obj.timer.setTimer(obj.SERVO_WAIT); %Start event timer
                        obj.state = subState.GRIPPER_WAIT_CLOSE;
                    end

                case subState.GRIPPER_WAIT_OPEN
                    if obj.timer.isTimerDone == 1
                        obj.robot.pathPlanTo(obj.finalPos); %Path Plan to Down Pos
                        obj.state = subState.ARM_WAIT;
                    end

                case subState.GRIPPER_WAIT_CLOSE
                    if obj.timer.isTimerDone == 1
                        obj.state = subState.DONE;
                    end
                case subState.DONE

                otherwise
                    disp("ERROR in Grab State, Incorrect State Given");

            end
        end

    end
end
