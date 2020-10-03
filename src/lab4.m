%%
% RBE3001 - Main Controller File
% Boilerplate until line 32

clear
clear java
clear classes;
clear functions;
close all

vid = hex2dec('16c0');
pid = hex2dec('0486');

% disp (vid);
% disp (pid);

javaaddpath ../lib/SimplePacketComsJavaFat-0.6.4.jar;
import edu.wpi.SimplePacketComs.*;
import edu.wpi.SimplePacketComs.device.*;
import edu.wpi.SimplePacketComs.phy.*;
import java.util.*;
import org.hid4java.*;
version -java
myHIDSimplePacketComs=HIDfactory.get();
myHIDSimplePacketComs.setPid(pid);
myHIDSimplePacketComs.setVid(vid);
myHIDSimplePacketComs.connect();

% Create a PacketProcessor object to send data to the nucleo firmware
try
    
    
    %create all the objects we need
    robot = Robot(myHIDSimplePacketComs);
    kine = Kinematics(95,100,100,[-90,90;-46,90;-86,63]);
    model = Model();
    logger = Logger("log.txt");
    pathObj = Path_Planner();
    timer = EventTimer();
    
    %run one cycle of the model to avoid lag when first opening a model
    currentPos = robot.getPositions();
    currentAngVelo = robot.getVelocities();
    currentVelo = robot.fdk3001(currentPos,currentAngVelo);
    model = model.calcPose(currentPos,currentVelo);
    model = model.plotGraph();
    model.render();
    
    %rendering should start immedately
    renderTimer = EventTimer();
    renderTimer.setTimer(0);
    
    %set initial states on both state machines
    state = State.STARTNEXT;
    renderState = State.COMPUTE;
    
    %triangle of points from lab 3
    height = 35;
    P1 = [100 -70 height];
    P2 = [160 10 height];
    P3 = [50 90 height];
    
    %add the points to the queue
    pathObj.queueOfPaths.enqueue([P1 P2 1 20 3])
    pathObj.queueOfPaths.enqueue([P2 P3 1 20 3])
    pathObj.queueOfPaths.enqueue([P3 P1 1 20 3])
    
    %This is the graphics update rate
    RENDER_RATE_MS = 40.0;
    
    %to avoid calling toc wihtou tic
    tic
    while true
        
        %GRAPHICS STATE MACHINE
        if(renderTimer.isTimerDone() == 1)
            switch(renderState)
                case State.COMPUTE %Step 1
                    currentPos = robot.getPositions();
                    currentAngVelo = robot.getVelocities();
                    currentVelo = robot.fdk3001(currentPos, currentAngVelo);
                    model = model.calcPose(currentPos,currentVelo);
                    renderState = State.PRERENDER;
                case State.PRERENDER %Step 2
                    model = model.plotGraph();
                    renderState = State.RENDER;
                case State.RENDER %Step 3
                    renderState = State.COMPUTE;
                    model.render();
            end
            renderTimer = renderTimer.setTimer(RENDER_RATE_MS/3000.0);
        end
        
        %MAIN STATE MACHINE
        switch(state)
            case State.STOPPED %Call at End of path
                disp("State -> STOPPED");
                timer = timer.setTimer(2);
                state = State.WAITING;
            case State.LONGWAIT %For watiting between paths
                if(timer.isTimerDone() == 1)
                    state = State.STARTNEXT;
                end
                
            case State.WAITING %Not used
                if(timer.isTimerDone() == 1)
                    state = State.RUNNING;
                end
            case State.RUNNING %While in a path
                toc
                [pathObj,isDone,nextSetpoint] = pathObj.update();
                tic
                if(isDone == 1)
                    timer = timer.setTimer(2);
                    state = State.LONGWAIT;
                    disp("---END OF PATH---")
                else
                    robot.setSetpoints(kine.ik3001(nextSetpoint));
                end
                
            case State.END %To shut down robot
                
                
            case State.STARTNEXT %Start the next path
                pathObj = pathObj.startNextPath();
                state = State.RUNNING;                
        end
    end
    
    
    
    
    
catch exception
    getReport(exception)
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
robot.shutdown()
