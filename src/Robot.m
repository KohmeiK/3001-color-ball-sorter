
classdef Robot
    properties
        myHIDSimplePacketComs %Kevin's
        pol %Kevin's
        prevAtTarget %in the previous update loop was the robot at the target pos?
        setpointQueue %A queue of setpoints for the robot to go to
        isActive %True (1) unless there are 0 setpoints and the arm is at target
        currentSetpoint %This is the no latency way of getting the arm's setpoint
    end
    methods
        %The is a shutdown function to clear the HID hardware connection
        function  shutdown(packet)
            %Close the device
            packet.myHIDSimplePacketComs.disconnect();
        end
        % Create a packet processor for an HID device with USB PID 0x007
        function robot = Robot(comms)
            robot.myHIDSimplePacketComs=comms;
            robot.pol = java.lang.Boolean(false);
            robot.setpointQueue = queue;
            robot.prevAtTarget = 0;
            robot.currentSetpoint = [0 0 0];
        end
        %Perform a command cycle. This function will take in a command ID
        %and a list of 32 bit floating point numbers and pass them over the
        %HID interface to the device, it will take the response and parse
        %them back into a list of 32 bit floating point numbers as well
        function com = command(packet, idOfCommand, values)
            com= zeros(15, 1, 'sindgle');
            try
                ds = javaArray('java.lang.Double',length(values));
                for i=1:length(values)
                    ds(i)= java.lang.Double(values(i));
                end
                % Default packet size for HID
                intid = java.lang.Integer(idOfCommand);
                %class(intid);
                %class(idOfCommand);
                %class(ds);
                packet.myHIDSimplePacketComs.writeFloats(intid,  ds);
                ret = 	packet.myHIDSimplePacketComs.readFloats(intid) ;
                for i=1:length(com)
                    com(i)= ret(i).floatValue();
                end
                %class(com)
            catch exception
                getReport(exception)
                disp('Command error, reading too fast');
            end
        end
        function com = read(packet, idOfCommand)
            com= zeros(15, 1, 'single');
            try
                
                % Default packet size for HID
                intid = java.lang.Integer(idOfCommand);
                %class(intid);
                %class(idOfCommand);
                %class(ds);
                ret = 	packet.myHIDSimplePacketComs.readFloats(intid) ;
                for i=1:length(com)
                    com(i)= ret(i).floatValue();
                end
                %class(com)
            catch exception
                getReport(exception)
                disp('Command error, reading too fast');
            end
        end
        function  write(packet, idOfCommand, values)
            try
                ds = javaArray('java.lang.Double',length(values));
                for i=1:length(values)
                    ds(i)= java.lang.Double(values(i));
                end
                % Default packet size for HID
                intid = java.lang.Integer(idOfCommand);
                %class(intid);
                %class(idOfCommand);
                %class(ds);
                packet.myHIDSimplePacketComs.writeFloats(intid,  ds,packet.pol);
                
            catch exception
                getReport(exception)
                disp('Command error, reading too fast');
            end
        end
        
        function  writeByte(packet, idOfCommand, values)
            try
                ds = javaArray('java.lang.Byte',length(values));
                for i=1:length(values)
                    ds(i)= java.lang.Byte(values(i));
                end
                % Default packet size for HID
                intid = java.lang.Integer(idOfCommand);
                class(intid);
                class(idOfCommand);
                class(ds);
                packet.myHIDSimplePacketComs.writeBytes(intid,  ds,packet.pol);
                
            catch exception
                getReport(exception)
                disp('Command error, reading too fast');
            end
        end
        
        %get a 3x1 matrix for the position of the arm angles
        function position = getPositions(Robot)
            returnPacket = read(Robot, 1910);
            %{
            disp(returnPacket(3));
            disp(returnPacket(5));
            disp(returnPacket(7));
            %}
            position = [returnPacket(3); returnPacket(5); returnPacket(7)];
            %disp(position);
        end
        
        %get a 3x1 matrix for the setpoint of the arm angles
        function setpoint = getSetpoints(Robot)
            returnPacket = read(Robot, 1910);
            setpoint = zeros(3,1);
            setpoint(1) = returnPacket(2);
            setpoint(2) = returnPacket(4);
            setpoint(3) = returnPacket(6);
        end
        
        %get a 3x1 matrix for the velocities of each servo
        function velocity = getVelocities(robot)
            returnPacket = read(robot, 1822);
            velocity = zeros(3, 1, 'single');
            velocity(1) = returnPacket(3);
            velocity(2) = returnPacket(6);
            velocity(3) = returnPacket(9);
            packet = zeros(15, 1, 'single');
            packet(1) = 1000;%0 second time
            packet(2) = 0;%linear interpolation
            packet(3) = setpoint(1); % -90 -> 90
            packet(4) = setpoint(2);% Second link to 90 -> -45
            packet(5) = setpoint(3);% Third link to -90 -> 45
            
            % Send packet to the server and get the response
            %pp.write sends a 15 float packet to the micro controller
            robot.write(1962, packet);        end
        
        %set a 3x1 matrix for the position of the arm angles
        function setSetpoints(robot,setpoint)
            packet = zeros(15, 1, 'single');
            packet(1) = 0;%0 second time
            packet(2) = 0;%linear interpolation
            packet(3) = setpoint(1); % -90 -> 90
            packet(4) = setpoint(2);% Second link to 90 -> -45
            packet(5) = setpoint(3);% Third link to -90 -> 45
            
            % Send packet to the server and get the response
            %pp.write sends a 15 float packet to the micro controller
            robot.write(1848, packet);
        end
        
                %set a 3x1 matrix for the position of the arm angles
        function setSetpointsSlow(robot,setpoint)
            packet = zeros(15, 1, 'single');
            packet(1) = 1000;%0 second time
            packet(2) = 0;%linear interpolation
            packet(3) = setpoint(1); % -90 -> 90
            packet(4) = setpoint(2);% Second link to 90 -> -45
            packet(5) = setpoint(3);% Third link to -90 -> 45
            
            % Send packet to the server and get the response
            %pp.write sends a 15 float packet to the micro controller
            robot.write(1848, packet);
        end
        
        function setGripper(robot,setpoint)
            packet = zeros(1, 1, 'single');
            packet(1) = setpoint;%0 degree
            
            % Send packet to the server and get the response
            %pp.write sends a 15 float packet to the micro controller
            robot.writeByte(1962, packet);
        end
        
        
        %return true if target position is "close enough" to the setpoint
        function atTarget = isAtTarget(robot)
            %get the live position of the arm
            positions = robot.getPositions();
            %use local setpoint to avoid 3ms delay (that causes bouncing)
            setpoints = robot.currentSetpoint';
            %I would do a boolean if I could
            if(mean(abs(positions-setpoints)) < 2)
                atTarget = 1;
            else
                atTarget = 0;
            end
        end
        
        %This is the state machine like main update loop for controlling
        %the order of setpoints
        function robot = updateRobot(robot)
            atTarget = robot.isAtTarget();
            if (robot.prevAtTarget == 0 && atTarget == 1)
                %Last move just ended (risindg edge)
                if (robot.setpointQueue.Depth > 0) %The queue has next setpoint
                    disp("Moving to next setpoint");
                    robot.currentSetpoint = robot.setpointQueue.dequeue();
                    disp(robot.currentSetpoint)
                    %send the setpoint to the arm
                    robot.setSetpoints(robot.currentSetpoint);
                    %now we are not at the target pos
                    atTarget = 0;
                else
                    disp("No more setpoints left!");
                    %send a signal to main to end program
                    robot.isActive = 0;
                end
            end
            %update prev values for next loop
            robot.prevAtTarget = atTarget;
        end
        
        %Not used but lists all the points the robot would have gone to
        function robot = deleteAllSetpoints(robot)
            disp("List of next Setpoint(s):")
            while robot.setpointQueue.Depth > 0
                disp(robot.setpointQueue.dequeue);
            end
            disp("All have been DELETED!")
            robot.isActive = 0;
        end
        
        %Add to the queue of setpoints
        function robot = enqueueSetpoint(robot,newSetpoint)
            robot.isActive = 1;
            robot.setpointQueue.enqueue(newSetpoint);
        end
        
        function returnVal = jacob3001(~, q)
            t1 = q(1);
            t2 = q(2) - 90;
            t3 = q(3) + 90;
            
            returnVal = [ (100*sind(t1)*sind(t2)*sind(t3) - 100*cosd(t2)*sind(t1) - 100*cosd(t2)*cosd(t3)*sind(t1)) (- 100*cosd(t1)*sind(t2) - 100*cosd(t1)*cosd(t2)*sind(t3) - 100*cosd(t1)*cosd(t3)*sind(t2)) (- 100*cosd(t1)*cosd(t2)*sind(t3) - 100*cosd(t1)*cosd(t3)*sind(t2));
                (100*cosd(t1)*cosd(t2) - 100*cosd(t1)*sind(t2)*sind(t3) + 100*cosd(t1)*cosd(t2)*cosd(t3)) (- 100*sind(t1)*sind(t2) - 100*cosd(t2)*sind(t1)*sind(t3) - 100*cosd(t3)*sind(t1)*sind(t2)) (- 100*cosd(t2)*sind(t1)*sind(t3) - 100*cosd(t3)*sind(t1)*sind(t2));
                (0)                           (100*sind(t2)*sind(t3) - 100*cosd(t2)*cosd(t3) - 100*cosd(t2))                   (100*sind(t2)*sind(t3) - 100*cosd(t2)*cosd(t3));
                0                                                                                0                                                         0;
                0                                                                                0                                                           0;
                1                                                                                 1                                                           1];
            
        end
        
        function p = fdk3001(obj, q, Qdot)
            p = obj.jacob3001(q) * Qdot;
        end
            
    end
end
