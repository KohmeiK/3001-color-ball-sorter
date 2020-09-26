%This script processes and formats data into tables
%This should be run after you have a log file

close all
plotter = Plotter("log.txt"); %create a plotter object from the file name
data = plotter.getMatrix(); %convert logfile into a matrix

%convert time to secconds since logfile stores in ms
data(:,1) = data(:,1)/1000;


%Plot motor angles (data(2-4)) against time (data(1))
figure
hold on
title("Motor Angles V.S. Time")
plot(data(:,1),data(:,2))
plot(data(:,1),data(:,3))
plot(data(:,1),data(:,4))
xlabel("Time (s)")
ylabel("Servo Angle (deg)")
legend("Motor 1","Motor 2","Motor 3")
hold off

kine = Kinematics(95,100,100,[0]); %load kinematics for FK
posData = zeros(size(data,1),3);

%for each row in the matrix run a FK and store in posData
for i = (1:size(data,1))
%     disp(i)
    pos = kine.FKtoTip([data(i,2) data(i,3) data(i,4)]);
    posData(i,1) = pos(1);
    posData(i,2) = pos(2);
    posData(i,3) = pos(3);
end

velo = diff(posData);
veloS = zeros(length(velo));


veloS(:,1) = smooth(velo(:,1),55,'rlowess');
veloS(:,2) = smooth(velo(:,2),55,'rlowess');
veloS(:,3) = smooth(velo(:,3),55,'rlowess');

velo(:,1) = smooth(velo(:,1),15,'rlowess');
velo(:,2) = smooth(velo(:,2),15,'rlowess');
velo(:,3) = smooth(velo(:,3),15,'rlowess');

accel = diff(veloS);
x = length(accel);
accelS = zeros([x-1 3]);

accelS(:,1) = smooth(accel(:,1),90,'rlowess');
accelS(:,2) = smooth(accel(:,2),90,'rlowess');
accelS(:,3) = smooth(accel(:,3),90,'rlowess');

accel(:,1) = smooth(accel(:,1),15,'rlowess');
accel(:,2) = smooth(accel(:,2),15,'rlowess');
accel(:,3) = smooth(accel(:,3),15,'rlowess');

for i = (1:size(data,1))
%     disp(i)
    pos = kine.FKtoTip([data(i,2) data(i,3) data(i,4)]);
    posData(i,1) = pos(1);
    posData(i,2) = pos(2);
    posData(i,3) = pos(3);
end

%Now plot FK against time
figure
hold on
title("X, Y, Z position V.S. Time")
plot(data(:,1),posData(:,1),"m")
plot(data(:,1),posData(:,2),"g")
plot(data(:,1),posData(:,3),"b")
xlabel("Time (s)")
ylabel("X, Y, Z Position (mm)")
legend("X Pos","Y Pos", "Z Pos")
hold off

figure
hold on
title("X, Y, Z velocity V.S. Time")
plot(data(1:length(velo(:,1)),1),velo(:,1),"m--")
plot(data(1:length(velo(:,1)),1),velo(:,2),"g--")
plot(data(1:length(velo(:,1)),1),velo(:,3),"b--")
plot(data(1:length(velo(:,1)),1),veloS(:,1),"m",'LineWidth',2)
plot(data(1:length(velo(:,1)),1),veloS(:,2),"g",'LineWidth',2)
plot(data(1:length(velo(:,1)),1),veloS(:,3),"b",'LineWidth',2)
xlabel("Time (s)")
ylabel("X, Y, Z Velocity (mm/sec)")
legend("X Velo","Y Velo", "Z Velo","Smooth X Velo","Smooth Y Velo", "Smooth Z Velo")
hold off

figure
hold on
title("X, Y, Z acceleration V.S. Time")
plot(data(1:length(accel(:,1)),1),accel(:,1),"m--")
plot(data(1:length(accel(:,1)),1),accel(:,2),"g--")
plot(data(1:length(accel(:,1)),1),accel(:,3),"b--")
plot(data(1:length(accel(:,1)),1),accelS(:,1),"m",'LineWidth',2)
plot(data(1:length(accel(:,1)),1),accelS(:,2),"g",'LineWidth',2)
plot(data(1:length(accel(:,1)),1),accelS(:,3),"b",'LineWidth',2)
xlabel("Time (s)")
ylabel("X, Y, Z acceleration (mm/sec^2)")
legend("X Acel","Y Acel", "Z Acel","Smooth X Acel","Smooth Y Acel", "Smooth Z Acel")
hold off

vertex = zeros(3,3);
%manually enter vertex points and run FK on them
vertex(1,:) = [100 -70 35];
vertex(2,:) = [160 10 35];
vertex(3,:) = [50 90 35];

%now plot both FK data and Vertext FK
figure
hold on
title("Path of EE on X-Z (Y)Plane")
plot(posData(:,1),posData(:,3))
plot(vertex(:,1),vertex(:,3),"r*")
xlabel("X Position (mm)")
ylabel("Z Position (mm)")
hold off

%repeat for Z plane
figure
hold on
title("Path of EE on X-Y (Z)Plane")
plot(posData(:,1),posData(:,2))
plot(vertex(:,1),vertex(:,2),"r*")
xlabel("X Position (mm)")
ylabel("Y Position (mm)")
hold off

%repeat for X plane
figure
hold on
title("Path of EE on Y-Z ((X)Plane")
plot(posData(:,2),posData(:,3))
plot(vertex(:,2),vertex(:,3),"r*")
xlabel("Y Position (mm)")
ylabel("Z Position (mm)")
hold off

% plotting in 3D
figure
% hold on
plot3(posData(:,1),posData(:,2),posData(:,3), vertex(:,1), vertex(:,2), vertex(:,3),"r*")
%plot3()
xlabel("Y Position (mm)")
ylabel("X Position (mm)")
zlabel("Z Position (mm)")
zlim([0 150]);
grid on;
title("3D Path of EE on X,Y,Z Plane")
hold off


%dDone!
