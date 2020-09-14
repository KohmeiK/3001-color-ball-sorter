
classdef Robot
    properties
        %hidDevice;
        %hidService;
        myHIDSimplePacketComs
        pol
        prevMoving = 1;
        setpointQueue
        isActive;
    end
    methods
        %The is a shutdown function to clear the HID hardware connection
        function  shutdown(packet)
            %Close the device
            packet.myHIDSimplePacketComs.disconnect();
        end
        % Create a packet processor for an HID device with USB PID 0x007
        function robot = Robot(oldRobot)
            robot.myHIDSimplePacketComs=oldRobot;
            robot.pol = java.lang.Boolean(false);
            robot.setpointQueue = queue;
        end
        %Perform a command cycle. This function will take in a command ID
        %and a list of 32 bit floating point numbers and pass them over the
        %HID interface to the device, it will take the response and parse
        %them back into a list of 32 bit floating point numbers as well
        function com = command(packet, idOfCommand, values)
            com= zeros(15, 1, 'single');
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
        
        % Yongxiang (Josh) Jin
        function position = getPositions(Robot)
            returnPacket = read(Robot, 1910);
            position = zeros(3,1);
            position(1) = returnPacket(3);
            position(2) = returnPacket(5);
            position(3) = returnPacket(7);
        end
        
        % Kohmei Kadoya
        function velocity = getVelocities(robot)
            returnPacket = read(robot, 1822);
            velocity = zeros(3, 1, 'single');
            velocity(1) = returnPacket(3);
            velocity(2) = returnPacket(6);
            velocity(3) = returnPacket(9);
        end
        
        % Jason will add setSetpoints here:
        function setSetpoints(robot,setpoint)
            packet = zeros(15, 1, 'single');
            packet(1) = 1000;%one second time
            packet(2) = 0;%linear interpolation
            packet(3) = setpoint(1); % -90 -> 90
            packet(4) = setpoint(2);% Second link to 90 -> -45
            packet(5) = setpoint(3);% Third link to -90 -> 45
            
            % Send packet to the server and get the response
            %pp.write sends a 15 float packet to the micro controller
            robot.write(1848, packet);
        end
        
        function moving = isMoving(robot)
            velocities = robot.getVelocities();
            if(mean(abs(velocities)) < 10)
                moving = 0;
            else
                moving = 1;
            end
        end
        
        function robot = updateRobot(robot)
            moving = robot.isMoving();
            if (robot.prevMoving == 1 && moving == 0)
                %Last move just ended
                if (robot.setpointQueue.Depth > 0)
                    disp("Moving to next setpoint");
                    robot.setSetpoints(robot.setpointQueue.dequeue())
                else
                    disp("No more setpoints left");
                    robot.isActive = 0;
                end
            end
            robot.prevMoving = moving;
        end
        
        function robot = deleteAllSetpoints(robot)
            disp("List of next Setpoint(s):")
            while robot.setpointQueue.Depth > 0
                disp(robot.setpointQueue.dequeue);
            end
            disp("All have been deleted")
            robot.isActive = 0;
        end
        
        function robot = enqueueSetpoint(robot,newSetpoint)
            robot.isActive = 1;
            robot.setpointQueue.enqueue(newSetpoint);
        end
        
        
    end
end
