close all
plotter = Plotter("log.txt");
data = plotter.getMatrix();

%convert time to secconds
data(:,1) = data(:,1)/1000;


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

kine = Kinematics();
posData = zeros(size(data,1),3);
for i = (1:size(data,1))
    disp(i)
    pos = kine.FKtoTip([data(i,2) data(i,3) data(i,4)]);
    posData(i,1) = pos(1);
    posData(i,2) = pos(2);
    posData(i,3) = pos(3);
end

figure
hold on
title("X-Z pos V.S. Time")
plot(data(:,1),posData(:,1))
plot(data(:,1),posData(:,3))
xlabel("Time (s)")
ylabel("X-Z Position (mm)")
legend("X Pos, Z Pos")
hold off

vertex = zeros(3,3);
disp(vertex(1))
disp(kine.FKtoTip([0 0 0]))
vertex(1,:) = kine.FKtoTip([0 0 0]);
vertex(2,:) = kine.FKtoTip([90 45 -45]);
vertex(3,:) = kine.FKtoTip([-90 -45 0]);

figure
hold on
title("Path of EE on X-Z Plane")
plot(posData(:,1),posData(:,3))
plot(vertex(:,1),vertex(:,3),"r*")
xlabel("X Position (mm)")
ylabel("Z Position (mm)")
hold off

figure
hold on
title("Path of EE on X-Y Plane")
plot(posData(:,1),posData(:,2))
plot(vertex(:,1),vertex(:,2),"r*")
xlabel("X Position (mm)")
ylabel("Y Position (mm)")
hold off

