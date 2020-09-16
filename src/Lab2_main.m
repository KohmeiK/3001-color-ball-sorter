clear
clear java
clear classes;

vid = hex2dec('16c0');
pid = hex2dec('0486');

disp (vid);
disp (pid);

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


arm = Robot(myHIDSimplePacketComs);

t = 0;
m1 = -10;
m2 = 30;
m3 = 0;
SERV_ID = 1848;            % we will be talking to server ID 1848 on
% the Nucleo
SERVER_ID_READ =1910;% ID of the read packet
DEBUG   = true;         % enables/disables debug prints
val = 1;

% Instantiate a packet - the following instruction allocates 64
% bytes for this purpose. Recall that the HID interface supports
% packet sizes up to 64 bytes.
packet = zeros(15, 1, 'single');

%{
for k = 0:5
    %wating on converting this to setSetpoints untill Jason finsishes
    %the fucntion...
    packet = zeros(15, 1, 'single');
    packet(1) = 1000; %one second time
    packet(2) = 0; %linear interpolation
    packet(3) = m1; % rotation servo
    packet(4) = m2; % Second link
    packet(5) = m3; % Third link
    m1 = m1 + 10;
    m2 = m2 - 20;
    m3 = m3 -10;
    arm.write(SERV_ID, packet);
    disp(packet);
    % Send packet to the server and get the response
    %pp.write sends a 15 float packet to the micro controller
    %pp.read reads a returned 15 float backet from the micro controller.
    while t<20
        coord = arm.getPositions;
        %disp(arm.getPositions);
        FKmodel(coord(1,1), coord(2,1), coord(3,1));
        pause(0.5);
        t = t+1;
    end
end
%}


while val == 1
        coord = arm.getPositions;
        %disp(arm.getPositions);
        FKmodel(coord(1,1), coord(2,1), coord(3,1));
        pause(0.1);
end



