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
%     syms t1 t2 t3;
%     syms d1 d2 d3;
%     syms a1 a2 a3;
%     syms alp1 alp2 alp3;
%     
%     
%     a = kine.SymbFKtoTip(t1, t2, t3, d1, d2,d3,a1,a2,a3,alp1,alp2,alp3);
%     b = [t1 t2 t3];
%     disp(a);
%     disp(b);
%     jacob = [ diff(a(1),b(1)) diff(a(1),b(2)) diff(a(1),b(3));
%         diff(a(2),b(1)) diff(a(2),b(2)) diff(a(2),b(3));
%         diff(a(3),b(1)) diff(a(3),b(2)) diff(a(3),b(3));
%         0 0 0;
%         0 0 0;
%         1 1 1];
%     
%     jacob= subs(jacob,d1,95);
%     jacob= subs(jacob,d2,0);
%     jacob= subs(jacob,d3,0);
%     
%     jacob= subs(jacob,a1,0);
%     jacob= subs(jacob,a2,100);
%     jacob= subs(jacob,a3,100);
%     
%     jacob= subs(jacob,alp1,-(pi/2));
%     jacob= subs(jacob,alp2,0);
%     jacob= subs(jacob,alp3,0);
%     
%     disp(jacob)
        
%     jacob = pp.jacob3001([0 0 deg2rad(-90)]);
%     jp = jacob(1:3,:);
%     det(jp)

q0 = [100 0 195];
pd = [160 10 35];
Error = 1;
% inside a loop
curModelPos = [100 0 195];
curFk = kine.FKtoTip(curModelPos);
while abs(pd(1) - curFk(1)) > Error && abs(pd(2) - curFk(2)) > Error && abs(pd(3) - curFk(3)) > Error
    curPos = curModelPos;
    fkcurPos = kine.FKtoTip(curPos);
    disp(rad2deg(kine.ik3001(pp.ik_3001_numerical(pd, curPos, fkcurPos))))
    robModel.plotArm(rad2deg(kine.ik3001(pp.ik_3001_numerical(pd, curPos, fkcurPos))));
    curModelPos = kine.ik3001(pp.ik_3001_numerical(pd, curPos, fkcurPos));
    curFk = kine.FKtoTip(curModelPos);
    disp("moveTime")
end 


    
catch exception
    getReport(exception)
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
pp.shutdown()
