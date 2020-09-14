close all
plotter = Plotter("log.txt");
%convert time to secconds
a = plotter.getMatrix();
a(:,1) = a(:,1)/1000;
figure
plot(a(:,1),a(:,2))
figure
plot(a(:,1),a(:,3))
figure
plot(a(:,1),a(:,4))