%%
% RBE 3001 Lab 5 example code!
% Developed by Alex Tacescu (https://alextac.com)
%%
clc;
clear;
clear java;
format short

%% Flags
DEBUG = false;
STICKMODEL = false;
DEBUG_CAM = false;

CVLoopTime = 0.05; % In s %0.2
ModelLoopTime = 0.5; % In s



%% Main Loop

%     % Set up camera
%     if cam.params == 0
%         error("No camera parameters found!");
%     end
%
%
%     %outputs a transformation Matrix
%     cam.cam_pose = cam.getCameraPose();
%     randompoint = pointsToWorld(cam.params.Intrinsics, cam.cam_pose(1:3,1:3), cam.cam_pose(1:3,4), [100 100]);
%     basePose = cam.cam_pose * cam.check2base;
%
%     disp("Cal Done");
%     pause;


%Initializing states
state = State.INIT;
nextState = State.INIT;


%Creating objects
robot = RobotStateMachine();
homeObj = Home();
approachObj = Approach();
grabObj = Grab();
travelObj = Travel();
dropObj = Drop();

cv = CV();


timer = EventTimer();
CVTimer = EventTimer();
ModelTimer = EventTimer();

textprogressbar('Loop Rate (ms): ');
tic
currentPeakTimeMs = 10;

while true
    
    elapsedTimeMs = floor(toc*1000);
    textprogressbar(elapsedTimeMs);
    
    if(elapsedTimeMs > currentPeakTimeMs)
        currentPeakTimeMs = elapsedTimeMs;
        textprogressbar('Detected New Max Loop Time');
        textprogressbar('Loop Rate (ms): ');
    end
    tic
    
    try
        robot = robot.update();
    catch exception
        robot.state = robotState.INIT;
        homeObj = Home();
        approachObj = Approach();
        grabObj = Grab();
        travelObj = Travel();
        dropObj = Drop();
        state = State.INIT;
        nextState = State.INIT;
    end

    if(CVTimer.isTimerDone == 1)
        cv = cv.update();
        CVTimer = CVTimer.setTimer(CVLoopTime);
    end
%
%     if(ModelTimer > ModelLoopTime)
%         model.update();
%         ModelTimer.start();
%     end
    
    switch(state)
        case State.INIT
%             disp("Main = INIT")
            homeObj.state = subState.INIT;
            state = State.DEBUG_WAIT;
            timer = timer.setTimer(3);
            nextState = State.HOME;
            %More init stuff here

        case State.HOME
            [homeObj,robot] = homeObj.update(robot);

            if(homeObj.state == subState.DONE)
%                 disp("Main -> APPROACH");
                nextState = State.APPROACH;
                state = State.DEBUG_WAIT;
                timer = timer.setTimer(0.25);
                cv = cv.forceRefreshEveryColor();
                approachObj.state = subState.INIT;
            end

        case State.APPROACH
%             disp("Main = APPROACH");
            [approachObj,robot, cv] = approachObj.update(robot, cv);
            if(approachObj.state == subState.DONE)
                nextState = State.GRAB;
%                 disp("Main -> GRAB");
                state = State.DEBUG_WAIT;
                timer = timer.setTimer(0.25);
                grabObj.state = subState.INIT;
            end

        case State.GRAB
%             disp("Main = GRAB");
            [grabObj,robot,cv] = grabObj.update(robot, cv);
            if(grabObj.state == subState.DONE)
%                 disp("Main -> TRAVEL");
                nextState = State.TRAVEL;
                state = State.DEBUG_WAIT;
                timer = timer.setTimer(0.25);
                travelObj.state = subState.INIT;
            end

        case State.TRAVEL
            [travelObj,robot,cv] = travelObj.update(robot, cv);
            if(travelObj.state == subState.DONE)
%                 disp("Main -> DROP");
                nextState = State.DROP;
                state = State.DEBUG_WAIT;
                timer = timer.setTimer(0.25);
                dropObj.state = subState.INIT;
            end

        case State.DROP
            [dropObj,robot] = dropObj.update(robot);
            if(dropObj.state == subState.DONE)
%                 disp("Main -> HOME");
                nextState = State.HOME;
                state = State.DEBUG_WAIT;
                timer = timer.setTimer(0.25);
                homeObj.state = subState.INIT;
            end

        case State.DEBUG_WAIT
%             disp("Debug Wait");
            if(timer.isTimerDone() == 1)
%                 disp("Main = DebugWaitDone");
                state = nextState;
                if(nextState == State.HOME)
                    robot.state = robotState.COMMS_WAIT;
                end
            end

    end
end

%% Shutdown Procedure
robot.shutdown()
cam.shutdown()
