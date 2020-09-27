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
    
    robot = Robot(myHIDSimplePacketComs);
    
    kine = Kinematics(95,100,100,[-90,90;-46,90;-86,63]);
    
    model = Model();
    model = model.calcPose(robot.getPositions());
    model = model.plotGraph();
    model.render();
    
    logger = Logger("log.txt");
    
    pathObj = Path_Planner();
    
    timer = EventTimer();
    renderTimer = EventTimer();
    renderTimer.setTimer(0);
    
    state = State.STARTNEXT;
    renderState = State.COMPUTE;
    
    height = 35;
    P1 = [100 -70 height];
    P2 = [160 10 height];
    P3 = [50 90 height];
    
    pathObj.queueOfPaths.enqueue([P1 P2 2 10 3])
    pathObj.queueOfPaths.enqueue([P2 P3 2 10 3])
    pathObj.queueOfPaths.enqueue([P3 P1 2 10 3])
    
    RENDER_RATE_MS = 100.0;
    tic
    while true
        if(renderTimer.isTimerDone() == 1)
            switch(renderState)
                case State.COMPUTE
                    disp("Compute");
                    currentPos = robot.getPositions();
                    model = model.calcPose(currentPos);
                    renderState = State.PRERENDER;
                        
                case State.PRERENDER
                    disp("PreRender");
                    model = model.plotGraph();
                    renderState = State.RENDER;
                case State.RENDER
                    disp("Render");
                    renderState = State.COMPUTE;
                    model.render();
            end
            renderTimer = renderTimer.setTimer(RENDER_RATE_MS/3000.0);
        end
        
        switch(state)
            case State.STOPPED
                disp("State -> STOPPED");
                timer = timer.setTimer(2);
                state = State.WAITING;
            case State.LONGWAIT
                %                 disp("State -> WAITING");
                if(timer.isTimerDone() == 1)
                    state = State.STARTNEXT;
                end
                
            case State.WAITING
                %                 disp("State -> WAITING");
                if(timer.isTimerDone() == 1)
                    state = State.RUNNING;
                end
            case State.RUNNING
                toc
                [pathObj,isDone,nextSetpoint] = pathObj.update();
                tic
                if(isDone == 1)
                    timer = timer.setTimer(2);
                    state = State.LONGWAIT;
                    disp("---END OF PATH---")
                else
                    robot.setSetpoints(rad2deg(kine.ik3001(nextSetpoint)));
                end
            case State.END
                
            case State.STARTNEXT
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
