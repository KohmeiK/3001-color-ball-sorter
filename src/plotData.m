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

kine = Kinematics(); %load kinematics for FK
posData = zeros(size(data,1),3);

%for each row in the matrix run a FK and store in posData
for i = (1:size(data,1))
    disp(i)
    pos = kine.FKtoTip([data(i,2) data(i,3) data(i,4)]);
    posData(i,1) = pos(1);
    posData(i,2) = pos(2);
    posData(i,3) = pos(3);
end

%Now plot FK against time
figure
hold on
title("X-Z pos V.S. Time")
plot(data(:,1),posData(:,1))
plot(data(:,1),posData(:,3))
xlabel("Time (s)")
ylabel("X-Z Position (mm)")
legend("X Pos", "Z Pos")
hold off

vertex = zeros(3,3);
%manually enter vertex points and run FK on them
vertex(1,:) = kine.FKtoTip([0 0 0]);
vertex(2,:) = kine.FKtoTip([-24 102 -72]);
vertex(3,:) = kine.FKtoTip([90 61 -13]);

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
xlabel("X Position (mm)")
ylabel("Z Position (mm)")
hold off

%dDone!