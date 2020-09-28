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
pp = Robot(myHIDSimplePacketComs);
kine = Kinematics(95,100,100,[-90,90;-46,90;-86,63]);
robModel = Model();
try

p0 = [100 0 195];
% 3x1 matrix
% pd = [0; 0; 0];
robModel.selectionPlot();
input = ginput(1);
pd = [input(1); 0; input(2)];

Error = 0.01;
%final joint angles (qi in radians) 3X1
qi = kine.ik3001(p0)';
%disp(qi)
%error checking (mm) 3x1
fqi = p0;
while abs(pd(1) - fqi(1)) > Error || abs(pd(2) - fqi(2)) > Error || abs(pd(3) - fqi(3)) > Error
%   disp(pp.ik_3001_numerical(pd, qi, fqi))
    
    %disp(qi)
    robModel.plotArm(rad2deg(pp.ik_3001_numerical(pd, qi, fqi)));
    pause(0.0077);
    %update fqi and qi
    qi = pp.ik_3001_numerical(pd, qi, fqi);
    fqi = kine.FKtoTip(rad2deg(qi));
    if pp.atPosition(fqi,pd) == 1
       disp(rad2deg(qi));
    end
end


catch exception
    getReport(exception)
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
pp.shutdown()
